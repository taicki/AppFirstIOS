//
//  AM_AlertHistory.m
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
