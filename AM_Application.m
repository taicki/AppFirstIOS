//
//  AM_Application.m
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
