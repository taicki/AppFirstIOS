//
//  AFAlertHistoryViewController.m
//  AppFirst
//
//  Created by appfirst on 7/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFAlertHistoryViewController.h"
#import "AFWebViewController.h"
#import "AppHelper.h"
#import "AppDelegate_Shared.h"
#import "config.h"


@implementation AFAlertHistoryViewController

@synthesize responseData, notifications, activityIndicator, queryUrl, allData;


#pragma mark -
#pragma mark View lifecycle

- (void) _createRefreshButton {
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
									  target:self 
									  action:@selector(asyncGetServerListData)];
	refreshButton.style = UIBarButtonItemStyleBordered;
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
}

- (void) _createRefreshIndicator {
	
	CGRect frame;
	
	if ([AppHelper isIPad]) {
		frame = CGRectMake(0.0, 0.0, IPAD_LOADER_SIZE, IPAD_LOADER_SIZE);
	} else {
		frame = CGRectMake(0.0, 0.0, IPHONE_LOADER_SIZE, IPHONE_LOADER_SIZE);
	}
	
	
	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]
										  initWithFrame:frame];
	
	self.activityIndicator = indicator;
	[indicator release];
	
	[self.activityIndicator sizeToFit];
	self.activityIndicator.autoresizingMask =
    (UIViewAutoresizingFlexibleLeftMargin |
	 UIViewAutoresizingFlexibleRightMargin |
	 UIViewAutoresizingFlexibleTopMargin |
	 UIViewAutoresizingFlexibleBottomMargin); 
	
	UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] 
									initWithCustomView:self.activityIndicator];
	loadingView.target = self;
	self.navigationItem.leftBarButtonItem = loadingView;
	
	[loadingView release];
}

- (void) _createNavigatorTitle {
	
	return;
}

- (void) _setQueryUrl {
	if (DEBUGGING) {
		self.queryUrl = DEV_SERVER_IP;
	} else {
		self.queryUrl = PROD_SERVER_IP;
	}
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@", self.queryUrl, NOTIFICATION_API_STRING];
	
}

- (void) finishLoading:(NSString*)theJobToDo {
	
	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Notifications (%@)", theJobToDo];
	
	
	
	
	NSMutableArray* newNotifications = [[NSMutableArray alloc] init];
	self.notifications = newNotifications;
	[newNotifications release];
	
	NSArray* objects = [self.allData objectForKey:LIST_QUERY_DATA_NAME];
	NSArray* keys = [self.allData objectForKey:LIST_QUERY_COLUMN_NAME];
	
	
	for (int i = 0; i < [objects count]; i++) {
		NSMutableDictionary* newObject = [[[NSMutableDictionary alloc] init] autorelease];
		for (int j= 0; j < [keys count]; j++) {
			[newObject setValue: [[objects objectAtIndex:i] objectAtIndex:j] forKey:[keys objectAtIndex: j]];
		}
		[self.notifications addObject:newObject];
	}
		
	
	//NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] 
	//								initWithKey: @"Alert" ascending: YES selector: @selector(caseInsensitiveCompare
	//																						  : ) ] ;
    //[self.notifications sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
	//[nameSorter release] ;
	
	[self.tableView reloadData];
	
	self.tableView.userInteractionEnabled = YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Couldn't refresh server list. " 
														message: [error localizedDescription] 
													   delegate: self 
											  cancelButtonTitle: @"Ok" 
											  otherButtonTitles: nil];
	[errorView show];
	[errorView release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[connection release];
	
	NSString *jsonString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	[responseData release];
	
	
	NSDictionary *dictionary = (NSDictionary*)[jsonString JSONValue];
	
	self.allData = dictionary;
	
	
	if ([AppHelper isIPad]) 
		[self finishLoading:[AppHelper formatDateString:[NSDate date]]];
	else {
		[self finishLoading:[AppHelper formatShortDateString:[NSDate date]]];
	}
}

/*
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}*/


-(void) asyncGetServerListData {
	self.navigationItem.title = @"Loading...";
	AppDelegate_Shared *application = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:application.availableCookies];
	responseData = [[NSMutableData data] retain];
	
	NSMutableURLRequest *serverListRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	
	[serverListRequest setHTTPMethod:@"GET"];
	[serverListRequest setAllHTTPHeaderFields:headers];
	[serverListRequest setHTTPBody:nil];
	[serverListRequest setTimeoutInterval:20];
	
	serverListRequest.URL = [NSURL URLWithString:self.queryUrl];
	[[NSURLConnection alloc] initWithRequest:serverListRequest delegate:self];
	
	
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
	[self.activityIndicator setNeedsDisplay];
	self.tableView.userInteractionEnabled = NO;
	
}



- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self _createRefreshButton];
	[self _createRefreshIndicator];
	[self _createNavigatorTitle];
	[self _setQueryUrl];
	[self asyncGetServerListData];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	[self resetBadgeValue];

}


- (void) resetBadgeValue {
	NSHTTPURLResponse *response;
	NSError *error = nil;
	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:appDelegate.availableCookies];
	NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	
	NSString *url;
	
	if (DEBUGGING == YES) {
		url = [NSString stringWithFormat:@"%@%@", DEV_SERVER_IP, BADGE_SET_API_STRING];
	} else {
		url = [NSString stringWithFormat:@"%@%@", PROD_SERVER_IP, BADGE_SET_API_STRING];
	}
	
	
	postRequest.URL = [NSURL URLWithString:url];
	
	NSString *postData = [NSString stringWithFormat:@"uid=%@&badge=%d", appDelegate.UUID, 0];
	
	if (DEBUGGING) {
		NSLog(@"%@", postData);
	}
	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	
	[postRequest setValue:length forHTTPHeaderField:@"Content-Length"];
	[postRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
	[postRequest setHTTPMethod:@"POST"];
	[postRequest setAllHTTPHeaderFields:headers];
	
	[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
	
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
	}
	
	UINavigationController* navigationController = [appDelegate.tabcontroller.viewControllers objectAtIndex:2];
	navigationController.tabBarItem.badgeValue = nil;
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	[NSURLConnection release];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.notifications count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	NSDate *triggerTime = [NSDate dateWithTimeIntervalSince1970:[[[self.notifications objectAtIndex:indexPath.row] objectForKey: @"Time"] doubleValue] /1000];
	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@", 
								 [[self.notifications objectAtIndex:indexPath.row] objectForKey: @"Trigger"],
								 [AppHelper formatDateString:triggerTime]];
	
	cell.textLabel.text = [NSString stringWithFormat:@"'%@' on %@", [[self.notifications objectAtIndex:indexPath.row] objectForKey: @"Alert"], 
						   [[self.notifications objectAtIndex:indexPath.row] objectForKey: @"Target"]];
    // Configure the cell...
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	if ([AppHelper isIPad] == NO) {
		cell.textLabel.font = [UIFont boldSystemFontOfSize:IPHONE_TABLE_TITLESIZE];
	}
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	AFWebViewController *detailViewController = [[AFWebViewController alloc] initWithNibName:@"AFWebViewController" bundle:nil];
	
	NSString* aUrl;
	if (DEBUGGING) {
		aUrl = DEV_SERVER_IP;
	} else {
		aUrl = PROD_SERVER_IP;
	}
	
	
	aUrl = [NSString stringWithFormat:@"%@%@", aUrl, [[self.notifications objectAtIndex:indexPath.row] objectForKey:@"url"]];
	
	detailViewController.queryUrl = aUrl;
	// ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

