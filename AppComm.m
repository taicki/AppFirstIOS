//
//  AppComm.m
//  AppFirst
//
//  Created by appfirst on 4/28/11.
//  Copyright 2011 AppFirst. All rights reserved.
//

#import "AppComm.h"
#import "AppHelper.h"


@implementation AppComm

+ (NSData *)makeGetRequest:(NSString *)url {
    NSHTTPURLResponse *response;
    NSError *error = nil;
    NSLog(@"%@", url);
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
    [encodedString retain];
    [authString release];
	authString = [NSString stringWithFormat:@"Basic %@", [encodedString stringByTrimmingCharactersInSet:
                                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}



@end
