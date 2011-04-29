//
//  AM_ProcessData.m
//  AppFirst
//
//  Created by appfirst on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AM_ProcessData.h"


@implementation AM_ProcessData

-(id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    if (self) {
        if (jsonObject != nil) {
            [self setTime:[[jsonObject objectForKey:@"time"] longValue]];
            [self setCpu:[[jsonObject objectForKey:@"cpu"] doubleValue]];
            [self setMemory:[[jsonObject objectForKey:@"memory"]doubleValue]];
            [self setAvg_response_time:[[jsonObject objectForKey:@"avg_response_time"] doubleValue]];
            [self setThread_num:[[jsonObject objectForKey:@"thread_num"] longValue]];
            [self setPage_faults:[[jsonObject objectForKey:@"page_faults"] longValue]];
            [self setSocket_read:[[jsonObject objectForKey:@"socket_read"] longValue]];
            [self setSocket_write:[[jsonObject objectForKey:@"socket_write"] longValue]];
            [self setSocket_num:[[jsonObject objectForKey:@"socket_num"] longValue]];
            [self setRegistry_num:[[jsonObject objectForKey:@"registry_num"] longValue]];
            [self setResponse_num:[[jsonObject objectForKey:@"response_num"]longValue]];
            [self setTotal_log:[[jsonObject objectForKey:@"total_log"] longValue]];
            [self setCritical_log:[[jsonObject objectForKey:@"critical_log"]longValue]];
            [self setFile_num:[[jsonObject objectForKey:@"file_num"] longValue]];
            [self setFile_read:[[jsonObject objectForKey:@"file_read"] longValue]];
            [self setFile_write:[[jsonObject objectForKey:@"file_write"] longValue]];
             
        } else {
            [self release];
            return nil;
        }
    }
    return self;
}

- (long) time{
    return  time;
}

- (double) cpu {
    return cpu;
}

- (double) memory {
    return  memory;
}

- (double) avg_response_time {
    return avg_response_time;
}

- (long) thread_num {
    return thread_num;    
}

- (long) page_faults {
    return  page_faults;
}

- (long) socket_write {
    return  socket_write;
}

- (long) socket_read {
    return socket_read;
}

- (long) response_num {
    return response_num;
}

- (long) total_log {
    return  total_log;
}

- (long) registry_num {
    return registry_num;
}

- (long) socket_num {
    return socket_num;
}

- (long) critical_log {
    return critical_log;
}

- (long) file_read {
    return  file_read;
}

- (long) file_write {
    return file_write;
}

- (long) file_num {
    return  file_num;
}

- (void) setTime:(long)newTime {
    time = newTime;
}

- (void) setMemory:(double)newMemory {
    memory = newMemory;
}

- (void) setCpu:(double)newCpu {
    cpu = newCpu;
}

- (void) setAvg_response_time:(double)newAvg_response_time {
    avg_response_time = newAvg_response_time;
}

- (void) setThread_num:(long)newThread_num {
    thread_num = newThread_num;
}

- (void) setPage_faults:(long)newPage_faults {
    page_faults = newPage_faults;
}

- (void) setSocket_num:(long)newSocket_num {
    socket_num = newSocket_num;
}

- (void) setSocket_read:(long)newSocket_read {
    socket_read = newSocket_read;
}

- (void) setSocket_write:(long)newSocket_write {
    socket_write = newSocket_write;
}

- (void) setRegistry_num:(long)newRegistry_num {
    response_num = newRegistry_num;
}

- (void) setTotal_log:(long)newTotal_log {
    total_log = newTotal_log;
}

- (void) setResponse_num:(long)newResponse_num {
    response_num = newResponse_num;
}

- (void) setCritical_log:(long)newCritical_log {
    critical_log = newCritical_log;
}

- (void) setFile_read:(long)newFile_read {
    file_read = newFile_read;
}

- (void) setFile_write:(long)newFile_write {
    file_write = newFile_write;
}


- (void) setFile_num:(long)newFile_num {
    file_num = newFile_num;
}


@end
