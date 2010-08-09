//
//  AppHelper.m
//  AppFirst
//
//  Created by appfirst on 6/15/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AppHelper.h"
#import "config.h"
#import "S7Macros.h"


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
	
	if ([AppHelper isIPad]) {
		[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	} else {
		[dateFormatter setDateFormat:@"MMM dd, HH:mm"];
	}
	NSString *currentTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	return currentTime;
}


+ (NSString*) formatShortDateString:(NSDate*) date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, HH:mm"];
	NSString *currentTime = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	return currentTime;
}

+ (NSString*) formatYLabel:(NSUInteger) value {
	NSString* stringValue = [NSString stringWithFormat:@"%d", value];
	
	if ([stringValue length] > 10) {
		return [NSString stringWithFormat:@"%dG", value / 1000000000];	
	}
	else if ([stringValue length] > 7) {
		return [NSString stringWithFormat:@"%dM", value / 1000000];
	} else{
		return [NSString stringWithFormat:@"%dK", value / 1000];
	}
}


+ (UIColor*) backgroundGradientColor1 {
	return [UIColor colorWithRed:202 green:202 blue:202 alpha:0.9];
}

+ (UIColor*) backgroundGradientColor2 {
	return [UIColor colorWithRed:202 green:202 blue:202 alpha:0.9];
}

+ (NSString*) formatMetricsValue:(NSString*) metric :(double) value {
	NSString* ret = @"";
	if ([metric isEqualToString:@"CPU"]) { 
		ret =  [NSString stringWithFormat:@"%0.1f%@", value, @"%"]; 
	} else if ([metric isEqualToString:@"Files"] ||
			   [metric isEqualToString:@"Regs"] || 
			   [metric isEqualToString:@"Net"] || 
			   [metric isEqualToString:@"Threads"] || 
			   [metric isEqualToString:@"PF"] || 
			   [metric isEqualToString:@"IR"] || 
			   [metric isEqualToString:@"CIR"]
			   ) {
		ret =  [NSString stringWithFormat:@"%0.0f", value];

	} else if ([metric isEqualToString:@"Mem"] || 
			   [metric isEqualToString:@"In"] || 
			   [metric isEqualToString:@"Out"] || 
			   [metric isEqualToString:@"FR"] || 
			   [metric isEqualToString:@"FW"]) {
		ret =  [NSString stringWithFormat:@"%0.0f%@", value/1000, @"KB"];
	} else if ([metric isEqualToString:@"ART"]) {
		ret =  [NSString stringWithFormat:@"%0.0f%@", value, @"µs"];
	}
	
	
	return ret;
}
+ (UIColor *)colorByIndex:(NSInteger)index {
	
	UIColor *color;
	
	switch (index) {
		case 0: color = RGB(0x4b, 0xac, 0xc6);
			break;
		case 1: color = RGB(0xbf, 0x44, 0xba);
			break;		
		case 2: color = RGB(0x9d, 0xbb, 0x61);
			break;
		case 3: color = RGB(0x80, 0x66, 0xa0);
			break;
		case 4: color = RGB(0xe1, 0xb1, 0x0d);
			break;
		case 5: color = RGB(0x5c, 0x83, 0xb4);
			break;
		case 6: color = RGB(0xbb, 0x88, 0x92);
			break;
		case 7: color = RGB(0xf5, 0x9d, 0x56);
			break;
		case 8: color = RGB(0xc0, 0x50, 0x4d);
			break;
		case 9: color = RGB(0x7d, 0xcc, 0x5e);
			break;
		case 10: color = RGB(0xd1, 0x96, 0xe7);
			break;
		case 11: color = RGB(0x7d, 0xcc, 0x5e);
			break;	
		case 12: color = RGB(0x00, 0xff, 0x00);
			break;	
		case 13: color = RGB(0xff, 0x00, 0x00);
			break;	
		case 14: color = RGB(0x29, 0xa2, 0x35);
			break;	
		case 15: color = RGB(0x94, 0x94, 0x94);
			break;
		case 16: color = RGB(0xcf, 0xc8, 0x00);
			break;
		case 17: color = RGB(0xcb, 0x81, 0x0e);
			break;
		case 18: color = RGB(0xc0, 0x6f, 0x4a);
			break;
		case 19: color = RGB(0x8c, 0x8a, 0xb4);
			break;
		case 20: color = RGB(0xff, 0xd7, 0x51);
			break;	
		case 21: color = RGB(0x2f, 0x89, 0xb8);
			break;	
		default: color = RGB(0xff, 0xff, 0xff);
			break;
	}
	
	return color;
}



@end
