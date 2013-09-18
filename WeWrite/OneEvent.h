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
    Boolean operation;
    int cursorLocation;
    int length;
    NSString* content;
}

- (id) initWithOperation:(Boolean)aOperation CursorLocation:(int)aCursor Length:(int)aLength Content:(NSString*) aContent;
- (Boolean) getOperation;
- (int) getCursorLocation;
- (int) getLength;
- (NSString*) getContent;
@end
