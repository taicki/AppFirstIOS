//
//  AppHelper.h
//  AppFirst
//
//  Created by appfirst on 6/15/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
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
+ (NSString*) formatResourceValue:(NSString*) metric value:(double) value;

/** Returns a different color for the first 10 plots. */
+ (UIColor *) colorByIndex:(NSInteger)index;
+ (NSString *) base64Encoding:(NSString*) userLogin;
+ (NSString *)encodeBase64WithData:(NSData *)objData;
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

+ (void) sortArrayByKey: (NSString *) sortKey dictionary: (NSMutableArray *) array;

@end
