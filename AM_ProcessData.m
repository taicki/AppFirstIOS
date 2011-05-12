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

#import "AM_ProcessData.h"
#import "AM_ResourceCell.h"
#import "config.h"
#import "AppHelper.h"


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



- (void) generateResourceCell: (NSString *) name 
                         type: (NSString *) type 
                        value: (NSNumber *) value 
                       detail: (NSString *) detail
                       option: (AM_ResourceCellOption) option 
                      newList: (NSMutableArray *) newList   {
    AM_ResourceCell* cell = [[AM_ResourceCell alloc] init];
    [cell setResourceName:name];
    [cell setResourceType:type];
    [cell setResourceDetail:detail];
    [cell setResourceValue:value];
    [cell setRenderOption:option];
    [newList addObject:cell];
    [cell release];
}

- (void) generateResourceCell: (NSString *) name 
                         type: (NSString *) type 
                        value: (NSNumber *) value 
                       detail: (NSString *) detail
                       option: (AM_ResourceCellOption) option
                        extra: (NSDictionary*) extra
                  graphOption: (AM_ResourceGraphOption) graphOption
                      newList: (NSMutableArray *) newList
{
    AM_ResourceCell* cell = [[AM_ResourceCell alloc] init];
    [cell setResourceName:name];
    [cell setResourceType:type];
    [cell setResourceDetail:detail];
    [cell setResourceValue:value];
    [cell setRenderOption:option];
    [cell setGraphOption:graphOption];
    [cell setExtra:extra];
    [newList addObject:cell];
    [cell release];
}



- (void) generateResourceArray: (NSMutableArray*) newList {
    [self generateResourceCell: CPU_DISPLAY_TEXT 
                          type: @"double" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:CPU_DISPLAY_TEXT value:cpu] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: MEMORY_DISPLAY_TEXT 
                          type: @"double" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:MEMORY_DISPLAY_TEXT value:memory] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell:  PAGE_FAULT_DISPLAY_TEXT
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:PAGE_FAULT_DISPLAY_TEXT value:page_faults] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: THREAD_NUM_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:THREAD_NUM_DISPLAY_TEXT value:thread_num] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: SOCKET_NUM_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:SOCKET_NUM_DISPLAY_TEXT value:socket_num] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: SOCKET_READ_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:SOCKET_READ_DISPLAY_TEXT value:socket_read] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: SOCKET_WRITE_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:SOCKET_WRITE_DISPLAY_TEXT value:socket_write] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: FILE_NUM_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:FILE_NUM_DISPLAY_TEXT value:file_num] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: FILE_READ_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:FILE_READ_DISPLAY_TEXT value:file_read] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: FILE_WRITE_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:FILE_WRITE_DISPLAY_TEXT value:file_write] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: RESPONSE_NUM_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:RESPONSE_NUM_DISPLAY_TEXT value:response_num] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: AVG_RESPONSE_TIME_DISPLAY_TEXT 
                          type: @"double" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:AVG_RESPONSE_TIME_DISPLAY_TEXT value:avg_response_time] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: INCIDENT_REPORT_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:INCIDENT_REPORT_DISPLAY_TEXT value:total_log] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: CRITICAL_INCIDENT_REPORT_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:CRITICAL_INCIDENT_REPORT_DISPLAY_TEXT value:critical_log] 
                        option:AF_NormalCell 
                       newList: newList];
    [self generateResourceCell: REGISTRY_NUM_DISPLAY_TEXT 
                          type: @"long" 
                         value: 0 
                        detail: [AppHelper formatResourceValue:REGISTRY_NUM_DISPLAY_TEXT value:registry_num] 
                        option:AF_NormalCell 
                       newList: newList];
    
}


@end
