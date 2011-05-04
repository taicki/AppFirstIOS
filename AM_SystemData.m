//
//  AM_SystemData.m
//  Bin Liu
//
//  Created by appfirst on 4/21/11.
//  Copyright 2011 AppFirst. All rights reserved.
//

#import "AM_SystemData.h"
#import "AM_ResourceCell.h"
#import "config.h"

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
            [self setProcess_num:[[jsonObject objectForKey:@"process_num"] intValue]];
            
             
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

- (void) setProcess_num:(int)newProcess_num {
    process_num = newProcess_num;
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

- (int) process_num {
    return  process_num;
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
}



- (void) generateResourceArray: (NSMutableArray*) newList server: (AM_Server*) server {    
    NSString* cpuDetail = [NSString stringWithFormat:@"%d cores at %d MHZ", [server capacity_cpu_num], [server capacity_cpu_freq]];
    NSLog(@"%lld", [server capacity_mem]);
    NSString* memoryDetail = [NSString stringWithFormat:@"Total: %lld MB", [server capacity_mem] / 1024 / 1024  ];
    NSString* pageFaultDetail = [NSString stringWithFormat:@"%d", page_faults];
    NSString* threadDetail = [NSString stringWithFormat:@"%d", thread_num];
    NSString* processDetail = [NSString stringWithFormat:@"%d", process_num];
    NSString* diskDetail = [NSString stringWithFormat:@"Total: %lld MB", [server total_disk]];
    
    NSDictionary* diskExtra = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray* diskKeys = [disk_percent_part allKeys];
    for (int cnt = 0; cnt < [diskKeys count]; cnt ++) {
        NSString* diskName = [diskKeys objectAtIndex:cnt];
        int capacity = 0;
        if ([[server capacity_disks] objectForKey:diskName] != [NSNull null]) {
            capacity = [[[server capacity_disks] objectForKey:diskName] intValue];
        }
        NSString* newDiskName = [NSString stringWithFormat:@"%@ (%d MB)", diskName, capacity];
        [diskExtra setValue:[disk_percent_part objectForKey:diskName] forKey:newDiskName];
        
    }

    [self generateResourceCell: CPU_DISPLAY_TEXT type: @"double" value: [NSNumber numberWithDouble:cpu] detail:cpuDetail option: AF_ExtendedGraphCell extra: cpu_cores 
                   graphOption: AF_Bar
                       newList: newList];
    [self generateResourceCell: MEMORY_DISPLAY_TEXT type: @"double" value: [NSNumber numberWithDouble:memory/[server capacity_mem]*100] detail:memoryDetail option: AF_GraphCell newList: newList];
    [self generateResourceCell: DISK_PERCENT_DISPLAY_TEXT type: @"double" value: [NSNumber numberWithDouble:disk_percent] detail:diskDetail option:AF_ExtendedGraphCell extra:diskExtra graphOption: AF_Pie 
                       newList: newList];
    [self generateResourceCell: DISK_BUSY_DISPLAY_TEXT type: @"double" value: [NSNumber numberWithDouble:-1] detail:@"" option:AF_ExtendedGraphCell extra:disk_busy graphOption: AF_Bar 
                       newList: newList];
    [self generateResourceCell: PAGE_FAULT_DISPLAY_TEXT type: @"int" value: 0 detail: pageFaultDetail option:AF_NormalCell newList: newList];
    [self generateResourceCell: THREAD_NUM_DISPLAY_TEXT type: @"int" value: 0 detail:threadDetail option:AF_NormalCell newList: newList];
    [self generateResourceCell: PROCESS_NUM_DISPLAY_TEXT type: @"int" value: 0 detail: processDetail option:AF_NormalCell newList: newList];
}

- (void) dealloc {
    [disk_busy release];
    [disk_percent_part release];
    [disk release];
    [cpu_cores release];
    [super dealloc];
}




@end
