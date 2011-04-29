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


static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
	52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
	-2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
	-2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
	-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

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

+ (NSString *) base64Encoding:(NSString*) userLogin {
    NSLog(@"encrypting string = %@",userLogin);
    NSData *data = [userLogin dataUsingEncoding: NSASCIIStringEncoding];
	NSString *b64EncStr = [AppHelper encodeBase64WithData:data];
    NSLog(@"encrypted string = %@", b64EncStr);
    return b64EncStr;
}

+ (NSString *)encodeBase64WithData:(NSData *)objData {
	const unsigned char * objRawData = [objData bytes];
	char * objPointer;
	char * strResult;
    
	// Get the Raw Data length and ensure we actually have data
	int intLength = [objData length];
	if (intLength == 0) return nil;
    
	// Setup the String-based Result placeholder and pointer within that placeholder
	strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
	objPointer = strResult;
    
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3; 
	}
    
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
    
	// Terminate the string-based result
	*objPointer = '\0';
    
	// Cleanup
	NSString * strToReturn = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
	free(strResult);
    
	// Return the results as an NSString object
	return [NSString stringWithString:strToReturn];
}

+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
	const char * objPointer = [strBase64 cStringUsingEncoding:NSASCIIStringEncoding];
	int intLength = strlen(objPointer);
	int intCurrent;
	int i = 0, j = 0, k;
    
	unsigned char * objResult;
	objResult = calloc(intLength, sizeof(char));
    
	// Run through the whole string, converting as we go
	while ( ((intCurrent = *objPointer++) != '\0') && (intLength-- > 0) ) {
		if (intCurrent == '=') {
			if (*objPointer != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
				// the padding character is invalid at this point -- so this entire string is invalid
				free(objResult);
				return nil;
			}
			continue;
		}
        
		intCurrent = _base64DecodingTable[intCurrent];
		if (intCurrent == -1) {
			// we're at a whitespace -- simply skip over
			continue;
		} else if (intCurrent == -2) {
			// we're at an invalid character
			free(objResult);
			return nil;
		}
        
		switch (i % 4) {
			case 0:
				objResult[j] = intCurrent << 2;
				break;
                
			case 1:
				objResult[j++] |= intCurrent >> 4;
				objResult[j] = (intCurrent & 0x0f) << 4;
				break;
                
			case 2:
				objResult[j++] |= intCurrent >>2;
				objResult[j] = (intCurrent & 0x03) << 6;
				break;
                
			case 3:
				objResult[j++] |= intCurrent;
				break;
		}
		i++;
	}
    
	// mop things up if we ended on a boundary
	k = j;
	if (intCurrent == '=') {
		switch (i % 4) {
			case 1:
				// Invalid state
				free(objResult);
				return nil;
                
			case 2:
				k++;
				// flow through
			case 3:
				objResult[k] = 0;
		}
	}
    
	// Cleanup and setup the return NSData
	NSData * objData = [[[NSData alloc] initWithBytes:objResult length:j] autorelease];
	free(objResult);
	return objData;
}


@end
