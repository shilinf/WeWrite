//
//  RedoStack.h
//  WeWrite
//
//  Created by Linfeng Shi on 9/21/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedoStack : NSObject 
+ (id)sharedEvents;
- (void)push: (id)oneObject;
- (id) pop;
- (BOOL) empty;
- (void) clear;



@end
