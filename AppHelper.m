//
//  AppHelper.m
//  AppFirst
//
//  Created by appfirst on 6/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppHelper.h"
#import "config.h"


@implementation AppHelper

+ (CGSize)getDeviceBound{
	CGSize ret;
	
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200 // for real device
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			ret = CGSizeMake(IPAD_SCREEN_WIDTH, IPAD_SCREEN_HEIGHT);
		} else {
			ret = CGSizeMake(IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
		}
	#else
		if (self.view.bounds.size.width < 700) { // for simulator
			ret = CGSizeMake(IPAD_SCREEN_WIDTH, IPAD_SCREEN_HEIGHT);
		} else {
			ret = CGSizeMake(IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT);
		}
	#endif
	
	return ret;
}

+ (BOOL) isIPad {
	BOOL ret = NO;
	
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200 // for real device
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			ret = YES;
		} else {
			ret = NO;
		}
	#else
		if (self.view.bounds.size.width > 700) { // for simulator
			ret = YES;
		} else {
			ret = NO;
		}
	#endif
	
	return ret;
}



+ (NSString*) formatDateString:(NSDate*) date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	NSString *currentTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	return currentTime;
}

+ (UIColor*) backgroundGradientColor1 {
	return [UIColor colorWithRed:202 green:202 blue:202 alpha:0.9];
}

+ (UIColor*) backgroundGradientColor2 {
	return [UIColor colorWithRed:202 green:202 blue:202 alpha:0.9];
}

+ (NSString*) formatMetricsValue:(NSString*) metric :(double) value {
	NSString* ret = @"";
	if ([metric isEqualToString:@"cpu"]) { 
		ret =  [NSString stringWithFormat:@"CPU: %0.1f%@", value, @"%"]; 
	} else if ([metric isEqualToString:@"disk"]) {
		ret =  [NSString stringWithFormat:@"Disk: %0.1f%@", value, @"%"];

	} else if ([metric isEqualToString:@"memory"]) {
		ret =  [NSString stringWithFormat:@"Memory: %0.1f%@", value, @"MB"];
	}
	
	return ret;
}



@end
