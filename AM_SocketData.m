/*
 * Copyright 2009-2011 AppFirst, Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AM_SocketData.h"


@implementation AM_SocketData
@synthesize status, processName, peerIp, peerPort, socketIp, socketPort, socketType, timeOpen, dataSent, dataReceived, threadId;

- (id) initWithJSONObject:(NSDictionary *)jsonData {
    self = [super init];
    
    if (self) {
        if (jsonData == nil) {
            [self release];
            return nil;
        } else {
            [self setStatus:[jsonData objectForKey:@"Status"]];
            [self setProcessName:[jsonData objectForKey:@"Process Name"]];
            [self setPeerIp:[jsonData objectForKey:@"Peer IP"]];
            [self setPeerPort:[jsonData objectForKey:@"Peer Port"]];
            [self setSocketIp:[jsonData objectForKey:@"Socket IP"]];
            [self setSocketPort:[jsonData objectForKey:@"Socket Port"]];
            [self setSocketType:[jsonData objectForKey:@"Type"]];
            [self setTimeOpen:[jsonData objectForKey:@"Time Open (sec)"]];
            [self setThreadId:[jsonData objectForKey:@"Thread Id"]];
            [self setDataReceived:[jsonData objectForKey:@"Data Received (bytes)"]];
            [self setDataSent:[jsonData objectForKey:@"Data Sent (bytes)"]];
        }
    }
    
    return  self;
}

- (NSString*) toString {
    return [NSString stringWithFormat:@"%@ %@:%@->%@:%@",socketType, 
            socketIp, socketPort, peerIp, peerPort];
}

- (NSString*) toDetailString {
    return [NSString stringWithFormat:@"%@;Thread id: %@; Status: %@; Sent: %@ bytes; Received: %@; Time open: %@ sec;", processName, threadId, status, dataSent, dataReceived, timeOpen];
}

- (void) dealloc {
    [status release];
    [processName release];
    [peerPort release];
    [peerIp release];
    [socketIp release];
    [socketPort release];
    [socketType release];
    [timeOpen release];
    [dataSent release];
    [dataReceived release];
    [threadId release];
    [super dealloc];
}

@end
