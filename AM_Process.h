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


@interface AM_Process : NSObject {
    NSString* args;
    NSString* name;
    int server_id;
    int uid;
    int start;
    int end;
    int pid;
}

- (id) initWithJSONObject:(NSDictionary*) jsonObject;
- (void) setArgs: (NSString*) newArgs;
- (void) setUid:(int) newUid;
- (void) setName: (NSString*) newName;
- (void) setStart: (int) newStart;
- (void) setEnd: (int) newEnd;
- (void) setPid: (int) newPid;
- (void) setServer_id: (int) newServer_id;

- (NSString*) args;
- (NSString*) name;
- (int) uid;
- (int) start;
- (int) end;
- (int) pid;
- (int) server_id;

@end
