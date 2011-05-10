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

#import <Foundation/Foundation.h>
#import "AM_Server.h"

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
- (void) setProcess_num: (int) newProcess_num;
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
- (int) process_num;
- (int) page_faults;
- (NSDictionary*) disk;
- (NSDictionary*) cpu_cores;
- (NSDictionary*) disk_busy;
- (NSDictionary*) disk_percent_part;

- (void) generateResourceArray: (NSMutableArray*) newList server: (AM_Server*) server;

@end
