//
//  AM_PolledData.m
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
            [self setAlert_uid:[[jsonObject objectForKey:@"alert_id"] intValue]];
            [self setServer_uid:[[jsonObject objectForKey:@"server_id"]intValue]];
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
