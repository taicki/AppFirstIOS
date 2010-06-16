//
//  AppHelper.h
//  AppFirst
//
//  Created by appfirst on 6/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//



@interface AppHelper : NSObject {
	
}

+ (CGSize)getDeviceBound;
+ (BOOL) isIPad;
+ (NSString*) formatDateString:(NSDate *)date;

@end
