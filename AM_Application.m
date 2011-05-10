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

#import "AM_Application.h"


@implementation AM_Application


- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return  nil;
        } else {
            [self setName:[jsonObject objectForKey:@"name"]];
            [self setUid:[[jsonObject objectForKey:@"id"] intValue]];
            [self setCreated:[[jsonObject objectForKey:@"created"] longValue]];
        }
    }
    
    return self;
}

- (void) setUid:(int)newUid {
    uid = newUid;
}

- (void) setName:(NSString *)newName {
    [newName retain];
    [name release];
    name = newName;
}

- (void) setCreated:(long)newCreated {
    created = newCreated;
}

- (int) uid {
    return uid;
}

- (NSString*) name {
    return name;
}

- (long) created {
    return created;
}

- (void)dealloc {
    [name release];
    [super dealloc];
}

@end
