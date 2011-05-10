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


@interface AM_Alert : NSObject {
    bool active;
    bool in_incident;
    int uid;
    long last_triggered;
    NSString* name;
    NSString* type;
    NSString* target;
    NSString* trigger;
    NSArray* subscribers;
    
}

- (id) initWithJSONObject: (NSDictionary*) jsonObject;

- (bool) isActive;
- (bool) isIn_incident;
- (int) uid;
- (long) last_triggered;
- (NSString*) name;
- (NSString*) type;
- (NSString*) target;
- (NSString*) trigger;
- (NSArray*) subscribers;

- (void) setActive: (bool) newActive;
- (void) setIn_incident: (bool) newIn_incident;
- (void) setUid: (int) newUid;
- (void) setLast_triggered: (long) newLast_triggered;
- (void) setName: (NSString*) newName;
- (void) setType: (NSString*) newType;
- (void) setTarget: (NSString*) newTarget;
- (void) setTrigger: (NSString*) newTrigger;
- (void) setSubscribers: (NSArray*) newSubscribers;

@end
