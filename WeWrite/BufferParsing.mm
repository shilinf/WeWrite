//
//  BufferParsing.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/25/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "BufferParsing.h"

@implementation BufferParsing

+ (NSData *) sendEventFormatting: (OneEvent*) event
{
    WeWrite::Event eventBuffer;
    eventBuffer.set_location([event getCursorLocation]);
    std::string *cursorLocation = new std::string([[event getContent] UTF8String]);
    eventBuffer.set_content(cursorLocation->c_str());
    WeWrite::Event_EventType eventType;
    if ([event getOperation] == 0) {
        eventType = WeWrite::Event_EventType_INSERT;
    }
    else if([event getOperation] == 1){
        eventType = WeWrite::Event_EventType_DELETE;
    }
    else if([event getOperation] == 2){
        eventType = WeWrite::Event_EventType_UNDO;
    }
    else {
        eventType = WeWrite::Event_EventType_REDO;
    }
    eventBuffer.set_eventtype(eventType);
    
    eventBuffer.set_orderid(event.getOrderID);
    return dataForMessageWeWrite(eventBuffer);
}

+ (OneEvent*) receiveEventFormatting: (NSData *) data
{
    WeWrite::Event eventBuffer;
    parseDelimitedMessageFromDataWeWrite(eventBuffer, data);
    OneEvent* resultEvent;
    int op = -1;
    if (eventBuffer.eventtype() == WeWrite::Event_EventType_INSERT) {
        op = 0;
    }
    else if (eventBuffer.eventtype() == WeWrite::Event_EventType_DELETE){
        op = 1;
    }
    else if (eventBuffer.eventtype() == WeWrite::Event_EventType_UNDO){
        op = 2;
    }
    else if (eventBuffer.eventtype() == WeWrite::Event_EventType_REDO){
        op = 3;
    }
    resultEvent = [[OneEvent alloc] initWithOperation:op CursorLocation:eventBuffer.location() Length:1 Content:[NSString stringWithUTF8String:eventBuffer.content().c_str()]];
    [resultEvent setOrderID:eventBuffer.orderid()];
    return resultEvent;
}

NSData *parseDelimitedMessageFromDataWeWrite(::google::protobuf::Message &message, NSData *data)
{
    ::google::protobuf::io::ArrayInputStream arrayInputStream([data bytes], [data length]);
    ::google::protobuf::io::CodedInputStream codedInputStream(&arrayInputStream);
    
    uint32_t messageSize;
    codedInputStream.ReadVarint32(&messageSize);
    
    //lets not consume all the data
    codedInputStream.PushLimit(messageSize);
    message.ParseFromCodedStream(&codedInputStream);
    codedInputStream.PopLimit(messageSize);
    
    if ([data length] - codedInputStream.CurrentPosition() > 0)
    {
        return [NSData dataWithBytes:((char *)[data bytes] + codedInputStream.CurrentPosition()) length:[data length] - codedInputStream.CurrentPosition()];
    }
    return nil;
}

NSData *dataForMessageWeWrite(::google::protobuf::Message &message)
{
    const int bufferLength = message.ByteSize() + ::google::protobuf::io::CodedOutputStream::VarintSize32(message.ByteSize());
    std::vector<char> buffer(bufferLength);
    
    ::google::protobuf::io::ArrayOutputStream arrayOutput(&buffer[0], bufferLength);
    ::google::protobuf::io::CodedOutputStream codedOutput(&arrayOutput);
    
    codedOutput.WriteVarint32(message.ByteSize());
    message.SerializeToCodedStream(&codedOutput);
    
    return [NSData dataWithBytes:&buffer[0] length:bufferLength];
}

@end
