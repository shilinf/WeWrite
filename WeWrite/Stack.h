//
//  Stack.h
//  WeWrite
//
//  Created by Linfeng Shi on 9/19/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject {
    NSMutableArray* s_array;
}

- (void)push: (id)oneObject;
- (id) pop;
- (BOOL) empty;

@end
