//
//  AM_AlertHistory.h
//  AppFirst
//
//  Created by appfirst on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
