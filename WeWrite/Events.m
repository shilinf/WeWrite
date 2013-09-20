//
//  Events.m
//  WeWritew//  Created by Linfeng Shi on 9/18/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "Events.h"
#import "Stack.h"
#import "OneEvent.h"


@implementation Events
static Events* _sharedEvents = nil;
static Stack* allEvents = nil;

+(Events*)sharedEvents
{
    @synchronized([Events class])
    {
        if (!_sharedEvents)
            [[self alloc] init];
        return _sharedEvents;
    }
    return nil;
}


+(id)alloc
{
    @synchronized([Events class])
    {
        NSAssert(_sharedEvents == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedEvents = [super alloc];
        return _sharedEvents;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        s_array = [[NSMutableArray alloc] init];
    }
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
