//
//  ViewController.m
//  WeWrite
//
//  Created by Linfeng Shi on 9/16/13.
//  Copyright (c) 2013 Linfeng Shi. All rights reserved.
//

#import "ViewController.h"
#import "Events.h"
#import "RedoStack.h"
#import "BufferParsing.h"
#import "AllEvents.h"


@interface ViewController () <CollabrifyClientDelegate, CollabrifyClientDataSource>
- (IBAction)Redo:(id)sender;
- (IBAction)Undo:(id)sender;
- (IBAction)JoinSession:(id)sender;
- (IBAction)LeaveSession:(id)sender;
- (IBAction)CreateSession:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CreateSession_outlet;


@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) CollabrifyClient *client;
// data for base file
@property (strong, nonatomic) NSData * data;
@property int64_t sessionID;
@property (nonatomic) int64_t userId;


@property (retain, nonatomic) IBOutlet IMLCTextView *InputBox;

@end


@implementation ViewController

@synthesize tags = _tags;
@synthesize client = _client;
@synthesize data = _data;
@synthesize sessionID = _sessionID;
@synthesize userId = _userId;
@synthesize sessionName = _sessionName;
@synthesize timer = _timer;
@synthesize version = _version;
@synthesize allText = _allText;
@synthesize cursorLocation = _cursorLocation;
//@synthesize count = _count;
//@synthesize context = _context;


@synthesize InputBox = _InputBox;

static NSMutableArray* localRegistrationID;
static NSMutableArray* unconfirmedEvents;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        
        
          
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [_InputBox setDelegate:self];
    [_InputBox setScrollEnabled:YES];
    
    
    NSError *error;
    [self setClient:[[CollabrifyClient alloc] initWithGmail:@"shilinf@umich.edu"
                                                displayName:@"Linfeng"
                                               accountGmail:@"441fall2013@umich.edu"
                                                accessToken:@"XY3721425NoScOpE"
                                             getLatestEvent:NO
                                                      error:&error]];
    [self setTags:@[@"shilinf"]];
    [[self client] setDelegate:self];
    [[self client] setDataSource:self];

    
    localRegistrationID =[[NSMutableArray alloc] init];
    unconfirmedEvents =[[NSMutableArray alloc] init];
    _timer = [[NSTimer alloc] init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
    _version = @"Individual";
    _allText = [[NSMutableString alloc] init];
    

    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
    
    
}


- (void) refreshView
{
    
    if(![_version isEqualToString:@"Individual"]) {
        _cursorLocation =[_InputBox selectedRange].location;
        
    //AllEvents* globalEvents = [AllEvents sharedEvents];
    //NSMutableString *allText;
        /*if(_context != nil) {
    
            allText= [[NSMutableString alloc] initWithString:nil];
        }
        else {
            allText = [[NSMutableString alloc] init];
        }*/
    //allText = [[NSMutableString alloc] init];
    
    /*for (int i=0;i<[globalEvents count];i++) {
        NSLog(@"%d", i);
        OneEvent* currentEvent = [globalEvents get:i];
        if (currentEvent.getOperation) { // delete
            [_allText deleteCharactersInRange:NSMakeRange(currentEvent.getCursorLocation, 1)];

        }
        else{ //insert
            [_allText insertString:currentEvent.getContent atIndex:currentEvent.getCursorLocation];
        }
        
    }*/
    
    
    //[_InputBox setEditable:NO];
        NSString *tempString = [NSString stringWithString:_allText];
        
        NSMutableString *textTemp = [[NSMutableString alloc] initWithString:tempString];
        

        int uncommitCount = [unconfirmedEvents count];
        OneEvent *temp;
        for(int i=0;i<uncommitCount;i++) {
            temp = [unconfirmedEvents objectAtIndex:i];
            if ([temp getOperation] == 0) {
                NSLog(@"@%d", temp.getCursorLocation);
                [textTemp insertString:temp.getContent atIndex:temp.getCursorLocation];
            }
            else if([temp getOperation] == 1){
                [textTemp deleteCharactersInRange:NSMakeRange(temp.getCursorLocation, 1)];
            }
        }
    
    
        
        
        
        
    
        NSString *textReplace = [NSString stringWithString:textTemp];
        [_InputBox setSelectedRange:NSMakeRange(0, _InputBox.text.length)];
        [_InputBox setText:textReplace];
        [_InputBox setSelectedRange:NSMakeRange(_cursorLocation, 0)];
    }
    
    //[_InputBox setEditable:YES];

}




-(void)dismissKeyboard {
    [_InputBox resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Redo:(id)sender {
    RedoStack* myRedoStack = [RedoStack sharedEvents];
    OneEvent* redoEvent;
    Events* myEvents = [Events sharedEvents];

    if(![myRedoStack empty]) {
        
        if([_version isEqualToString:@"Individual"]) {

        redoEvent = [myRedoStack pop];
                [myEvents push:redoEvent];
        [self redoEventOp:redoEvent];
        
        
        NSData* dataSend = [BufferParsing sendEventFormatting:redoEvent];
        int32_t registrationID =[[self client] broadcast:dataSend eventType:nil];
        [redoEvent setRegistrationID:registrationID];
        //AllEvents* globalEvents = [AllEvents sharedEvents];
        //[globalEvents push:redoEvent];
        //[localRegistrationID addObject:[NSNumber numberWithInt:registrationID]];
        }
        else {
            
            // Send the redo operation to server
            redoEvent = [myRedoStack pop];
            if([redoEvent getOperation] == 0) {
                [redoEvent setHelpOperation:0];
            }
            else if([redoEvent getOperation] == 1) {
                [redoEvent setHelpOperation:1];
            }
            [redoEvent setOperation:3];
            NSData* dataSend = [BufferParsing sendEventFormatting:redoEvent];
            int32_t registrationID =[[self client] broadcast:dataSend eventType:nil];
            [myEvents push:redoEvent];
        }
    }
    
    
}

- (IBAction)Undo:(id)sender {
    Events* myEvents = [Events sharedEvents];
    OneEvent* undoEvent;
    RedoStack* myRedoStack = [RedoStack sharedEvents];
    OneEvent* newEvent;
    if(![myEvents empty]) {
        
        if([_version isEqualToString:@"Individual"]) {
        
            undoEvent = [myEvents pop];
        [self undoEventOp:undoEvent];
        if ([undoEvent getOperation]) { // delete 1 undo
            newEvent = [[OneEvent alloc]initWithOperation:0 CursorLocation:[undoEvent getCursorLocation] Length:1 Content:[undoEvent getContent]];
        }
        else { // insert 0 undo
            newEvent = [[OneEvent alloc]initWithOperation:1 CursorLocation:[undoEvent getCursorLocation]+1 Length:1 Content:[undoEvent getContent]];
        }
        //NSData* dataSend = [BufferParsing sendEventFormatting:newEvent];
        //int32_t registrationID =[[self client] broadcast:dataSend eventType:nil];
        //[newEvent setRegistrationID:registrationID];
        //AllEvents* globalEvents = [AllEvents sharedEvents];
        //[globalEvents push:newEvent];
        //[localRegistrationID addObject:[NSNumber numberWithInt:registrationID]];
        [myRedoStack push:undoEvent];
        }
        else {
            //OneEvent* newEvent;
            int64_t localOrderID = [[myEvents getIndex:[myEvents count]-1] getOrderID];
            if (localOrderID== -1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Undo"
                                                                message:@"Please wait for the server to confirm your last event!"
                                                               delegate:self
                                                      cancelButtonTitle:@"Confirm"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        undoEvent = [myEvents pop];
            NSLog(@"HIJOIJOIJOIJOIJOIJOIJOIJOI %lld", localOrderID);
            [undoEvent setOrderID:localOrderID];
            if([undoEvent getOperation] == 0) {
                [undoEvent setHelpOperation:0];
            }
            else if([undoEvent getOperation] == 1) {
                [undoEvent setHelpOperation:1];
            }
            [undoEvent setOperation:2];

        NSData* dataSend = [BufferParsing sendEventFormatting:undoEvent];
        int32_t registrationID =[[self client] broadcast:dataSend eventType:nil];
        [myRedoStack push:undoEvent];
        
        
        
        
        }
    }
}







- (IBAction)CreateSession:(id)sender {
    
    
    if ([_InputBox hasText]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Session"
                                                        message:@"Please create session with empty textbox"
                                                       delegate:self
                                              cancelButtonTitle:@"Confirm"
                                              otherButtonTitles:nil];
        [alert show];

    }
    else {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Session"
                                                    message:@"Please enter session name:"
                                                   delegate:self
                                          cancelButtonTitle:@"Confirm"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert show];
    }
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1) {
        _sessionName = [[alertView textFieldAtIndex:0] text];
        NSLog(@"!!!Entered: %@",_sessionName);
        [[self client] createSessionWithName:_sessionName
                                        tags:self.tags
                                    password:nil
                                 startPaused:NO
                           completionHandler:^(int64_t sessionID, CollabrifyError *error) {
                               if(!error) {
                                   //TODO: update the interface to show the user that they have created a session
                                   _sessionID = sessionID;
                                   _version = @"Collabrify";
                                   //_context = [_InputBox text];
                                   //if (_context != nil) {
                                   //[self client:[self client] uploadedBaseFileWithSize:[_context length]];
                                   //}
                                   //else {
                                   //[self client:[self client] uploadedBaseFileWithSize: 0];
                                   //}
                               }
                               else {
                                   //TODO: handle the error
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Session"
                                                                                   message:@"Session name already exists. Please enter new name:"
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"Confirm"
                                                                         otherButtonTitles:nil];
                                   alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                                   alert.tag = 1;
                                   [alert show];
                                   
                                   
                               }
                           }
        ];
    }
    
    
    else if(alertView.tag == 2) {
        [[self client] listSessionsWithTags:[self tags]
                          completionHandler:^(NSArray *sessionList, CollabrifyError *error) {
                              BOOL exit = false;
                              NSString *inputName = [[alertView textFieldAtIndex:0] text];
                              for (CollabrifySession *session in sessionList) {
                            
                                  if([session.sessionName isEqualToString:inputName]) {
                                      exit = true;
                                      [self joinSessionWithsessionID:session.sessionID];
                                      _version = @"Collabrify";
                                      break;
                                  }
                              }
                              if (!exit) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Session"
                                                                                  message:@"No session with input session name exists!"
                                                                                 delegate:self
                                                                        cancelButtonTitle:@"Confirm"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }
                          }
        ];
    }

}



- (IBAction)JoinSession:(id)sender {
    
    
    if ([_InputBox hasText]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Session"
                                                        message:@"Please join session with empty textbox"
                                                       delegate:self
                                              cancelButtonTitle:@"Confirm"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Join Session"
                                                    message:@"Please enter session name:"
                                                   delegate:self
                                          cancelButtonTitle:@"Confirm"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 2;
    [alert show];
    }
    
}

- (IBAction)LeaveSession:(id)sender {
    
    [[self client] leaveAndDeleteSession:NO completionHandler:^(BOOL success, CollabrifyError *error){
        if(!success) {
            NSLog(@"Leave session error");
        }
    }];
    
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
        NSString *string = [_InputBox text];
        [self setData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSInteger length = [[self data] length] - baseFileSize;
    if (length == 0)
    {
        return nil;
    }
    
    return [NSData dataWithBytes:((char*)[[self data] bytes] + baseFileSize) length:length];
}




- (void) joinSessionWithsessionID: (int64_t)sessionID
{
    [[self client] joinSessionWithID:sessionID
                            password:nil
                   completionHandler:^(int64_t maxOrderID, int32_t baseFileSize, CollabrifyError *error)
                   {
                       if (error) {
                           NSLog(@"Join Session Error = %@, %@, %@", error, [error domain], [error localizedDescription]);
                       } else {
                       }
                   }];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
}



- (void) client:(CollabrifyClient *)client receivedEventWithOrderID:(int64_t)orderID submissionRegistrationID:(int32_t)submissionRegistrationID eventType:(NSString *)eventType data:(NSData *)data
{
    NSLog(@"%@", data);
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF16StringEncoding];
   // NSLog(@"!!!%@", string);
    
    if (string)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO:
            NSLog(@"%@", data);
            if(data != nil) {
            OneEvent* receivedEvent = [BufferParsing receiveEventFormatting:data];
            //NSLog(@"test whether receive event");
            //NSLog(@"%@", [receivedEvent getContent]);
            NSUInteger index = NSNotFound;
                
                NSLog(@"???????%lld", [receivedEvent getOrderID]);

                
                
            if([localRegistrationID count] !=0) {
                index = [localRegistrationID indexOfObject:[NSNumber numberWithInt:submissionRegistrationID]];
                [localRegistrationID removeObjectAtIndex:index];
            }
                
                if(([receivedEvent getOperation]==0 || [receivedEvent getOperation] == 1 )&& submissionRegistrationID != -1){
                    //if([unconfirmedEvents ])
                    //NSLog(@"???????%d", uncommitCount);
                    
                for (int i=0;i<[unconfirmedEvents count];i++) {
                    NSLog(@"%@", [[unconfirmedEvents objectAtIndex:i] getContent]);
                    if ([[unconfirmedEvents objectAtIndex:i] getRegistrationID] == submissionRegistrationID) {
                        [unconfirmedEvents removeObjectAtIndex:i];
                        break;
                    }
                }
                }
                
                
                [receivedEvent setRegistrationID:submissionRegistrationID];
                            AllEvents* globalEvents = [AllEvents sharedEvents];
                            Events *localEvents = [Events sharedEvents];
                OneEvent* temp;
                
                
                for(int i=[localEvents count]-1; i>=0;  i--) {
                    if ([[localEvents getIndex:i] getRegistrationID] == submissionRegistrationID) {
                        temp = [localEvents getIndex:i];
                        [temp setOrderID:orderID];
                        [localEvents setIndex:temp at:i];
                    }
                }
    
        
                
                NSLog(@"%lld",orderID);
                
                
                if (receivedEvent.getOperation == 1) { // delete
                    [receivedEvent setOrderID:orderID];
                    [_allText deleteCharactersInRange:NSMakeRange(receivedEvent.getCursorLocation, 1)];
                    [globalEvents push:receivedEvent];
                }
                else if (receivedEvent.getOperation == 0){ //insert
                    [receivedEvent setOrderID:orderID];
                    [_allText insertString:receivedEvent.getContent atIndex:receivedEvent.getCursorLocation];
                    [globalEvents push:receivedEvent];
                }
                
                
                
                else if (receivedEvent.getOperation == 2) { // Undo
                    NSMutableArray* tempStack = [[NSMutableArray alloc] init];
                    int moved = 0;
                    int countHere = [globalEvents count]-1;
                    OneEvent* temp = [globalEvents get:countHere];
                    while([temp getOrderID]!= [receivedEvent getOrderID]) {
                        if ([temp getHelpOrderID] != [receivedEvent getOrderID]) {
                            moved++;
                            [tempStack addObject:temp];
                        }
                        countHere--;
                        temp = [globalEvents get:countHere];
                    }
                    OneEvent* temp1;
                    int cursorInit = [temp getCursorLocation];
                       for(int x=moved-1;x>=0;x--) {
                               temp1 = [tempStack objectAtIndex:x];
                               if([temp1 getOperation] == 0 || ([temp1 getOperation]>=2 && [temp1 getHelpOperation] == 0)) {
                                   
                                   if([temp1 getCursorLocation] <= [temp getCursorLocation]) {
                                       NSLog(@"YES %d", [temp1 getCursorLocation]);
                                       NSLog(@"YES %d", [temp getCursorLocation]);

                                       NSLog(@"YES");
                                       [temp setCursorLocation:([temp getCursorLocation]+1)];
                                   }
                               }
                               else {
                                   if([temp1 getCursorLocation] < [temp getCursorLocation]) {
                                       NSLog(@"NO");
                                       [temp setCursorLocation:([temp getCursorLocation]-1)];
                                   }
                               }
                       }
                    [receivedEvent setHelpOrderID:[receivedEvent getOrderID]];
                    [receivedEvent setOrderID:orderID];
                    [receivedEvent setCursorLocation:[temp getCursorLocation]];
                    [receivedEvent setContent:[temp getContent]];
                    [temp setCursorLocation:cursorInit];

                if([temp getOperation] == 0 || ([temp getOperation]>=2 && [temp getHelpOperation] == 0)) { // delete
                    [receivedEvent setHelpOperation:1];
                    [_allText deleteCharactersInRange:NSMakeRange(receivedEvent.getCursorLocation, 1)];
                }
                else { //insert
                    [receivedEvent setHelpOperation:0];
                    [_allText insertString:receivedEvent.getContent atIndex:receivedEvent.getCursorLocation];

                }
                [globalEvents push:receivedEvent];
                }
                
                
                
                else if(receivedEvent.getOperation == 3) {
                    
                    NSMutableArray* tempStack = [[NSMutableArray alloc] init];
                    int moved = 0;
                    int countHere = [globalEvents count]-1;
                    OneEvent* temp = [globalEvents get:countHere];
                    while([temp getOrderID]!= [receivedEvent getOrderID]) {
                        if ([temp getHelpOrderID] != [receivedEvent getOrderID]) {
                            moved++;
                            [tempStack addObject:temp];
                        }
                        countHere--;
                        temp = [globalEvents get:countHere];
                    }
                    //[tempStack addObject:temp];
                    OneEvent* temp1;
                    int cursorInit = [temp getCursorLocation];
                    NSLog(@"cccccccccc%d", moved);
                    for(int x=moved-1;x>=0;x--) {
                        temp1 = [tempStack objectAtIndex:x];
                        if([temp1 getOperation] == 0 || ([temp1 getOperation]>=2 && [temp1 getHelpOperation] == 0)) {
                            NSLog(@"YES %d", [temp1 getCursorLocation]);
                            NSLog(@"YES %d", [temp getCursorLocation]);
                            
                            if([temp1 getCursorLocation] <= [temp getCursorLocation]) {
                                NSLog(@"YES");
                                [temp setCursorLocation:([temp getCursorLocation]+1)];
                            }
                        }
                        else {
                            if([temp1 getCursorLocation] < [temp getCursorLocation]) {
                                NSLog(@"NO");

                                [temp setCursorLocation:([temp getCursorLocation]-1)];
                            }
                        }
                    }
                    
                    [receivedEvent setHelpOrderID:[receivedEvent getOrderID]];
                    [receivedEvent setOrderID:orderID];
                    [receivedEvent setCursorLocation:[temp getCursorLocation]];
                    [receivedEvent setContent:[temp getContent]];
                    [temp setCursorLocation:cursorInit];

                    //if([temp getOperation] == 0 || ([temp getOperation]>=2 && [temp getHelpOperation] == 0)) { // insert
                        
                    if([temp getOperation] == 0){
                        NSLog(@"HERE DO THE REDO InSERT");
                        [receivedEvent setHelpOperation:0];
                        [_allText insertString:receivedEvent.getContent atIndex:receivedEvent.getCursorLocation];
                        
                    }
                    else if([temp getOperation] == 1){ //delete

                        [receivedEvent setHelpOperation:1];
                        [_allText deleteCharactersInRange:NSMakeRange(receivedEvent.getCursorLocation, 1)];

                    }
                    
                    [globalEvents push:receivedEvent];
                }
                
                
                
                
                
            
                
            }
        });
        
                
                
                
                /* unwind/wind solution
            if (index == NSNotFound) {
                NSLog(@"other's event");
                NSLog(@"%@", [receivedEvent getContent]);
                NSLog(@"%d", [receivedEvent getCursorLocation]);
NSLog(@"%d", [receivedEvent getOperation]);
                
                [self redoEventOp:receivedEvent];
                [globalEvents push:receivedEvent];
            }
            else {
                NSLog(@"my event");
                [localRegistrationID removeObjectAtIndex:index];
                OneEvent* temp = [globalEvents pop];
                BOOL currentOne = true;
                
                NSString* tempStr=@"";

                
                
                
                while([temp getRegistrationID] != submissionRegistrationID) {
                    NSLog(@"undo %@", temp.getContent);
                    NSLog(@"undo %d", temp.getCursorLocation);


                    currentOne = false;
                    [globalEvents unwindPush:temp];
                    [self undoEventOp:temp];
                    temp = [globalEvents pop];
        tempStr=[_InputBox text];
        NSLog(@"%@", tempStr);
    
                }
                if (currentOne) {
                }
                else {
                    NSLog(@"undo %@", temp.getContent);
                    NSLog(@"undo %d", temp.getCursorLocation);
                    [self undoEventOp:temp];
            tempStr=[_InputBox text];
            NSLog(@"%@", tempStr);
                    OneEvent* temp2;
                    while (![globalEvents unwindEmpty]) {
                        temp2 = [globalEvents unwindPop];
                        [self redoEventOp:temp2];
                        NSLog(@"redo %@", temp2.getContent);
                        NSLog(@"redo %d", temp2.getCursorLocation);


                        [globalEvents push:temp2];
                tempStr=[_InputBox text];
                NSLog(@"%@", tempStr);

                    }
                    [globalEvents push:temp];
                    [self redoEventOp:temp];
                    NSLog(@"redo %@", temp.getContent);
                    NSLog(@"redo %d", temp.getCursorLocation);
                    tempStr=[_InputBox text];
                    NSLog(@"%@", tempStr);

                    

                }
            }*/
                
                
            

    }
}

- (void) redoEventOp: (OneEvent*) event{
    if (![event getOperation]) { //insert redo
        //NSLog(@"!!!");
        [_InputBox setSelectedRange:NSMakeRange([event getCursorLocation], 0)];
        [_InputBox insertText:[event getContent]];
    }
    else { //delete redo
        //NSLog(@"???");
        [_InputBox setSelectedRange:NSMakeRange([event getCursorLocation]+1, 0)];
        [_InputBox deleteBackward];
    }
}

- (void) undoEventOp: (OneEvent*) event{
    if ([event getOperation]) { // delete 1 undo
        [_InputBox setSelectedRange:NSMakeRange([event getCursorLocation], 0)];
        [_InputBox insertText:[event getContent]];
    }
    else {
        [_InputBox setSelectedRange:NSMakeRange([event getCursorLocation]+1, 0)];
        [_InputBox deleteBackward];
    }
}

- (void) client:(CollabrifyClient *)client encounteredError:(CollabrifyError *)error
{
    if ([error isMemberOfClass:[CollabrifyUnrecoverableError class]]) {
        NSLog(@"The client cannot recover from this error");
        //update the interface to its default state
    }
switch ([error classType]) {
    case CollabrifyClassTypeAddEvent:
    {
        int32_t submissionRegistrationID;
        NSData *eventData;
        
        submissionRegistrationID = [[[error userInfo] valueForKey:CollabrifySubmissionRegistrationIDKey]intValue];
        eventData = [[error userInfo] valueForKey:CollabrifyDataKey];
        break;
    }
    default:
        break;
}


}




- (BOOL)textView:(IMLCTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    
    
    
    
    NSString* tempStr=@"";
    tempStr=[textView text];
    //NSLog(@"%@", tempStr);
    //NSLog(@"%d", range.location);
    //NSLog(@"%d", range.length);
    OneEvent* event;
    if (!range.length) {
        event = [[OneEvent alloc]initWithOperation:range.length CursorLocation:range.location Length:1 Content: text];
    }
    else {
        if ([tempStr length]!=0) {
            event = [[OneEvent alloc]initWithOperation:range.length CursorLocation:range.location Length:1 Content:[tempStr substringWithRange:NSMakeRange(range.location, 1)]];
        }
    }
    //NSLog(@"%@", event.getContent);
    //NSLog(@"%d", range.location);
    //NSLog(@"%d", [event getOperation]);
    NSData* dataSend = [BufferParsing sendEventFormatting:event];
    NSLog(@"???%@", [event getContent]);
    int32_t registrationID =[[self client] broadcast:dataSend eventType:nil];
    [event setRegistrationID:registrationID];
    
    
    
    Events* localEvents = [Events sharedEvents];
    [localEvents push:event];
    
    
    RedoStack* myRedoStack = [RedoStack sharedEvents];
    [myRedoStack clear];
    
    [unconfirmedEvents addObject:event];
    
    //AllEvents* globalEvents = [AllEvents sharedEvents];

    
    //[globalEvents push:event];
    
    
    [localRegistrationID addObject:[NSNumber numberWithInt:registrationID]];
    
    if (range.length <= 1)
    {
        return YES;
    }
    
    return NO;
}





@end
