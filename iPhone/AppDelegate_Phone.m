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
	NSError* error = nil;
	NSString* password;
	
	if (standardUserDefaults) {
		self.loginController.usernameField.text = [standardUserDefaults objectForKey:DEFAULT_USER_NAME_KEY];
		
		@try {
			password = [SFHFKeychainUtils getPasswordForUsername:self.loginController.usernameField.text andServiceName:@"appfirst" error:&error];
			self.loginController.passwordField.text = password;
			
			if (DEBUGGING) {
				NSLog(@"password: %@",password);
			}
			
			if (error) {
				NSLog(@"%@", error);
			}
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
	
	UIDevice* device = [UIDevice currentDevice];
	BOOL backgroundSupported = NO;
	if ([device respondsToSelector:@selector(isMultitaskingSupported)])
		backgroundSupported = device.multitaskingSupported;
	
	if (backgroundSupported == YES) 
		NSLog(@"true");
	
	if (password != nil && (![password isEqualToString:@""])) {
		[window makeKeyAndVisible];
		[self trySignIn:nil];
	} else {
		[window addSubview:[loginController view]];
		[window makeKeyAndVisible];
	}
	
	return YES;
}




- (IBAction) login: (id) sender
{
	
	// TODO: spawn a login thread
	
	loginController.loginIndicator.hidden = NO;
	loginController.invalidLoginLabel.hidden = YES;
	[loginController.loginIndicator startAnimating];
	[loginController.loginIndicator setNeedsDisplay];
	
	//loginController.loginButton.enabled = NO;
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

