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

#import <Foundation/Foundation.h>


@interface AM_SocketData : NSObject {
    NSString* status;
    NSString* processName;
    NSString* peerIp;
    NSString* socketIp;
    NSString* socketType;
    
    NSNumber* threadId;
    NSNumber* timeOpen;
    NSNumber* peerPort;
    NSNumber* dataReceived;
    NSNumber* dataSent;
    NSNumber* socketPort;
    
}

@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) NSString* processName;
@property (nonatomic, retain) NSString* peerIp;
@property (nonatomic, retain) NSString* socketIp;
@property (nonatomic, retain) NSString* socketType;

@property (nonatomic, retain) NSNumber* threadId;
@property (nonatomic, retain) NSNumber* timeOpen;
@property (nonatomic, retain) NSNumber* peerPort;
@property (nonatomic, retain) NSNumber* dataReceived;
@property (nonatomic, retain) NSNumber* dataSent;
@property (nonatomic, retain) NSNumber* socketPort;

- (id) initWithJSONObject: (NSDictionary*) jsonData;
- (NSString*) toString;
- (NSString*) toDetailString;

@end
