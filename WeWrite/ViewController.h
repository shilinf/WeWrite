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

@property (weak, nonatomic) NSString *sessionName;
- (void) redoEventOp: (OneEvent*) event;
- (void) undoEventOp: (OneEvent*) event;

@end
