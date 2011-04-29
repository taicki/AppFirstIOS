//
//  AM_Alert.h
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
