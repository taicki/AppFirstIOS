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

#import "AM_ThreadData.h"
#import "AppHelper.h"

@implementation AM_ThreadData
@synthesize threadId, userTime, kernelTime, exitTime, stackSize, createTime;

- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return nil;
        } else {
            [self setThreadId:[jsonObject objectForKey:@"Thread ID"]];
            [self setUserTime:[jsonObject objectForKey:@"User Time (us)"]];
            [self setKernelTime:[jsonObject objectForKey:@"Kernel Time (us)"]];
            [self setExitTime:[jsonObject objectForKey:@"Exit Time"]];
            [self setStackSize:[jsonObject objectForKey:@"Stack Size (bytes)"]];
            [self setCreateTime:[jsonObject objectForKey:@"Create Time"]];
        
        }
    }
    
    return  self;
}

- (NSString*) toString {
    return [NSString stringWithFormat:@"Thead id: %@, created at %@", 
                threadId, createTime];
    
}

- (NSString*) toDetailString {
    return  [NSString stringWithFormat:@"User Time: %@ us, Kernel Time: %@ us, Stack size: %@ bytes, Exit time %@",userTime, kernelTime, stackSize, exitTime]; 
}


- (void)dealloc {
    [threadId release];
    [userTime release];
    [kernelTime release];
    [exitTime release];
    [stackSize release];
    [createTime release];
    [super dealloc];
}

@end
