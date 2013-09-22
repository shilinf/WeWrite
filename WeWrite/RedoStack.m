//
//  RedoStack.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/21/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "RedoStack.h"
#import "OneEvent.h"

@implementation RedoStack

static NSMutableArray* redoEvents;


+ (id)sharedEvents {
    static RedoStack *sharedEvents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEvents = [[self alloc] init];
    });
    return sharedEvents;
}

-(id)init {
    if (self = [super init]) {
        redoEvents = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) push:(id)oneObject
{
    [redoEvents addObject:oneObject];
    //NSLog(@"%d", [redoEvents count]);
    //NSLog(@"%@", oneObject);
}

-(id) pop
{
    id item = nil;
    //NSLog(@"%d", [redoEvents count]);
    
    if ([redoEvents count] != 0) {
        item = [redoEvents lastObject];
        [redoEvents removeLastObject];
    }
    //NSLog(@"%d", [redoEvents count]);
    return item;
}
-(BOOL)empty
{
    if([redoEvents count] != 0) {
        return false;
    }
    else {
        return true;
    }
}

-(void)clear
{
    [redoEvents removeAllObjects];
}

@end
