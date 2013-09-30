//
//  OneEvent.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/16/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "OneEvent.h"

@implementation OneEvent

-(id) init
{
    self = [super init];
    if (self) {
        orderID = -1;
        registrationID = -1;
        helpOrderID = -1;
    }
    return self;
}

- (id) initWithOperation:(int)aOperation CursorLocation:(int)aCursor Length:(int)aLength Content:(NSString*) aContent
{
    self = [super init];
    if (self) {
        operation = aOperation;
        cursorLocation = aCursor;
        length = aLength;
        content = [aContent copy];
        orderID = -1;
        registrationID = -1;
        helpOrderID = -1;
    }
    return self;
}

- (void) setHelpOperation :(int) op
{
    helperOperation = op;
}


- (int) getHelpOperation {
    return helperOperation;
}

- (void) setOperation :(int) op
{
    operation = op;
}


- (int) getOperation {
    return operation;
}

- (int32_t) getRegistrationID{
    return registrationID;
}
- (void) setRegistrationID:(int32_t)ID
{
    registrationID = ID;
}


- (int) getLength {
    return length;
}

- (int) getCursorLocation {
    return cursorLocation;
}

- (void) setCursorLocation:(int) location {
    cursorLocation = location;
}

- (void) setContent :(NSString *) cont{
    content = cont;
}


- (NSString*) getContent {
    return content;
}

- (void) setOrderID: (int64_t) ID
{
    orderID = ID;
}

- (int64_t) getOrderID
{
    return orderID;
}

- (void) setHelpOrderID: (int64_t) ID
{
    helpOrderID = ID;
}

- (int64_t) getHelpOrderID
{
    return helpOrderID;
}



@end
