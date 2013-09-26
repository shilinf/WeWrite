//
//  InformationTransfer.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/23/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "InformationTransfer.h"

@interface InformationTransfer() <CollabrifyClientDelegate, CollabrifyClientDataSource>

@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) CollabrifyClient *client;
@property (strong, nonatomic) NSData *data;

@end

@implementation InformationTransfer

@synthesize tags = _tags;
@synthesize client = _client;
@synthesize data = _data;
@synthesize sessionId = _sessionId;
@synthesize userId = _userId;

- (id) init
{
    self = [super init];
    if(self) {
        NSError *error;
        [self setClient:[[CollabrifyClient alloc] initWithGmail:@"shilinfeng.man@gmail.com"
                                                    displayName:@"Linfeng Shi"
                                                   accountGmail:@"441fall2013@umich.edu"
                                                    accessToken:@"XY3721425NoScOpE"
                                                 getLatestEvent:NO
                                                          error:&error]];
        [self setTags:@[@"stoneTag"]];
        [[self client] setDelegate:self];
        [[self client] setDataSource:self];
    }
    return self;
}

- (int64_t) createSession
{
    [[self client] createSessionWithBaseFileWithName:@"linfengSession1"
                                                tags:self.tags
                                            password:nil
                                         startPaused:NO
                                   completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                                       if(!error) {
                                       //TODO: update the interface to show the user that they have created a session
                                       
                                       }
                                       else {
                                       //TODO: handle the error
                                       
                                       
                                       }
                                   }
     ];
    return _sessionId;
}

/**
 * Return the data offset by baseFilSize or nil if the size matches your base file's size
 *
 * @param client The client requesting the data source for a base file chunk.
 * @param baseFileSize The current size of the base file that has been uploaded
 * @return The base file chunk that the data source wants uploaded.
 * @warning Never returning nil from this method can result in an invite loop of uploading data and
 * receiving a request to continue uploading.
 * @warning Data is not requested on the main thread.
 */
- (NSData *)client:(CollabrifyClient *)client requestsBaseFileChunkForCurrentBaseFileSize:(NSInteger)baseFileSize
{
    if (![self data])
    {
        NSString *string = @"THIS IS DATA EXAMPLE";
        [self setData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSInteger length = [[self data] length] - baseFileSize;
    if (length == 0)
    {
        return nil;
    }
    return [NSData dataWithBytes:([[self data] bytes] + baseFileSize) length:length];
}


/**
 * Called when the a chunk of base file is received or when all of the chunks have been received.
 * When all data has been received, data is nil.
 *
 * @param client The client informing the delegate that it has received a base file chunk.
 * @param data The base file chunk in data form.
 * @warning This method is not called on the main thread.
 */
- (void) client:(CollabrifyClient *)client receivedBaseFileChunk:(NSData *)data
{
    if (data == nil) {
        //TODO: done
    }
    else {
        //TODO: handle data here, maybe by appending it to your current data
    }
}


- (void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (string)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO:
            
            
        });
    }
}



@end
