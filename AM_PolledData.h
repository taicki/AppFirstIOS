//
//  AM_PolledData.h
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AM_PolledData : NSObject {
    int server_uid;
    int alert_uid;
    int uid;
    NSString* name;
}

- (id) initWithJSONObject: (NSDictionary*) jsonObject;
- (int) server_uid;
- (int) alert_uid;
- (int) uid;
- (NSString*) name;

- (void) setServer_uid: (int) newServer_uid;
- (void) setAlert_uid: (int) newAlert_uid;
- (void) setName: (NSString*) newName;
- (void) setUid: (int) newUid;
@end
