//
//  AM_ProcessData.h
//  AppFirst
//
//  Created by appfirst on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AM_ProcessData : NSObject {
    long time;
    double cpu;
    double memory;
    double avg_response_time;
    long thread_num;
    long page_faults;
    long socket_write;
    long socket_read;
    long response_num;
    long total_log;
    long registry_num;
    long socket_num;
    long critical_log;
    long file_read;
    long file_write;
    long file_num;
}

- (id) initWithJSONObject: (NSDictionary*) jsonObject;

- (long) time;
- (double) cpu;
- (double) memory;
- (double) avg_response_time;
- (long) thread_num;
- (long) page_faults;
- (long) socket_write;
- (long) socket_read;
- (long) response_num;
- (long) total_log;
- (long) registry_num;
- (long) socket_num;
- (long) critical_log;
- (long) file_read;
- (long) file_write;
- (long) file_num;

- (void) setTime : (long) newTime;
- (void) setCpu: (double) newCpu;
- (void) setMemory: (double) newMemory;
- (void) setAvg_response_time: (double) newAvg_response_time;
- (void) setThread_num: (long) newThread_num;
- (void) setPage_faults: (long) newPage_faults;
- (void) setSocket_write: (long) newSocket_write;
- (void) setSocket_read: (long) newSocket_read;
- (void) setResponse_num: (long) newResponse_num;
- (void) setTotal_log: (long) newTotal_log;
- (void) setRegistry_num: (long) newRegistry_num;
- (void) setSocket_num: (long) newSocket_num;
- (void) setCritical_log: (long) newCritical_log;
- (void) setFile_read: (long) newFile_read;
- (void) setFile_write: (long) newFile_write;
- (void) setFile_num: (long) newFile_num;


- (void) generateResourceArray: (NSMutableArray*) newList;
@end
