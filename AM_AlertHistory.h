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


@interface AM_AlertHistory : NSObject {
    int uid;
    long start;
    long end;
    int alert_id;
    NSString* subject;
}

- (id) initWithJSONObject: (NSDictionary*) jsonObject;
- (int) uid;
- (long) start;
- (long) end;
- (int) alert_id;
- (NSString*) subject;

- (void) setUid: (int) newUid;
- (void) setStart: (long) newStart;
- (void) setEnd: (long) newEnd;
- (void) setAlert_id: (int) newAlert_id;
- (void) setSubject: (NSString*) newSubject;

@end
