//
//  AM_Server.h
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// mapping of AppFirst Server object
@interface AM_Server : NSObject {    
    NSString* os;
    NSString* hostname;
    NSMutableDictionary* capacity_disks;
    long capacity_mem; 
    long capacity_cpu_freq;
    long created;
    long total_disk;
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
- (void) setTotal_Disk: (long) newTotal_disk;
- (void) setCreated: (long) newCreated;
- (void) setCapacity_mem: (long) newCapacity_mem;
- (void) setCapacity_cpu_freq: (long) newCapacity_cpu_freq;
- (void) setRunning: (bool) newRunning;

- (NSString*) os;
- (NSString*) hostname;
- (NSMutableDictionary*) capacity_disks;
- (int) uid;
- (int) capacity_cpu_num;
- (bool) isRunning;
- (long) capacity_mem;
- (long) capacity_cpu_freq;
- (long) created;
- (long) total_disk;

@end
