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

#import "AM_LogData.h"


@implementation AM_LogData
@synthesize message, severity;

- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return nil;
        } else {
            [self setMessage:[jsonObject objectForKey:@"Message"]];
            [self setSeverity:[jsonObject objectForKey:@"Severity"]];
        }
    }
    
    return  self;
}

- (NSString*) toString {
    return [NSString stringWithFormat:@"%@", [self message]];
}

- (NSString*) toDetailString {
    return [NSString stringWithFormat:@"%@", severity];
}

- (void) dealloc {
    [message release];
    [severity release];
    [super dealloc];
}

@end
