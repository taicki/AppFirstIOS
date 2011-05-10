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

#import "AM_PolledData.h"


@implementation AM_PolledData

- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return  nil;
        } else {
            [self setUid:[[jsonObject objectForKey:@"id"] intValue]];
            [self setAlert_uid:[[jsonObject objectForKey:@"alert"] intValue]];
            [self setServer_uid:[[jsonObject objectForKey:@"server"]intValue]];
            [self setName:[jsonObject objectForKey:@"name"]];
        }
    }
    
    return self;
}

- (int) uid {
    return uid;
}

- (int) server_uid {
    return server_uid;
}

- (int) alert_uid {
    return alert_uid;
}

- (NSString*) name {
    return name;
}

- (void) setUid:(int)newUid {
    uid = newUid;
}

- (void) setAlert_uid:(int)newAlert_uid {
    alert_uid = newAlert_uid;
}

- (void) setServer_uid:(int)newServer_uid {
    server_uid = newServer_uid;
}

- (void) setName:(NSString *)newName {
    [newName retain];
    [name release];
    name = newName;
}

- (void)dealloc {
    [name release];
    [super dealloc];
}


@end
