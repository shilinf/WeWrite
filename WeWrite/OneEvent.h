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
    BOOL operation;
    int cursorLocation;
    int length;
    NSString* content;
    int32_t registrationID;
}

- (id) initWithOperation:(BOOL)aOperation CursorLocation:(int)aCursor Length:(int)aLength Content:(NSString*) aContent;
- (BOOL) getOperation;
- (void) modifyOperation;
- (int) getCursorLocation;
- (int) getLength;
- (int32_t) getRegistrationID;
- (void) setRegistrationID:(int32_t)ID;
- (NSString*) getContent;
@end
