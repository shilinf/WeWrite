//
//  ViewController.h
//  WeWrite
//
//  Created by Linfeng Shi on 9/16/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMLCTextView.h"
#import <Collabrify/Collabrify.h>
#import "OneEvent.h"

@interface ViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *version;
@property NSUInteger cursorLocation;
//@property NSUInteger count;
//@property (strong, nonatomic) NSString *context;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *sessionName;
@property (strong, nonatomic) NSMutableString *allText;
- (void) redoEventOp: (OneEvent*) event;
- (void) undoEventOp: (OneEvent*) event;

@end
