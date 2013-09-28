//
//  AllEvents.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/27/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "AllEvents.h"
#import "OneEvent.h"

@implementation AllEvents

static NSMutableArray* allEvents;
static NSMutableArray* unwindEvents;

+ (id)sharedEvents {
    static AllEvents *sharedEvents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEvents = [[self alloc] init];
    });
    return sharedEvents;
}

-(id)init {
    if (self = [super init]) {
        allEvents = [[NSMutableArray alloc] init];
        unwindEvents = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) push:(id)oneObject
{
    [allEvents addObject:oneObject];
}

-(void) unwindPush:(id)oneObject
{
    [unwindEvents addObject:oneObject];
}



-(id) pop
{
    id item = nil;
    
    if ([allEvents count] != 0) {
        item = [allEvents lastObject];
        [allEvents removeLastObject];
    }
    return item;
}

-(id) unwindPop
{
    id item = nil;
    
    if ([unwindEvents count] != 0) {
        item = [unwindEvents lastObject];
        [unwindEvents removeLastObject];
    }
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

-(BOOL)unwindEmpty
{
    if([unwindEvents count] != 0) {
        return false;
    }
    else {
        return true;
    }
}




@end
