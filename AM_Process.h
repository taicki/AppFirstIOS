//
//  AM_Process.h
//  AppFirst
//
//  Created by appfirst on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AM_Process : NSObject {
    NSString* args;
    NSString* name;
    int uid;
    int start;
    int end;
    int pid;
}

- (id) initWithJSONObject:(NSDictionary*) jsonObject;
- (void) setArgs: (NSString*) newArgs;
- (void) setUid:(int) newUid;
- (void) setName: (NSString*) newName;
- (void) setStart: (int) newStart;
- (void) setEnd: (int) newEnd;
- (void) setPid: (int) newPid;

- (NSString*) args;
- (NSString*) name;
- (int) uid;
- (int) start;
- (int) end;
- (int) pid;

@end
