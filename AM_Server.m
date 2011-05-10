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
            [self setCapacity_mem:[[jsonObject objectForKey:@"capacity_mem"] longLongValue]];
            [self setHostname:[jsonObject objectForKey:@"hostname"]];
            [self setOS:[jsonObject objectForKey:@"os"]];
            [self setCapacity_disks: [jsonObject objectForKey:@"capacity_disks"]];
            
            NSArray* keyArray = [capacity_disks allKeys];
            for (int cnt = 0; cnt < [keyArray count]; cnt ++) {
                NSString* key = [keyArray objectAtIndex:cnt];
                int capacity = [[capacity_disks objectForKey:key] intValue];
                total_disk += capacity;
            }
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

- (long long) capacity_mem {
    return  capacity_mem;
}

- (long) capacity_cpu_freq {
    return capacity_cpu_freq;
}

- (long) created {
    return created;
}

- (long long) total_disk {
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

- (void) setTotal_Disk:(long long)newTotal_disk {
    total_disk = newTotal_disk;
}

- (void) setCapacity_mem:(long long)newCapacity_mem {
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
