//
//  AM_PolledDataData.h
//  AppFirst
//
//  Created by appfirst on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AM_PolledDataData : NSObject {
    long time;
    NSString* status;
    NSString* text;
    NSDictionary* values;
}

- (id) initWithJSONObject: (NSDictionary*) jsonObject;

- (long) time;
- (NSString*) status;
- (NSString*) text;
- (NSDictionary*) values;


- (void) setTime: (long) newTime;
- (void) setStatus: (NSString*) newStatus;
- (void) setText: (NSString*) newText;
- (void) setValues: (NSDictionary*) newValues;

@end
