//
//  MyBuffers.h
//  WeWrite
//
//  Created by Linfeng Shi on 9/23/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeWriteProtocal.pb.h"
#import "OneEvent.h"

@interface MyBuffers : NSObject {
}

+ (NSData *) sendEventFormatting: (OneEvent*) event;

+ (OneEvent*) receiveEventFormatting: (NSData *) data;

@end
