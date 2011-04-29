//
//  AM_Server.m
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 AppFirst. All rights reserved.
//

#import "AM_Server.h"


@implementation AM_Server

- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return  nil;
        } else {
            [self setCapacity_cpu_num:[[jsonObject objectForKey:@"capacity_cpu_num"] intValue]];
            [self setUid:[[jsonObject objectForKey:@"id"] intValue]];
            [self setCreated:[[jsonObject objectForKey:@"created"] longValue]];
            [self setRunning:[[jsonObject objectForKey:@"running"] boolValue]];
            [self setCapacity_cpu_freq:[[jsonObject objectForKey:@"capacity_cpu_freq"] longValue]];
            [self setCapacity_mem:[[jsonObject objectForKey:@"capacity_mem"] longValue]];
            [self setHostname:[jsonObject objectForKey:@"hostname"]];
            [self setOS:[jsonObject objectForKey:@"os"]];
            [self setCapacity_disks: [jsonObject objectForKey:@"capacity_disks"]];
            
        }
        
    }
    
    return self;
}

- (NSString*) hostname{
    return hostname;
}

- (NSString*) os {
    return os;
}

- (int) uid {
    return uid;
}

- (int) capacity_cpu_num {
    return capacity_cpu_num;
}

- (long) capacity_mem {
    return  capacity_mem;
}

- (long) capacity_cpu_freq {
    return capacity_cpu_freq;
}

- (long) created {
    return created;
}

- (long) total_disk {
    return total_disk;
}

- (bool) isRunning {
    return running;
}

- (NSDictionary*) capacity_disks {
    return capacity_disks;
}

- (void) setOS:(NSString *)newOS {
    [newOS retain];
    [os release];
    os = newOS;
}

- (void) setHostname:(NSString *)newHostname {
    [newHostname retain];
    [hostname release];
    hostname = newHostname;
}

- (void) setCapacity_disks:(NSMutableDictionary *)newCapacity_disk {
    [newCapacity_disk retain];
    [capacity_disks release];
    capacity_disks = newCapacity_disk;
}

- (void) setUid:(int)newUid {
    uid = newUid;
}

- (void) setCreated:(long)newCreated {
    created = newCreated;
}

- (void) setRunning:(_Bool)newRunning {
    running = newRunning;
}

- (void) setTotal_Disk:(long)newTotal_disk {
    total_disk = newTotal_disk;
}

- (void) setCapacity_mem:(long)newCapacity_mem {
    capacity_mem = newCapacity_mem;
}

- (void) setCapacity_cpu_freq:(long)newCapacity_cpu_freq {
    capacity_cpu_freq = newCapacity_cpu_freq;
}

- (void) setCapacity_cpu_num:(int)newCapacity_cpu_num {
    capacity_cpu_num = newCapacity_cpu_num;
}

- (void) dealloc {
    [os release];
    [hostname release];
    [capacity_disks release];
    [super dealloc];
}


@end
