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
#import "AppHelper.h"
#import "AM_Server.h"
#import "AppStrings.h"
#import "AppComm.h"
#import "AM_PolledData.h"
#import "AM_Alert.h"
#import "AM_AlertHistory.h"
#import "AM_Application.h"
#import "AppHelper.h"

@implementation AppDelegate_Shared

@synthesize window;
@synthesize tabcontroller, loginController;
@synthesize notificationController;
@synthesize availableCookies, usernames, serverIdHostNameMap;
@synthesize alertListUrl, serverListUrl, urlBase, loginUrl, UUID;
@synthesize navigationController, homeViewController;

- (void) setApplicaitonList:(NSMutableArray *)newData {
    [newData retain];
    [applicationList release];
    applicationList = newData;
}

- (void) setAlertList:(NSMutableArray *)newData {
    [newData retain];
    [alertList release];
    alertList = newData;
}

- (void) setPolledDataList:(NSMutableArray *)newData {
    [newData retain];
    [polledDataList release];
    polledDataList = newData;
}

- (void) setServerList:(NSMutableArray *)newData {
    [newData retain];
    [serverList release];
    serverList = newData;
}

- (void) setAlertHistoryList:(NSMutableArray *)newData {
    [newData retain];
    [alertHistoryList release];
    alertHistoryList = newData;
}

- (NSMutableArray*) alertList {
    return alertList;
}

- (NSMutableArray*) alertHistoryList {
    return alertHistoryList;
}

- (NSMutableArray*) serverList {
    return serverList;
}

- (NSMutableArray*) applicationList {
    return applicationList;
}

- (NSMutableArray*) polledDataList {
    return polledDataList;
}


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

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
     UIApplication*    app = [UIApplication sharedApplication];
     
     // Request permission to run in the background. Provide an
     // expiration handler in case the task runs long.
     NSAssert(bgTask == UIBackgroundTaskInvalid, nil);
     
     bgTask = [app beginBackgroundTaskWithExpirationHandler:{
     // Synchronize the cleanup call on the main thread in case
     // the task actually finishes at around the same time.
     dispatch_async(dispatch_get_main_queue(), ^{
     if (bgTask != UIBackgroundTaskInvalid)
     {
     [app endBackgroundTask:bgTask];
     bgTask = UIBackgroundTaskInvalid;
     }
     });
     }];
     
     // Start the long-running task and return immediately.
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
     
     // Do the work associated with the task.
     
     // Synchronize the cleanup call on the main thread in case
     // the expiration handler is fired at the same time.
     dispatch_async(dispatch_get_main_queue(), {
     if (bgTask != UIBackgroundTaskInvalid)
     {
     [app endBackgroundTask:bgTask];
     bgTask = UIBackgroundTaskInvalid;
     }
     });
     });
	 */
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
        //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	// This is expected on the emulator so that's fine
    NSLog(@"Error in registration. Error: %@", err);
}


- (void) presentAppFirstRootView {
    homeViewController = [[AV_NavigatorRootController alloc] init];
    [window addSubview:navigationController.view];
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
    
    
    //[detailViewController release];
}
- (void) getData:(NSString*) urlString
{
    [window addSubview:activityIndicator];
    activityIndicator.center = window.center;
    [activityIndicator startAnimating];
    responseData = [[NSMutableData data] retain];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setTimeoutInterval:20];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppComm authString] forHTTPHeaderField:@"Authorization"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
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

- (void) processPolledDataList {
    if (responseData != NULL) {
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSMutableArray *dictionary = (NSMutableArray*)[jsonString JSONValue];
        [jsonString release];
        if ([dictionary count] > 0) {
            NSLog(@"count of polled data: %d", [dictionary count]);
            NSString* sortKey = @"name";
            [AppHelper sortArrayByKey: sortKey dictionary: dictionary];
        }
        [polledDataList removeAllObjects];
        for (int i=0; i < [dictionary count]; i++) {
            AM_PolledData* item = [[[AM_PolledData alloc] initWithJSONObject:[dictionary objectAtIndex:i]] autorelease];
            [polledDataList addObject:item];
        }
    }
}

- (void) loadPolledDataList {
    NSString* urlString = [NSString stringWithFormat:@"%@%@", [AppStrings appfirstServerAddress], [AppStrings polledDataListUrl]];
    [self getData:urlString];
    currentQueryType = 2;
}

- (void) processAlertList {
    if (responseData != NULL) {
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSMutableArray *dictionary = (NSMutableArray*)[jsonString JSONValue];
        [jsonString release];
        if ([dictionary count] > 0) {
            NSLog(@"count of alert: %d", [dictionary count]);
            NSString* sortKey = @"name";
            [AppHelper sortArrayByKey: sortKey dictionary: dictionary];
        }
        [alertList removeAllObjects];
        for (int i=0; i < [dictionary count]; i++) {
            AM_Alert* item = [[AM_Alert alloc] initWithJSONObject:[dictionary objectAtIndex:i]];
            [alertList addObject:item];
            [item release];
        }
    } 
}

- (void) loadAlertList {
    NSString* urlString = [NSString stringWithFormat:@"%@%@", [AppStrings appfirstServerAddress], [AppStrings alertListUrl]];
    currentQueryType = 1;
    [self getData:urlString];
	
    
}

- (void) processAlertHistoryList {
    if (responseData != NULL) {
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSMutableArray *dictionary = (NSMutableArray*)[jsonString JSONValue];
        [jsonString release];
        if ([dictionary count] > 0) {
            NSLog(@"count of alertHistory: %d", [dictionary count]);
            NSString* sortKey = @"name";
            [AppHelper sortArrayByKey: sortKey dictionary: dictionary];
        }
        [alertHistoryList removeAllObjects];
        for (int i=0; i < [dictionary count]; i++) {
            AM_AlertHistory* item = [[[AM_AlertHistory alloc] initWithJSONObject:[dictionary objectAtIndex:i]] autorelease];
            [alertHistoryList addObject:item];
        }
    }    
}

- (void) loadAlertHistoryList {
    NSString* urlString = [NSString stringWithFormat:@"%@%@?num=50", [AppStrings appfirstServerAddress], [AppStrings alertHistoryUrl]];
    [self getData:urlString];
    currentQueryType = 4;
}

- (void) processApplicationList {
    if (responseData != NULL) {
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSMutableArray *dictionary = (NSMutableArray*)[jsonString JSONValue];
        [jsonString release];
        if ([dictionary count] > 0) {
            NSLog(@"count of application: %d", [dictionary count]);
            NSString* sortKey = @"name";
            [AppHelper sortArrayByKey: sortKey dictionary: dictionary];
        }
        [applicationList removeAllObjects];
        for (int i=0; i < [dictionary count]; i++) {
            AM_Application* item = [[[AM_Application alloc] initWithJSONObject:[dictionary objectAtIndex:i]] autorelease];
            [applicationList addObject:item];
        }
    }    

}

- (void) loadApplicationList {
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@", [AppStrings appfirstServerAddress], [AppStrings applicationListUrl]];
    
    [self getData:urlString];
    currentQueryType = 3;
}

- (void) processServerList {
    if (responseData != NULL) {
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSMutableArray *dictionary = (NSMutableArray*)[jsonString JSONValue];
        [jsonString release];
            //[responseData release];
        if ([dictionary count] > 0) {
            
            NSLog(@"count of server: %d", [dictionary count]);
            NSString* sortKey = @"hostname";
            [AppHelper sortArrayByKey: sortKey dictionary: dictionary];
            
        }
        [serverList removeAllObjects];
        for (int i=0; i < [dictionary count]; i++) {
            AM_Server* item = [[[AM_Server alloc] initWithJSONObject:[dictionary objectAtIndex:i]] autorelease];
            [serverIdHostNameMap setValue:[item hostname] forKey:[NSString stringWithFormat:@"%d", [item uid]]];
            [serverList addObject:item];
        }
    }
}

- (void) loadServerList {
    NSString* urlString = [NSString stringWithFormat:@"%@%@", [AppStrings appfirstServerAddress], [AppStrings serverListUrl]];
    [self getData:urlString];
    [serverIdHostNameMap removeAllObjects];
    currentQueryType = 0;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
	switch (currentQueryType) {
        case 0:
            [self processServerList];
            [responseData release];
            if (firstServerQuery) {
                [self loadAlertList];
                firstServerQuery = NO;
            }
            break;
        case 1:
            [self processAlertList];
            [responseData release];
            if (firstAlertQuery) {
                [self loadPolledDataList];
                firstAlertQuery = NO;
                [self.homeViewController viewWillAppear:YES];
            }
            break;
        case 2:
            [self processPolledDataList];
            [responseData release];
            if (firstPolledDataQuery) {
                [self loadApplicationList];
                firstPolledDataQuery = NO;
            }
            break;
        case 3:
            [self processApplicationList];
            [responseData release];
            if (firstApplicationQuery) {
                [self loadAlertHistoryList];
                firstApplicationQuery = NO;
            }
            break;
        case 4:
            [self processAlertHistoryList];
            [responseData release];
            if (firstAlertHistoryQuery) {
                firstAlertHistoryQuery = NO;
                
                [self presentAppFirstRootView];
            }
            break;
        default:
            [responseData release];
            break;
    }
}










- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Can't update server detail. " 
														message: [error localizedDescription] 
													   delegate: self 
											  cancelButtonTitle: @"Ok" 
											  otherButtonTitles: nil];
	[errorView show];
	[errorView release];
}


- (void) initDataArrays {
    polledDataList = [[NSMutableArray alloc] init];
    alertList = [[NSMutableArray alloc] init];
    serverList = [[NSMutableArray alloc] init];
    applicationList = [[NSMutableArray alloc] init];
    alertHistoryList = [[NSMutableArray alloc] init];
    serverIdHostNameMap = [[NSMutableDictionary alloc] init];
}


- (void) trySignIn:(id)theJobToDo {
    
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSHTTPURLResponse *response;
	NSError *error = nil;
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	NSURL *myWebserverURL = [NSURL URLWithString:self.loginUrl];
    [AppComm setAuthStringWith:self.loginController.usernameField.text andPassword:self.loginController.passwordField.text];
    [self initDataArrays];
    firstAlertQuery = YES;
    firstApplicationQuery = YES;
    firstServerQuery = YES;
    firstPolledDataQuery = YES;
    firstAlertHistoryQuery = YES;
    [self loadServerList];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0, 0, 40.0, 40.0);
    activityIndicator.hidden = NO;
	
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
    [activityIndicator release];
	[window release];
	[tabcontroller release];
	[loginController release];
	
	[notificationController release];
	
	[availableCookies release];
	[serverListUrl release];
	[loginUrl release];
	[alertListUrl release];
	[urlBase release];
	[usernames release];
	[UUID release];
    
    [alertHistoryList release];
    [serverList release];
    [applicationList release];
    [alertList release];
    [polledDataList release];
    
    [navigationController release];
	[homeViewController release];
    
    [serverIdHostNameMap release];
	[super dealloc];
}


@end

