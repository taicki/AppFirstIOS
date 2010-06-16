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

@end
