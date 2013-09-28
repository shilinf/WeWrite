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
#import "BufferParsing.h"
#import "AllEvents.h"


@interface ViewController () <CollabrifyClientDelegate, CollabrifyClientDataSource>
- (IBAction)Redo:(id)sender;
- (IBAction)Undo:(id)sender;
- (IBAction)CreateSession:(id)sender;
- (IBAction)JoinSession:(id)sender;
- (IBAction)LeaveSession:(id)sender;

@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) CollabrifyClient *client;
// data for base file
@property (strong, nonatomic) NSData * data;
@property int64_t sessionID;
@property (nonatomic) int64_t userId;


@property (retain, nonatomic) IBOutlet IMLCTextView *InputBox;


@end

@implementation ViewController

@synthesize tags = _tags;
@synthesize client = _client;
@synthesize data = _data;
@synthesize sessionID = _sessionID;
@synthesize userId = _userId;


@synthesize InputBox = _InputBox;

static NSMutableArray* localRegistrationID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        
        
        localRegistrationID =[[NSMutableArray alloc] init];
  
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_InputBox setDelegate:self];
    [_InputBox setScrollEnabled:YES];
    
    
    NSError *error;
    [self setClient:[[CollabrifyClient alloc] initWithGmail:@"shilinfeng.man@gmail.com"
                                                displayName:@"Linfeng Shi"
                                               accountGmail:@"441fall2013@umich.edu"
                                                accessToken:@"XY3721425NoScOpE"
                                             getLatestEvent:NO
                                                      error:&error]];
    [self setTags:@[@"stoneTag"]];
    [[self client] setDelegate:self];
    [[self client] setDataSource:self];

    
    
    
    
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
        [self redoEventOp:redoEvent];
        
        
        NSData* dataSend = [BufferParsing sendEventFormatting:redoEvent];
        int32_t registrationID =[[self client] broadcast:dataSend eventType:nil];
        [redoEvent setRegistrationID:registrationID];
        AllEvents* globalEvents = [AllEvents sharedEvents];
        [globalEvents push:redoEvent];
        [localRegistrationID addObject:[NSNumber numberWithInt:registrationID]];
    }
}

- (IBAction)Undo:(id)sender {
    Events* myEvents = [Events sharedEvents];
    if(![myEvents empty]) {
        OneEvent* undoEvent = [myEvents pop];
        RedoStack* myRedoStack = [RedoStack sharedEvents];
        OneEvent* newEvent;
        [self undoEventOp:undoEvent];
        if ([undoEvent getOperation]) { // delete 1 undo
            //[_InputBox setSelectedRange:NSMakeRange([undoEvent getCursorLocation], 0)];
            //[_InputBox insertText:[undoEvent getContent]];
            newEvent = [[OneEvent alloc]initWithOperation:0 CursorLocation:[undoEvent getCursorLocation] Length:1 Content:[undoEvent getContent]];
        }
        else { // insert 0 undo
            //[_InputBox setSelectedRange:NSMakeRange([undoEvent getCursorLocation]+1, 0)];
            //[_InputBox deleteBackward];
            newEvent = [[OneEvent alloc]initWithOperation:1 CursorLocation:[undoEvent getCursorLocation]+1 Length:1 Content:[undoEvent getContent]];
        }
        NSData* dataSend = [BufferParsing sendEventFormatting:newEvent];
        int32_t registrationID =[[self client] broadcast:dataSend eventType:nil];
        [newEvent setRegistrationID:registrationID];
        AllEvents* globalEvents = [AllEvents sharedEvents];
        [globalEvents push:newEvent];
        [localRegistrationID addObject:[NSNumber numberWithInt:registrationID]];
        [myRedoStack push:undoEvent];
    }
}

- (IBAction)CreateSession:(id)sender {
    [[self client] createSessionWithName:@"linfengSession4"
                                                tags:self.tags
                                            password:nil
                                         startPaused:NO
                                   completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                                       if(!error) {
                                           //TODO: update the interface to show the user that they have created a session
                                           _sessionID = sessionID;
                                           NSLog( @"%lld" , sessionID);
                                           //NSLog(@"abcdefg");
                                           
                                       }
                                       else {
                                           //TODO: handle the error
                                           
                                       }
                                   }
     ];
}

- (IBAction)JoinSession:(id)sender {
    //NSArray* sessionList = [[NSArray alloc] init];
    [[self client] listSessionsWithTags:[self tags]
                      completionHandler:^(NSArray *sessionList, CollabrifyError *error) {
                          NSLog(@"Available session: \n");
                          for (CollabrifySession *session in sessionList) {
                              NSLog(@"%@\n", session.sessionName);
                          }
                      }
    ];
    
    
    
    
    [self joinSessionWithsessionID:2553027];
    
}

- (IBAction)LeaveSession:(id)sender {
    
    
    
}





/**
 * Return the data offset by baseFilSize or nil if the size matches your base file's size
 *
 * @param client The client requesting the data source for a base file chunk.
 * @param baseFileSize The current size of the base file that has been uploaded
 * @return The base file chunk that the data source wants uploaded.
 * @warning Never returning nil from this method can result in an invite loop of uploading data and
 * receiving a request to continue uploading.
 * @warning Data is not requested on the main thread.
 */
/*
- (NSData *)client:(CollabrifyClient *)client requestsBaseFileChunkForCurrentBaseFileSize:(NSInteger)baseFileSize
{
    if (![self data])
    {
        NSString *string = @"THIS IS LINFENG SHI";
        [self setData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSInteger length = [[self data] length] - baseFileSize;
    if (length == 0)
    {
        return nil;
    }
    
    return [NSData dataWithBytes:((char *)[[self data] bytes] + baseFileSize) length:length];
}

*/



//Copy from Xu
- (void) joinSessionWithsessionID: (int64_t)sessionID
{
    [[self client] joinSessionWithID:sessionID
                            password:nil
                   completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error)
                   {
                       if (error) {
                           NSLog(@"!!!!!!Error class = %@", [error class]);
                           NSLog(@"!!!!!!Create Session Error = %@, %@, %@", error, [error domain], [error localizedDescription]);
                       } else {
                           _sessionID = sessionID;
                           NSLog( @"!!!");
                           NSLog( @"%lld" , sessionID);
                           //TODO: update local file
                           //NSLog(@"Session ID = %lli", sessionID);
                           NSLog(@"Session is protected = %i", [[self client] currentSessionIsPasswordProtected]);
                           int submissionID = [self.client broadcast:[@"test bc" dataUsingEncoding:NSUTF8StringEncoding] eventType:nil];
                           NSLog(@"%u",submissionID);
                       }
                   }];
    NSLog( @"???");
}
/**
 * Called when the a chunk of base file is received or when all of the chunks have been received.
 * When all data has been received, data is nil.
 *
 * @param client The client informing the delegate that it has received a base file chunk.
 * @param data The base file chunk in data form.
 * @warning This method is not called on the main thread.
 */
- (void) client:(CollabrifyClient *)client receivedBaseFileChunk:(NSData *)data
{
    if (data == nil) {
        //TODO: done
    }
    else {
        //TODO: handle data here, maybe by appending it to your current data
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        
        
        });
        
        
        
        
    }
}







- (void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO:
            
            OneEvent* receivedEvent = [BufferParsing receiveEventFormatting:data];
            NSUInteger index = [localRegistrationID indexOfObject:[NSNumber numberWithInt:submissionRegistrationID]];
            AllEvents* globalEvents = [AllEvents sharedEvents];
            if (index == NSNotFound) {
                [globalEvents push:receivedEvent];
            }
            else {
                [localRegistrationID removeObjectAtIndex:index];
                OneEvent* temp = [globalEvents pop];
                while([temp getRegistrationID] != submissionRegistrationID) {
                    [globalEvents unwindPush:temp];
                    [self undoEventOp:temp];
                    temp = [globalEvents pop];
                }
                [self undoEventOp:temp];
                OneEvent* temp2;
                while (![globalEvents unwindEmpty]) {
                    temp2 = [globalEvents unwindPop];
                    [self redoEventOp:temp2];
                    [globalEvents push:temp2];
                }
                [globalEvents push:temp];
                [self redoEventOp:temp];
            }
        });
    }
}

- (void) redoEventOp: (OneEvent*) event{
    if (![event getOperation]) { //insert redo
        [_InputBox setSelectedRange:NSMakeRange([event getCursorLocation], 0)];
        [_InputBox insertText:[event getContent]];
    }
    else { //delete redo
        [_InputBox setSelectedRange:NSMakeRange([event getCursorLocation]+1, 0)];
        [_InputBox deleteBackward];
    }
}

- (void) undoEventOp: (OneEvent*) event{
    if ([event getOperation]) { // delete 1 undo
        [_InputBox setSelectedRange:NSMakeRange([event getCursorLocation], 0)];
        [_InputBox insertText:[event getContent]];
    }
    else {
        [_InputBox setSelectedRange:NSMakeRange([event getCursorLocation]+1, 0)];
        [_InputBox deleteBackward];
    }
}



- (BOOL)textView:(IMLCTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString* tempStr=@"";
    tempStr=[textView text];
    //NSLog(@"%@", tempStr);
    //NSLog(@"%d", range.location);
    //NSLog(@"%d", range.length);
    OneEvent* event;
    if (!range.length) {
        event = [[OneEvent alloc]initWithOperation:range.length CursorLocation:range.location Length:1 Content: text];
    }
    else {
        if ([tempStr length]!=0) {
            event = [[OneEvent alloc]initWithOperation:range.length CursorLocation:range.location Length:1 Content:[tempStr substringWithRange:NSMakeRange(range.location, 1)]];
        }
    }
    //NSLog(@"%@", event.getContent);
    //NSLog(@"%d", range.location);

    NSData* dataSend = [BufferParsing sendEventFormatting:event];
    int32_t registrationID =[[self client] broadcast:dataSend eventType:nil];
    [event setRegistrationID:registrationID];
    
    Events* localEvents = [Events sharedEvents];
    [localEvents push:event];
    RedoStack* myRedoStack = [RedoStack sharedEvents];
    [myRedoStack clear];
    AllEvents* globalEvents = [AllEvents sharedEvents];
    [globalEvents push:event];
    [localRegistrationID addObject:[NSNumber numberWithInt:registrationID]];
    
    
    if (range.length <= 1)
    {
        return YES;
    }
    
    return NO;
}








@end
