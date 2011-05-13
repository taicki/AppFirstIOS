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

#import "AppComm.h"
#import "AppHelper.h"


@implementation AppComm

static NSString* authString;
+ (NSData *)makeGetRequest:(NSString *)url {
    NSHTTPURLResponse *response;
    NSError *error = nil;
    NSURL *myWebserverURL = [NSURL URLWithString:url];
	
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval:30];
	[request setURL:myWebserverURL];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authString forHTTPHeaderField:@"Authorization"];
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return NULL;
    } else {
        return responseData;
    }
}

+ (void) setAuthStringWith:(NSString *)username andPassword:(NSString *)password {
    NSString* loginString = [NSString stringWithFormat:@"%@:%@", 
                             username , password];
    NSString* encodedString = [AppHelper base64Encoding:loginString];
    authString = [NSString stringWithFormat:@"Basic %@", [encodedString stringByTrimmingCharactersInSet:
                                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [authString retain];
}

+ (NSString*) authString {
    return authString;
}



@end
