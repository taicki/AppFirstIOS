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
#import "SFHFKeychainUtils.h"


@implementation AppDelegate_Pad

#pragma mark -
#pragma mark Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
		
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSError* error;
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	NSString* password;
	
	if (standardUserDefaults) {
		self.loginController.usernameField.text = [standardUserDefaults objectForKey:DEFAULT_USER_NAME_KEY];
		
		@try {
			password = [SFHFKeychainUtils getPasswordForUsername:self.loginController.usernameField.text andServiceName:@"appfirst" error:&error];
			self.loginController.passwordField.text = password ;
			NSLog(@"password: %@",password);
		}
		
		@catch (NSException * e) {
			NSLog(@"Exception :%@", [e reason]);
		}
		@finally {
			
		}
	}
	
	
	if (DEBUGGING == YES) {
		self.urlBase = DEV_SERVER_IP;
	}else {
			self.urlBase = PROD_SERVER_IP;
	}

	
	self.loginUrl = [NSString stringWithFormat:@"%@%@", urlBase, LOGIN_API_STRING];
	self.serverListUrl = [NSString stringWithFormat:@"%@%@", urlBase, SERVER_LIST_API_STRING];
	self.alertListUrl = [NSString stringWithFormat:@"%@%@", urlBase, ALERT_LIST_API_STRING];
	
	
	[window addSubview:[loginController view]];
	[window makeKeyAndVisible];
	
	if (password != nil) 
		[self trySignIn:nil];
	
	return YES;
}


- (IBAction) login: (id) sender
{
	
	// TODO: spawn a login thread
	
	loginController.loginIndicator.hidden = NO;
	loginController.invalidLoginLabel.hidden = YES;
	[loginController.loginIndicator startAnimating];
	[loginController.loginIndicator setNeedsDisplay];
	
	loginController.loginButton.enabled = NO;
	loginController.view.userInteractionEnabled = NO;
	
	// start the background queries of data
	[self performSelectorInBackground:@selector(trySignIn:)
						   withObject:nil];
	
}


/*
- (void) finishLoading:(id)theJobToDo {
	NSError *error;
	
	if (self.loginController.savePassword.on == YES) {
		// now remember the password if login is successful
		[SFHFKeychainUtils storeUsername:self.loginController.usernameField.text andPassword:self.loginController.passwordField.text
						  forServiceName:@"appfirst" updateExisting:YES error:&error];
		
		NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
		if (standardUserDefaults) {
			[standardUserDefaults setObject:self.loginController.usernameField.text forKey:DEFAULT_USER_NAME_KEY];
			[standardUserDefaults synchronize];
		}
		
		[error release];
	}
	
	
	[loginController.loginIndicator stopAnimating];
	loginController.loginIndicator.hidden = YES;
	[loginController.view removeFromSuperview];
	[window addSubview:tabcontroller.view];
	
}

- (void) loginFailed:(id)theJobToDo {
	NSError *error;
	
	
	loginController.loginButton.enabled = YES;
	loginController.invalidLoginLabel.hidden = NO;
	[loginController.loginIndicator stopAnimating];
	loginController.loginIndicator.hidden = YES;
	
	// delete the password
	[SFHFKeychainUtils storeUsername:self.loginController.usernameField.text andPassword:@""
					  forServiceName:@"appfirst" updateExisting:YES error:&error];
}



- (void) trySignIn:(id)theJobToDo {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSHTTPURLResponse *response;
	NSError *error;
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];

	
	
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
	
	
	if (DEBUGGING == YES) {
		[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[myWebserverURL host]];
	}
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	
	if (DEBUGGING == YES) {
		NSLog(@"RESPONSE HEADERS: \n%@", [response allHeaderFields]);
	}
	
	// If you want to get all of the cookies:
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:urlBase]];

	//loginController.loginIndicator.hidden = YES;
	
	if (error || all.count == 0) {
		
		NSLog(@"%@", [error localizedDescription]);
		
		[self performSelectorOnMainThread:@selector(loginFailed:)
							   withObject:nil
							waitUntilDone:NO
		 ];
		
		
	} else {
		
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] 
				setCookies:all forURL:[NSURL URLWithString:urlBase] mainDocumentURL:nil];
	
		if (DEBUGGING == YES) {
			for (NSHTTPCookie *cookie in all)
				NSLog(@"Name: %@ : Value: %@, Expires: %@", cookie.name, cookie.value, cookie.expiresDate); 
		}
		self.availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlBase]];
	
		dashboardController.availableCookies = self.availableCookies;
		[self.dashboardController getServerListData:NO];
		
		alertController.availableCookies = self.availableCookies;
		[self.alertController getAlertListData:NO];
		
		
		[self performSelectorOnMainThread:@selector(finishLoading:)
							   withObject:nil
							waitUntilDone:NO
		 ];

	}
	
	[pool drain];
	
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

- (void) getAlertListData {
	NSHTTPURLResponse *response;
	NSError *error;
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.availableCookies];
	
	
	NSMutableURLRequest *alertListRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	// we are just recycling the original request
	[alertListRequest setHTTPMethod:@"GET"];
	[alertListRequest setAllHTTPHeaderFields:headers];
	[alertListRequest setHTTPBody:nil];
	
	alertListRequest.URL = [NSURL URLWithString:self.alertListUrl];
	
	
	NSData * data = [NSURLConnection sendSynchronousRequest:alertListRequest returningResponse:&response error:&error];
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
		return;
	}
	
	NSString *jsonString = [[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding] autorelease];
	NSLog(@"The server saw:\n%@", jsonString);
	
	NSDictionary *dictionary = [jsonString JSONValue];
	
	alertController.alerts = dictionary.allKeys;
	alertController.allData = dictionary;

}
*/

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

