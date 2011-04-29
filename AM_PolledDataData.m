//
//  AM_PolledDataData.m
//  AppFirst
//
//  Created by appfirst on 4/21/11.
//  Copyright 2011 AppFirst. All rights reserved.
//

#import "AM_PolledDataData.h"


@implementation AM_PolledDataData

- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return nil;
        } else {
            [self setTime:[[jsonObject objectForKey:@"time"] intValue]];
            [self setValues:[jsonObject objectForKey:@"values"]];
            [self setStatus:[jsonObject objectForKey:@"status"]];
            [self setText:[jsonObject objectForKey:@"text"]];
        }
    }
    
    return self;
}

- (NSString*) status {
    return status;
}

- (NSString*) text {
    return text;
}

- (NSDictionary*) values {
    return values;
}

- (long) time {
    return time;
}

- (void) setTime:(long)newTime {
    time = newTime;
}

- (void) setValues:(NSDictionary *)newValues{
    [newValues retain];
    [values release];
    values = newValues;
}

- (void) setText:(NSString *)newText {
    [newText retain];
    [text release];
    text = newText;
}

- (void) setStatus:(NSString *)newStatus {
    [newStatus retain];
    [status release];
    status = newStatus;
}

- (void) dealloc {
    [status release];
    [text release];
    [values release];
    [super dealloc];
}

@end
