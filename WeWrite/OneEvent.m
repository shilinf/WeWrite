//
//  OneEvent.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/16/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "OneEvent.h"

@implementation OneEvent

- (id) initWithOperation:(Boolean)aOperation CursorLocation:(int)aCursor Length:(int)aLength Content:(NSString*) aContent
{
    self = [super init];
    if (self) {
        operation = aOperation;
        cursorLocation = aCursor;
        length = aLength;
        content = [aContent copy];
    }
    return self;
}

- (Boolean) getOperation {
    return operation;
}

- (int) getLength {
    return length;
}

- (int) getCursorLocation {
    return cursorLocation;
}

- (NSString*) getContent {
    return content;
}

@end
