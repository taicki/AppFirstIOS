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
    return @"/api/v1/processes/";

}

@end
