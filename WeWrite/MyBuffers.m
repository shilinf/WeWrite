//
//  MyBuffers.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/23/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "MyBuffers.h"

@implementation MyBuffers


+ (NSData *) sendEventFormatting: (OneEvent*) event
{
    WeWrite::Event eventBuffer;
    eventBuffer.set_location([event getCursorLocation]);
    std::string *cursorLocation = new std::string([[event getContent] UTF8String]);
    eventBuffer.set_content(cursorLocation->c_str());
    WeWrite::Event_EventType eventType;
    if ([event getOperation]) {
        eventType = WeWrite::Event_EventType_INSERT;
    }
    else {
        eventType = WeWrite::Event_EventType_DELETE;
    }
    eventBuffer.set_eventtype(eventType);
    return dataForMessageWeWrite(eventBuffer);
}

+ (OneEvent*) receiveEventFormatting: (NSData *) data
{
    WeWrite::Event eventBuffer;
    parseDelimitedMessageFromDataWeWrite(eventBuffer, data);
    OneEvent* resultEvent;
    BOOL op;
    if (eventBuffer.eventtype() == WeWrite::Event_EventType_INSERT) {
        op = false;
    }
    else {
        op = true;
    }
    resultEvent = [[OneEvent alloc] initWithOperation:op CursorLocation:eventBuffer.location() Length:1 Content:[NSString stringWithUTF8String:eventBuffer.content().c_str()]];
    return resultEvent;
}


@end
