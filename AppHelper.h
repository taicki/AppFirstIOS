/*
 * Copyright 2009-2011 AppFirst, Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



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
