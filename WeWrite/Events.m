//
//  Events.m
//  WeWritew//  Created by Linfeng Shi on 9/18/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "Events.h"
#import "Stack.h"
#import "OneEvent.h"


@implementation Events

static NSMutableArray* allEvents;

+ (id)sharedEvents {
    static Events *sharedEvents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEvents = [[self alloc] init];
    });
    return sharedEvents;
}

-(id)init {
    if (self = [super init]) {
        allEvents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (int) count
{
    return [allEvents count];
}

- (id) getIndex: (int) index
{
    return [allEvents objectAtIndex:index];
}

- (void) setIndex: (id) object at: (int) index
{
    [allEvents setObject:object atIndexedSubscript:index];
}

-(void) push:(id)oneObject
{
    [allEvents addObject:oneObject];
    //NSLog(@"%d", [allEvents count]);
    //NSLog(@"%@", oneObject);
}

-(id) pop
{
    id item = nil;
    //NSLog(@"%d", [allEvents count]);

    if ([allEvents count] != 0) {
        item = [allEvents lastObject];
        [allEvents removeLastObject];
    }
    //NSLog(@"%d", [allEvents count]);
    return item;
}
-(BOOL)empty
{
    if([allEvents count] != 0) {
        return false;
    }
    else {
        return true;
    }
}
@end
