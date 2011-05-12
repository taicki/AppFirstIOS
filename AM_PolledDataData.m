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
#import "AM_PolledDataData.h"
#import "AM_ResourceCell.h"

@implementation AM_PolledDataData

- (id) initWithJSONObject:(NSDictionary *)jsonObject {
    self = [super init];
    
    if (self) {
        if (jsonObject == nil) {
            [self release];
            return nil;
        } else {
            [self setTime:[[jsonObject objectForKey:@"time"] intValue]];
            [self setValues:[jsonObject objectForKey:@"values"]];
            [self setStatus:[jsonObject objectForKey:@"status"]];
            [self setText:[jsonObject objectForKey:@"text"]];
        }
    }
    
    return self;
}

- (NSString*) status {
    return status;
}

- (NSString*) text {
    return text;
}

- (NSDictionary*) values {
    return values;
}

- (long) time {
    return time;
}

- (void) setTime:(long)newTime {
    time = newTime;
}

- (void) setValues:(NSDictionary *)newValues{
    [newValues retain];
    [values release];
    values = newValues;
}

- (void) setText:(NSString *)newText {
    [newText retain];
    [text release];
    text = newText;
}

- (void) setStatus:(NSString *)newStatus {
    [newStatus retain];
    [status release];
    status = newStatus;
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

- (void) generateResourceArray: (NSMutableArray*) newList {
    NSArray* keys = [values allKeys];
    
    for (id key in keys) {
        NSNumber* value = [[[values objectForKey:key] objectAtIndex:1] objectForKey:@"val"];
        [self generateResourceCell: key 
                              type: @"double" 
                             value: 0 
                            detail: [NSString stringWithFormat:@"%@", value] 
                            option:AF_NormalCell 
                           newList: newList];
    }
}

- (void) dealloc {
    [status release];
    [text release];
    [values release];
    [super dealloc];
}

@end
