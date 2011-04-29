//
//  AM_SystemData.m
//  Bin Liu
//
//  Created by appfirst on 4/21/11.
//  Copyright 2011 AppFirst. All rights reserved.
//

#import "AM_SystemData.h"


@implementation AM_SystemData

- (id) initWithJSONObject: (NSDictionary*) jsonObject {
    self = [super init];
    
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return nil;
        } else {
            [self setTime:[[jsonObject objectForKey:@"time"] longValue]];
            [self setCpu:[[jsonObject objectForKey:@"cpu"] doubleValue]];
            [self setMemory:[[jsonObject objectForKey:@"memory"] doubleValue]];
            [self setDisk_percent:[[jsonObject objectForKey:@"disk_percent"] doubleValue]];
            [self setThread_num:[[jsonObject objectForKey:@"thread_num"] intValue]];
             [self setPage_faults:[[jsonObject objectForKey:@"page_faults"] intValue]];
             
            [self setDisk:[jsonObject objectForKey:@"disk"]];
            [self setCpu_cores:[jsonObject objectForKey:@"cpu_cores"]];
            [self setDisk_busy:[jsonObject objectForKey:@"disk_busy"]];
            [self setDisk_percent_part:[jsonObject objectForKey:@"disk_percent_part"]];
            
        }
    }
    
    return  self;
}

- (void) setTime:(long)newTime {
    time = newTime;
}

- (void) setCpu:(double)newCpu {
    cpu = newCpu;
}

- (void) setMemory:(double)newMemory {
    memory = newMemory;
}

- (void) setDisk_percent:(double)newDisk_percent {
    disk_percent = newDisk_percent;
}

- (void) setThread_num:(int)newThread_num {
    thread_num = newThread_num;
}

- (void) setPage_faults:(int)newPage_faults {
    page_faults = newPage_faults;
}

- (void) setDisk:(NSDictionary *)newDisk {
    [newDisk retain];
    [disk release];
    disk = newDisk;
}

- (void) setCpu_cores:(NSDictionary *)newCpu_cores {
    [newCpu_cores retain];
    [cpu_cores release];
    cpu_cores = newCpu_cores;
}

- (void) setDisk_busy:(NSDictionary *)newDisk_busy {
    [newDisk_busy retain];
    [disk_busy release];
    disk_busy = newDisk_busy;
}

- (void) setDisk_percent_part:(NSDictionary *)newDisk_percent_part {
    [newDisk_percent_part retain];
    [disk_percent_part release];
    disk_percent_part = newDisk_percent_part;
}

- (long) time {
    return time;
}

- (double) cpu {
    return  cpu;
}

- (double) memory {
    return memory;
}

- (double) disk_percent {
    return  disk_percent;
}

- (int) page_faults {
    return page_faults;
}

- (int) thread_num {
    return thread_num;
}

- (NSDictionary*) disk {
    return  disk;
}

- (NSDictionary*) disk_busy {
    return  disk_busy;
}

- (NSDictionary*) cpu_cores {
    return  cpu_cores;
}

- (NSDictionary*) disk_percent_part {
    return  disk_percent_part;
}

- (void) dealloc {
    [disk_busy release];
    [disk_percent_part release];
    [disk release];
    [cpu_cores release];
    [super dealloc];
}




@end