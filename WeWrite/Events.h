//
//  Events.h
//  WeWrite
//
//  Created by Linfeng Shi on 9/18/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stack.h"

@interface Events : NSObject {
}
+ (id)sharedEvents;
- (void)push: (id)oneObject;
- (id) pop;
- (BOOL) empty;
@end