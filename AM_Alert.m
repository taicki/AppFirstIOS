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

#import "AM_Alert.h"

@implementation AM_Alert

- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return  nil;
        } else {
            [self setActive: [[jsonObject objectForKey:@"active"] boolValue]];
            [self setIn_incident:[[jsonObject objectForKey:@"in_incident"] boolValue]];
            [self setUid:[[jsonObject objectForKey:@"id"] intValue]];
            if ([jsonObject objectForKey:@"last_triggered"] != [NSNull null]) 
                [self setLast_triggered:[[jsonObject objectForKey:@"last_triggered"] longValue]];
            [self setName:[jsonObject objectForKey:@"name"]];
            [self setTrigger:[jsonObject objectForKey:@"trigger"]];
            [self setType:[jsonObject objectForKey:@"type"]];
            [self setTarget:[jsonObject objectForKey:@"target"]];
            [self setSubscribers:[jsonObject objectForKey:@"subscribers"]];
        }
    }
    
    return self;
}

- (bool) isActive {
    return active;
}

- (bool) isIn_incident {
    return in_incident;
}

- (int) uid {
    return uid;
}

- (long) last_triggered {
    return last_triggered;
}

- (NSString*) name {
    return  name;
}

- (NSString*) type {
    return  type;
}

- (NSString*) target {
    return target;
}

- (NSString*) trigger {
    return trigger;
}

- (NSArray*) subscribers {
    return  subscribers;
}

- (void) setActive:(_Bool)newActive {
    active = newActive;
}

- (void) setIn_incident:(_Bool)newIn_incident {
    in_incident = newIn_incident;
}

- (void) setUid:(int)newUid {
    uid = newUid;
}

- (void) setLast_triggered:(long)newLast_triggered {
    last_triggered = newLast_triggered;
}

- (void) setName:(NSString *)newName {
    [newName retain];
    [name release];
    name = newName;
}

- (void) setType:(NSString *)newType {
    [newType retain];
    [type release];
    type = newType;
}

- (void) setTarget:(NSString *)newTarget {
    [newTarget retain];
    [target release];
    target = newTarget;
}

- (void) setTrigger:(NSString *)newTrigger {
    [newTrigger retain];
    [trigger release];
    trigger = newTrigger;
}

- (void) setSubscribers:(NSArray *)newSubscribers {
    [newSubscribers retain];
    [subscribers release];
    subscribers = newSubscribers;
}

- (void) dealloc {
    [name release];
    [type release];
    [target release];
    [trigger release];
    [subscribers release];
    [super dealloc];
}

@end
