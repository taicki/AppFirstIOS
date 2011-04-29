//
//  AppStrings.m
//  AppFirst
//
//  Created by appfirst on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppStrings.h"


@implementation AppStrings

+ (NSString*) appfirstServerAddress {
    return @"https://wwws.appfirst.com";
}

+ (NSString*) serverListUrl {
    return @"/api/v1/servers/";
}

+ (NSString*) alertHistoryUrl {
    return @"/api/v1/alert-histories/";
}

+ (NSString*) polledDataListUrl {
    return @"/api/v1/polled-data/";
}

+ (NSString*) alertListUrl {
    return @"/api/v1/alerts/";
}

+ (NSString*) applicationListUrl {
    return @"/api/v1/applications/";
}

+ (NSString*) mobileDeviceListUrl {
    return  @"/api/v1/mobile-devices/";
}

+ (NSString*) processListUrl {
    return @"/api/v1/pocesses/";

}

@end
