//
//  IMLCTextView.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/16/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "IMLCTextView.h"
#import "Events.h"
#import "OneEvent.h"
#import "RedoStack.h"
#include "MyBuffers.h"

@implementation IMLCTextView
@synthesize transfer = _transfer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setDelegate:self];
        [_transfer init];
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    else if (action == @selector(copy:))
        return NO;
    else if (action == @selector(cut:))
        return NO;
    else if (action == @selector(select:))
        return NO;
    else if (action == @selector(selectAll:))
        return NO;
    
    return [super canPerformAction:action withSender:sender];
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
    NSLog(@"%@", event.getContent);
    //NSLog(@"%d", range.location);
    Events* allEvents = [Events sharedEvents];
    [allEvents push:event];
    RedoStack* myRedoStack = [RedoStack sharedEvents];
    [myRedoStack clear];
    
    
    
    
    
    
    
    
    if (range.length <= 1)
    {
        return YES;
    }
    
    return NO;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        [(UITapGestureRecognizer *)gestureRecognizer setNumberOfTapsRequired:1];
    }
    
    [super addGestureRecognizer:gestureRecognizer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
