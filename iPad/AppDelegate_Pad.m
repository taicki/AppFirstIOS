//
//  AppDelegate_Pad.m
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate_Pad.h"
#import "../Shared/JSON/JSON.h"
#import "config.h"
#import "CorePlot-CocoaTouch.h"


@implementation AppDelegate_Pad

@synthesize viewController;
#pragma mark -
#pragma mark Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
	//CPLayerHostingView * newView = [[CPLayerHostingView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
	//[newView release];
	return YES;

	NSString *path = [[NSBundle mainBundle] pathForResource: @"cookie" 
													 ofType: @"plist"] ;
	NSMutableArray *tmpArray = [[NSMutableArray alloc] 
								initWithContentsOfFile: path];
	
	if (DEBUGGING == @"YES") {
		self.urlBase = DEV_SERVER_IP;
	}
	self.loginUrl = [NSString stringWithFormat:@"%@%@", urlBase, LOGIN_API_STRING];
	self.serverListUrl = [NSString stringWithFormat:@"%@%@", urlBase, SERVER_LIST_API_STRING];
	
	if (tmpArray) {
		self.availableCookies = tmpArray;
		[window addSubview:tabcontroller.view];
		[self getServerListData];
		
	} else {
		[window addSubview:[loginController view]];
    }
	
	[tmpArray release];
	[window makeKeyAndVisible];
	
	return YES;
}

- (IBAction) login: (id) sender
{
	
	// TODO: spawn a login thread
	
	loginController.loginIndicator.hidden = FALSE;
	loginController.invalidLoginLabel.hidden = YES;
	[loginController.loginIndicator startAnimating];
	
	loginController.loginButton.enabled = FALSE;
	
	
	[self trySignIn];
}


- (void) trySignIn {
	
	NSHTTPURLResponse *response;
	NSError *error;
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	NSLog(@"%@", loginUrl);
	NSURL *myWebserverURL = [NSURL URLWithString:self.loginUrl];
	
	NSString *post =[NSString stringWithFormat:@"username=%@&password=%@", 
					self.loginController.usernameField.text , self.loginController.passwordField.text];
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setURL:myWebserverURL];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	
	if (DEBUGGING == @"YES") {
		[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[myWebserverURL host]];
		
		
	}
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	
	
	NSLog(@"RESPONSE HEADERS: \n%@", [response allHeaderFields]);
	
	// If you want to get all of the cookies:
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:urlBase]];
	NSLog(@"How many Cookies: %d", all.count);
	
	if (error || all.count == 0) {
		NSLog(@"%@", [error localizedDescription]);
		loginController.loginButton.enabled = YES;
		loginController.loginIndicator.hidden = YES;
		loginController.invalidLoginLabel.hidden = FALSE;
		return;
	}
	
	// Store the cookies:
	// NSHTTPCookieStorage is a Singleton.
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[NSURL URLWithString:urlBase] mainDocumentURL:nil];
	
	// Now we can print all of the cookies we have:
	for (NSHTTPCookie *cookie in all)
		NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate); 
	
	self.availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlBase]];
	
	//NSString *path = [ [ NSBundle mainBundle]  
	//				  pathForResource: @"cookies" ofType: @"plist"] ;
	//[self.availableCookies writeToFile: path atomically: YES] ;
	
	[loginController.view removeFromSuperview];
	[window addSubview:tabcontroller.view];
	
	[self getServerListData];
}

- (void) getServerListData {
	NSHTTPURLResponse *response;
	NSError *error;
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.availableCookies];
	
	
	NSMutableURLRequest *serverListRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	// we are just recycling the original request
	[serverListRequest setHTTPMethod:@"GET"];
	[serverListRequest setAllHTTPHeaderFields:headers];
	[serverListRequest setHTTPBody:nil];
	
	serverListRequest.URL = [NSURL URLWithString:self.serverListUrl];
	
	
	NSData * data = [NSURLConnection sendSynchronousRequest:serverListRequest returningResponse:&response error:&error];
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
		return;
	}
	
	NSString *jsonString = [[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding] autorelease];
	NSLog(@"The server saw:\n%@", jsonString);
	
	NSDictionary *dictionary = [jsonString JSONValue];
	
	
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
	
	[viewController release];
	[super dealloc];
}


@end

