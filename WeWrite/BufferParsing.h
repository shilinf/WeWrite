//
//  BufferParsing.h
//  WeWrite
//
//  Created by Linfeng Shi on 9/25/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <google/protobuf/io/zero_copy_stream_impl_lite.h>
#import <google/protobuf/io/coded_stream.h>
#import "WeWriteProtocal.pb.h"

@interface BufferParsing : NSObject

NSData *parseDelimitedMessageFromDataWeWrite(::google::protobuf::Message &message, NSData *data);

NSData *dataForMessageWeWrite(::google::protobuf::Message &message);

@end
