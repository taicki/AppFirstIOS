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

#import "AM_Process.h"


@implementation AM_Process

- (id) initWithJSONObject:(NSMutableDictionary *)jsonObject {
    self = [super init];
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return nil;
        } else {
            [self setName: [jsonObject objectForKey:@"name"]];
            [self setArgs: [jsonObject objectForKey:@"args"]];
            [self setStart: [[jsonObject objectForKey:@"start"] intValue]];
            [self setUid: [[jsonObject objectForKey:@"id"] intValue]];
            [self setPid:[[jsonObject objectForKey:@"pid"] intValue]];
            [self setServer_id:[[jsonObject objectForKey:@"server"] intValue]];
            if ([jsonObject objectForKey:@"end"] != [NSNull null]) {
                [self setPid: [[jsonObject objectForKey:@"end"] intValue]];
                
            }
        }
    }
    
    return self;
}

- (NSString*) name {
    return name;
}

- (NSString*) args {
    return  args;
}

- (int) start {
    return start;
}

- (int) end {
    return end;
}

- (int) pid {
    return pid;
}

- (int) uid {
    return uid;
}

- (int) server_id {
    return server_id;
}



- (void) setArgs: (NSString*)  newArgs {
    [newArgs retain];
    if (args != nil) {
        [args release];
    }
    args = newArgs;
}

- (void) setName:(NSString *)newName {
    [newName retain];
    if (name != nil) {
        [name release];
    }
    name = newName;
}

- (void) setStart:(int)newStart {
    start = newStart;
}

- (void) setEnd:(int)newEnd {
    end = newEnd;
}

- (void) setUid:(int) newUid {
    uid = newUid;
}

- (void) setPid:(int)newPid {
    pid = newPid;
}

- (void) setServer_id:(int)newServer_id {
    server_id = newServer_id;
}

- (void) dealloc {
    [name release];
    [args release];
    [super dealloc];
}



@end
