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
#import "AM_AlertHistory.h"


@implementation AM_AlertHistory

- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return  nil;
        } else {
            [self setUid: [[jsonObject objectForKey:@"id"] intValue]];
            [self setStart:[[jsonObject objectForKey:@"start"] longValue]];
            if ([jsonObject objectForKey:@"end"] != [NSNull null]) {
                [self setEnd: [[jsonObject objectForKey:@"end"] longValue]];
            }
            [self setAlert_id:[[jsonObject objectForKey:@"alert_id"] intValue]];
            [self setSubject:[jsonObject objectForKey:@"subject"]];
        }        
    }
    
    return self;
}

- (int) uid {
    return  uid;
}

- (int) alert_id {
    return  alert_id;
}

- (NSString*) subject {
    return subject;
}

- (long) start {
    return  start;
}

- (long) end {
    return  end;
}

- (void) setAlert_id:(int)newAlert_id {
    alert_id = newAlert_id;
}

- (void) setUid:(int)newUid {
    uid = newUid;
}

- (void) setStart:(long)newStart {
    start = newStart;
}

- (void) setEnd:(long)newEnd {
    end = newEnd;
}

- (void) setSubject:(NSString *)newSubject {
    [newSubject retain];
    [subject release];
    subject = newSubject;
}

- (void) dealloc {
    [subject release];
    [super dealloc];
}

@end
