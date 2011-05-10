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

// mapping of AppFirst Server object
@interface AM_Server : NSObject {    
    NSString* os;
    NSString* hostname;
    NSMutableDictionary* capacity_disks;
    long long capacity_mem; 
    long capacity_cpu_freq;
    long created;
    long long total_disk;
    int capacity_cpu_num;
    int uid;
    bool running;
}

- (id) initWithJSONObject:(NSDictionary*) jsonObject;

- (void) setOS: (NSString* ) newOS;
- (void) setUid: (int) newUid;
- (void) setCapacity_cpu_num: (int) newCapacity_cpu_num;
- (void) setHostname: (NSString*) newHostname;
- (void) setCapacity_disks: (NSMutableDictionary*) newCapacity_disk;
- (void) setTotal_Disk: (long long) newTotal_disk;
- (void) setCreated: (long) newCreated;
- (void) setCapacity_mem: (long long) newCapacity_mem;
- (void) setCapacity_cpu_freq: (long) newCapacity_cpu_freq;
- (void) setRunning: (bool) newRunning;

- (NSString*) os;
- (NSString*) hostname;
- (NSMutableDictionary*) capacity_disks;
- (int) uid;
- (int) capacity_cpu_num;
- (bool) isRunning;
- (long long) capacity_mem;
- (long) capacity_cpu_freq;
- (long) created;
- (long long) total_disk;

@end
