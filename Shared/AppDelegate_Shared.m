//
//  AppDelegate_Shared.m
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright AppFirst Inc 2010. All rights reserved.
//

#import "AppDelegate_Shared.h"
#import "SFHFKeychainUtils.h"
#import "JSON/JSON.h"
#import "config.h"
#import "AFTitleView.h"

@implementation AppDelegate_Shared

@synthesize window;
@synthesize tabcontroller, loginController;
@synthesize alertController, dashboardController, notificationController;
@synthesize availableCookies, usernames;
@synthesize alertListUrl, serverListUrl, urlBase, loginUrl, UUID;


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 
 Conditionalize for the current platform, or override in the platform-specific subclass if appropriate.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	self.UUID = [NSString stringWithFormat:@"%@", devToken];
	
	NSHTTPURLResponse *response;
	NSError *error = nil;
	
	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:appDelegate.availableCookies];
	NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	
	NSString *queryUrl;
	
	if (DEBUGGING == YES) {
		queryUrl = [NSString stringWithFormat:@"%@%@", DEV_SERVER_IP, UUID_SET_API_STRING];
	} else {
		queryUrl = [NSString stringWithFormat:@"%@%@", PROD_SERVER_IP, UUID_SET_API_STRING];
	}
	
	
	postRequest.URL = [NSURL URLWithString:queryUrl];
	
	NSString *postData = [NSString stringWithFormat:@"uid=%@", devToken];
	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	
	[postRequest setValue:length forHTTPHeaderField:@"Content-Length"];
	[postRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
	[postRequest setHTTPMethod:@"POST"];
	[postRequest setAllHTTPHeaderFields:headers];
	
	[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
	
	UINavigationController* navigationController = [self.tabcontroller.viewControllers objectAtIndex:2];
	
	if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
		navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [UIApplication sharedApplication].applicationIconBadgeNumber];
	} 
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	// This is expected on the emulator so that's fine
    NSLog(@"Error in registration. Error: %@", err);
}


- (void) finishLoading:(id)theJobToDo {
	NSError *error;
	
	[self trySubmitUUID];
	
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
	
	
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	NSString *currentTime = [dateFormatter stringFromDate:today];
	[dateFormatter release];
	
	
	AFTitleView* titleView = (AFTitleView*)alertController.navigationItem.titleView;
	titleView.titleLabel.text = @"Alerts";
	titleView.timeLabel.text = [NSString stringWithFormat:@"Updated at %@", currentTime];
	
	titleView = (AFTitleView*)dashboardController.navigationItem.titleView;
	titleView.titleLabel.text = @"Servers";
	titleView.timeLabel.text = [NSString stringWithFormat:@"Updated at %@", currentTime];
	
	[dashboardController asyncGetServerListData];
	[alertController asyncGetListData];

}

- (void) loginFailed:(NSString*)message {
	
	
	loginController.loginButton.enabled = YES;
	loginController.invalidLoginLabel.hidden = NO;
	[loginController.loginIndicator stopAnimating];
	loginController.loginIndicator.hidden = YES;
	loginController.invalidLoginLabel.text = message;
	loginController.view.userInteractionEnabled = YES;
	
	UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Could not login. " message: message delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[networkError show];
	[networkError release];
	
	if (loginController.view.superview == nil)
		[window addSubview:loginController.view];
	
	// delete the password
	//[SFHFKeychainUtils storeUsername:self.loginController.usernameField.text andPassword:@""
	//				  forServiceName:@"appfirst" updateExisting:YES error:&error];
}


- (void) trySignOut {
	
	NSError *error;
	[SFHFKeychainUtils storeUsername:self.loginController.usernameField.text andPassword:@""
					  forServiceName:@"appfirst" updateExisting:YES error:&error];
	

	[tabcontroller.view removeFromSuperview];
	[window addSubview:loginController.view];
	loginController.view.userInteractionEnabled = YES;

}

- (void) trySignIn:(id)theJobToDo {
	
	
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSHTTPURLResponse *response;
	NSError *error = nil;
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	NSURL *myWebserverURL = [NSURL URLWithString:self.loginUrl];
	
	
	//self.loginController.passwordField.text = @"1AppFirst$";
	
	NSString *post =[NSString stringWithFormat:@"username=%@&password=%@", 
					self.loginController.usernameField.text , self.loginController.passwordField.text];
					 
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval:30];
	[request setURL:myWebserverURL];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	if (DEBUGGING)
		[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[myWebserverURL host]];
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	
	if (DEBUGGING == YES) {
		NSLog(@"RESPONSE HEADERS: \n%@", [response allHeaderFields]);
	}
	
	
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
		
		[self performSelectorOnMainThread:@selector(loginFailed:)
							   withObject:[error localizedDescription]
							waitUntilDone:NO
		 ];
		
		
		[pool drain];
		return;
	}
	
	// If you want to get all of the cookies:
	NSArray * all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:urlBase]];
	
	//loginController.loginIndicator.hidden = YES;
	
	if ( all.count == 0) {
		
		//NSLog(@"%@", [error localizedDescription]);
		
		[self performSelectorOnMainThread:@selector(loginFailed:)
							   withObject:@"Invalid login."
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
		alertController.availableCookies = self.availableCookies;
		
		[self performSelectorOnMainThread:@selector(finishLoading:)
							   withObject:nil
							waitUntilDone:NO
		 ];
		
	}
	
	[pool drain];
	
}


- (void) trySubmitUUID {
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	
}



#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.

 Conditionalize for the current platform, or override in the platform-specific subclass if appropriate.
*/
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"AppFirst.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[tabcontroller release];
	[loginController release];
	
	[alertController release];
	[dashboardController release];
	[notificationController release];
	
	[availableCookies release];
	[serverListUrl release];
	[loginUrl release];
	[alertListUrl release];
	[urlBase release];
	[usernames release];
	[UUID release];
	
	[super dealloc];
}


@end

