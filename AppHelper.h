//
//  AppHelper.h
//  AppFirst
//
//  Created by appfirst on 6/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//



@interface AppHelper : NSObject {
	
}
+ (NSString*) formatShortDateString:(NSDate*) date;
+ (CGSize)getDeviceBound;
+ (BOOL) isIPad;
+ (NSString*) formatDateString:(NSDate *)date;
+ (UIColor*) backgroundGradientColor2;
+ (UIColor*) backgroundGradientColor1;
+ (NSString*) formatMetricsValue:(NSString*) metric :(double) value;
+ (NSString*) formatYLabel:(NSUInteger) value;

/** Returns a different color for the first 10 plots. */
+ (UIColor *)colorByIndex:(NSInteger)index;
@end
