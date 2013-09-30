//
//  OneEvent.h
//  WeWrite
//
//  Created by Linfeng Shi on 9/16/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OneEvent : NSObject
{
    int operation;
    int cursorLocation;
    int length;
    NSString* content;
    int32_t registrationID;
    int64_t orderID;
    int helperOperation;
}

// insert 0, delete 1, undo 2 (0 insert, 1 delete), redo 3 (0 insert, 1 delete)

- (id) initWithOperation:(int)aOperation CursorLocation:(int)aCursor Length:(int)aLength Content:(NSString*) aContent;
- (int) getOperation;
- (void) setOperation :(int) op;
- (int) getCursorLocation;
- (int) getLength;
- (int32_t) getRegistrationID;
- (void) setRegistrationID:(int32_t)ID;

- (NSString*) getContent;

- (void) setOrderID: (int64_t) ID;
- (int64_t) getOrderID;
- (void) setHelpOperation :(int) op;
- (int) getHelpOperation;
- (void) setCursorLocation:(int) location;

- (void) setContent :(NSString *)cont;
@end
