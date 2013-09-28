//
//  AllEvents.h
//  WeWrite
//
//  Created by Linfeng Shi on 9/27/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllEvents : NSObject

+ (id)sharedEvents;
- (void)push: (id)oneObject;
-(void) unwindPush:(id)oneObject;
- (id) pop;
-(id) unwindPop;
- (BOOL) empty;
-(BOOL)unwindEmpty;
@end
