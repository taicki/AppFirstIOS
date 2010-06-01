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
			
			if (DEBUGGING) {
				NSLog(@"password: %@", [SFHFKeychainUtils getPasswordForUsername:self.loginController.usernameField.text andServiceName:@"appfirst" error:&error]);
			}
		}
		
		@catch (NSException * e) {
			NSLog(@"Exception :%@", [e reason]);
		}
		@finally {
			
		}
	}
	
	self.loginController.usernameField.text = @"andrew@appfirst.com";
	self.loginController.passwordField.text = @"1AppFirst$";
	
	
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
	loginController.view.userInteractionEnabled = NO;
	
	// start the background queries of data
	[self performSelectorInBackground:@selector(trySignIn:)
						   withObject:nil];
	
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

