//
//  AppDelegate_Phone.m
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate_Phone.h"
#import "../Shared/JSON/JSON.h"
#import "config.h"
#import "SFHFKeychainUtils.h"


@implementation AppDelegate_Phone


#pragma mark -
#pragma mark Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch
	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSError* error;
	
	if (standardUserDefaults) {
		self.loginController.usernameField.text = [standardUserDefaults objectForKey:DEFAULT_USER_NAME_KEY];
		
		@try {
			self.loginController.passwordField.text = [SFHFKeychainUtils getPasswordForUsername:self.loginController.usernameField.text andServiceName:@"appfirst" error:&error];
			NSLog(@"password: %@", [SFHFKeychainUtils getPasswordForUsername:self.loginController.usernameField.text andServiceName:@"appfirst" error:&error]);
		}
		
		@catch (NSException * e) {
			NSLog(@"Exception :%@", [e reason]);
		}
		@finally {
			
		}
	}
	
	//self.loginController.usernameField.text = @"andrew@appfirst.com";
	//self.loginController.passwordField.text = @"appfirst";
	
	
	if (DEBUGGING == YES) {
		self.urlBase = DEV_SERVER_IP;
	} else {
		self.urlBase = PROD_SERVER_IP;
	}

	
	self.loginUrl = [NSString stringWithFormat:@"%@%@", urlBase, LOGIN_API_STRING];
	self.serverListUrl = [NSString stringWithFormat:@"%@%@", urlBase, SERVER_LIST_API_STRING];
	self.alertListUrl = [NSString stringWithFormat:@"%@%@", urlBase, ALERT_LIST_API_STRING];
	
	
	[window addSubview:[loginController view]];
    
	[window makeKeyAndVisible];
	
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
	
	
	// start the background queries of data
	[self performSelectorInBackground:@selector(trySignIn:)
						   withObject:nil];
	
}

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

