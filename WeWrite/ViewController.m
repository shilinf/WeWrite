//
//  ViewController.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/16/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"
#import "Events.h"
#import "RedoStack.h"
#import "OneEvent.h"

@interface ViewController ()
- (IBAction)Redo:(id)sender;
- (IBAction)Undo:(id)sender;
@property (retain, nonatomic) IBOutlet IMLCTextView *InputBox;

@end

@implementation ViewController

//@synthesize InputBox = _InputBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Redo:(id)sender {
    RedoStack* myRedoStack = [RedoStack sharedEvents];
    if(![myRedoStack empty]) {
        OneEvent* redoEvent = [myRedoStack pop];
        Events* myEvents = [Events sharedEvents];
        [myEvents push:redoEvent];
        if (![redoEvent getOperation]) { //insert redo
            [_InputBox setSelectedRange:NSMakeRange([redoEvent getCursorLocation], 0)];
            [_InputBox insertText:[redoEvent getContent]];
        }
        else { //delete redo
            [_InputBox setSelectedRange:NSMakeRange([redoEvent getCursorLocation]+1, 0)];
            [_InputBox deleteBackward];
        }
    }
}

- (IBAction)Undo:(id)sender {
    Events* myEvents = [Events sharedEvents];
    if(![myEvents empty]) {
        OneEvent* undoEvent = [myEvents pop];
        RedoStack* myRedoStack = [RedoStack sharedEvents];
        if ([undoEvent getOperation]) { // delete undo
            [_InputBox setSelectedRange:NSMakeRange([undoEvent getCursorLocation], 0)];
            [_InputBox insertText:[undoEvent getContent]];
        }
        else { // insert undo
            [_InputBox setSelectedRange:NSMakeRange([undoEvent getCursorLocation]+1, 0)];
            [_InputBox deleteBackward];
        }
        //OneEvent* event = [[OneEvent alloc]initWithOperation:range.length CursorLocation:range.location Length:1 Content:[tempStr substringWithRange:NSMakeRange(range.location , 1)]];
        [myRedoStack push:undoEvent];
    }
}
@end
