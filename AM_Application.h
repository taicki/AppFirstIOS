//
//  AM_Application.h
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AM_Application : NSObject {
    int uid;
    NSString* name;
    long created;
}

- (id) initWithJSONObject : (NSDictionary*) jsonObject;

- (int) uid;
- (NSString*) name;
- (long) created;

- (void) setUid: (int) newUid;
- (void) setName: (NSString*) newName;
- (void) setCreated: (long) newCreated;

@end
