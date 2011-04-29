//
//  AM_Process.m
//  AppFirst
//  Author: bin@appfirst.com
//  Created by appfirst on 4/19/11.
//  Copyright 2011 AppFirst. All rights reserved.
//

#import "AM_Process.h"


@implementation AM_Process

- (id) initWithJSONObject:(NSMutableDictionary *)jsonObject {
    self = [super init];
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return nil;
        } else {
            [self setName: [[jsonObject objectForKey:@"name"] stringValue]];
            [self setArgs: [[jsonObject objectForKey:@"args"] stringValue]];
            [self setStart: [[jsonObject objectForKey:@"start"] intValue]];
            [self setEnd: [[jsonObject objectForKey:@"id"] intValue]];
            if ([jsonObject objectForKey:@"end"] != nil) {
                [self setPid: [[jsonObject objectForKey:@"end"] intValue]];
                
            }
            [self setUid: [[jsonObject objectForKey:@"pid"] intValue]];
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

- (void) dealloc {
    [name release];
    [args release];
    [super dealloc];
}



@end
