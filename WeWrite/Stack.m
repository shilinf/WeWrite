//
//  Stack.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/19/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "Stack.h"

@implementation Stack
- (id)init
{
    s_array = [[NSMutableArray alloc] init];
    return self;
}

-(void) push:(id)oneObject
{
    [s_array addObject:oneObject];
}

-(id) pop
{
    id item = nil;
    if ([s_array count] != 0) {
        item = [s_array lastObject];
        [s_array removeLastObject];
    }
    return item;
}
-(BOOL)empty
{
    if([s_array count] != 0) {
        return false;
    }
    else {
        return true;
    }
}

@end
