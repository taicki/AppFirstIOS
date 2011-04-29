//
//  AM_SystemData.h
//  AppFirst
//
//  Created by appfirst on 4/21/11.
//  Copyright 2011 AppFirst. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AM_SystemData : NSObject {
    long time;
    double cpu;
    double memory;
    double disk_percent;
    int thread_num;
    int process_num;
    int page_faults;
    NSDictionary* disk; // disk usage
    NSDictionary* cpu_cores;
    NSDictionary* disk_busy;
    NSDictionary* disk_percent_part;
}

- (id) initWithJSONObject: (NSDictionary*) jsonObject;

- (void) setTime: (long) newTime;
- (void) setCpu: (double) newCpu;
- (void) setMemory: (double) newMemory;
- (void) setDisk_percent: (double) newDisk_percent;
- (void) setThread_num: (int) newThread_num;
- (void) setPage_faults: (int) newPage_faults;
- (void) setDisk: (NSDictionary*) newDisk;
- (void) setCpu_cores: (NSDictionary*) newCpu_cores;
- (void) setDisk_busy: (NSDictionary*) newDisk_busy;
- (void) setDisk_percent_part: (NSDictionary*) newDisk_percent_part;

- (long) time;
- (double) cpu;
- (double) memory;
- (double) disk_percent;
- (int) thread_num;
- (int) page_faults;
- (NSDictionary*) disk;
- (NSDictionary*) cpu_cores;
- (NSDictionary*) disk_busy;
- (NSDictionary*) disk_percent_part;

@end
