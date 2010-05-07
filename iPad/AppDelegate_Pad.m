//
//  AppDelegate_Pad.m
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import "../Shared/JSON/JSON.h"

@implementation AppDelegate_Pad


#pragma mark -
#pragma mark Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	[window addSubview:tabcontroller.view];
    [window makeKeyAndVisible];
	
	
	[self trySignIn];
	
		
	return YES;
}

- (void) trySignIn {
	
	NSHTTPURLResponse *response;
	NSError *error;
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSString *urlBase = @"https://192.168.1.102";
	//NSString *urlBase = @"http://192.168.1.141:8000";
	NSString *logInUrl = [NSString stringWithFormat:@"%@%@", urlBase, @"/api/iphone/login/"];
	NSString *serverListUrl = [NSString stringWithFormat:@"%@%@", urlBase, @"/api/topology/data/node/"];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	NSURL *myWebserverURL = [NSURL URLWithString:logInUrl];
	
	NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",@"andrew@appfirst.com", @"appfirst"];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setURL:myWebserverURL];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[myWebserverURL host]];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
		return;
	}
	
	NSLog(@"RESPONSE HEADERS: \n%@", [response allHeaderFields]);
	
	// If you want to get all of the cookies:
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:urlBase]];
	NSLog(@"How many Cookies: %d", all.count);
	// Store the cookies:
	// NSHTTPCookieStorage is a Singleton.
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:urlBase] mainDocumentURL:nil];
	
	// Now we can print all of the cookies we have:
	for (NSHTTPCookie *cookie in all)
		NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate); 
	
	
	NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlBase]];
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
	
	
	NSMutableURLRequest *serverListRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	// we are just recycling the original request
	[serverListRequest setHTTPMethod:@"GET"];
	[serverListRequest setAllHTTPHeaderFields:headers];
	[serverListRequest setHTTPBody:nil];
	
	serverListRequest.URL = [NSURL URLWithString:serverListUrl];
	error       = nil;
	response    = nil;
	
	NSData * data = [NSURLConnection sendSynchronousRequest:serverListRequest returningResponse:&response error:&error];
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
		return;
	}
	
	NSString *jsonString = [[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding] autorelease];
	NSLog(@"The server saw:\n%@", jsonString);
	
	NSDictionary *dictionary = [jsonString JSONValue];
	//NSLog(@"Dictionary value for \"request\" is \"%@\"", [dictionary objectForKey:@"appfirst-snoopy"]);


	dashboardController.servers = dictionary.allKeys;
	dashboardController.allData = dictionary;
}

/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[super dealloc];
}


@end

