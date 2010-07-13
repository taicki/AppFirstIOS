//
//  AFDashboard.m
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFDashboard.h"
#import "AFTitleView.h"
#import "ServerStatusViewController.h"
#import "ServerDetailViewPad.h"
#import "AFPageViewController.h"
#import "config.h"
#import "AppHelper.h"

@implementation AFDashboard


@synthesize servers;
@synthesize allData, availableCookies, queryUrl, activityIndicator;
@synthesize collectorRunningServers, collectorStoppingServers;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


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
	AFTitleView* titleView;
	if ([AppHelper isIPad]) {
		titleView = [[AFTitleView alloc] initWithFrame:CGRectMake(0, 0, IPAD_NAVIGATION_TITLE_WIDTH, IPAD_NAVIGATION_TITLE_HEIGHT)];
	} else {
		titleView = [[AFTitleView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_NAVIGATION_TITLE_WIDTH, IPHONE_NAVIGATION_TITLE_HEIGHT)];
	}
	self.navigationItem.titleView = titleView;
	[titleView release];
}

- (void) _setQueryUrl {
	if (DEBUGGING) {
		self.queryUrl = DEV_SERVER_IP;
	} else {
		self.queryUrl = PROD_SERVER_IP;
	}
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@", self.queryUrl, SERVER_LIST_API_STRING];
	
}

- (void) finishLoading:(NSString*)theJobToDo {
	
	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];
	
	
	/*
	AFTitleView* titleView = (AFTitleView*)self.navigationItem.titleView;
	titleView.timeLabel.text = [NSString stringWithFormat:@"Updated at %@", theJobToDo];
	titleView.titleLabel.text = @"Servers";
	*/
	self.navigationItem.title = [NSString stringWithFormat:@"Servers (%@)", theJobToDo];
	
	
	NSMutableArray* runningServers = [[NSMutableArray alloc] init];
	NSMutableArray* stoppingServers = [[NSMutableArray alloc] init];
	
	if (self.collectorRunningServers == nil) {
		self.collectorRunningServers = runningServers;
	} else {
		[self setCollectorRunningServers:runningServers];
	}
	
	if (self.collectorStoppingServers == nil) {
		self.collectorStoppingServers = stoppingServers; 
	} else {
		[self setCollectorStoppingServers:stoppingServers];
	}
	
	[runningServers release];
	[stoppingServers release];
	
	NSArray* runningObjects = [[self.allData objectForKey:@"data"] objectForKey:@"running"];
	NSArray* stoppingObjects = [[self.allData objectForKey:@"data"] objectForKey:@"stopped"];
	NSArray* runningKeys = [[self.allData objectForKey:@"columns"] objectForKey:@"running"];
	NSArray* stoppedKeys = [[self.allData objectForKey:@"columns"] objectForKey:@"stopped"];
	
	
	for (int i = 0; i < [runningObjects count]; i++) {
		NSMutableDictionary* serverObject = [[[NSMutableDictionary alloc] init] autorelease];
		for (int j= 0; j < [runningKeys count]; j++) {
			[serverObject setValue: [[runningObjects objectAtIndex:i] objectAtIndex:j] forKey:[runningKeys objectAtIndex: j]];
		}
		[self.collectorRunningServers addObject:serverObject];
	}
	
	for (int i = 0; i < [stoppingObjects count]; i++) {
		NSMutableDictionary* serverObject = [[[NSMutableDictionary alloc] init] autorelease];
		
		for (int j=0; j < [stoppedKeys count]; j++) {
			[serverObject setValue: [[stoppingObjects objectAtIndex:i] objectAtIndex:j] forKey: [stoppedKeys objectAtIndex:j]];
		}
		
		[self.collectorStoppingServers addObject:serverObject];
	}
	
	
	
	
	NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] 
									initWithKey: @"Server" ascending: YES selector: @selector(caseInsensitiveCompare
																						  : ) ] ;
    [collectorRunningServers sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
	[collectorStoppingServers sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
    [nameSorter release] ;
	
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
	
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	if (DEBUGGING)
		NSLog(@"%@", jsonString);
	[responseData release];
	
	
	NSDictionary *dictionary = (NSDictionary*)[jsonString JSONValue];
	
	//self.servers = dictionary.allKeys;
	self.allData = dictionary;

	[jsonString release];
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
}
*/

-(void) asyncGetServerListData {
	self.navigationItem.title = @"Updating...";
	
	
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.availableCookies];
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
	//[self asyncGetServerListData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
		
	
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
	if ([AppHelper isIPad] == NO)
		return interfaceOrientation == UIDeviceOrientationPortrait;
	
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return [self.collectorRunningServers count];
	}
	else if (section == 1) {
		return [self.collectorStoppingServers count];
	}
	
	return 0;
}

//RootViewController.m
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Collector Running Servers";
	else
		return @"Collector Stopped Servers";
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSArray* dictionary;
	if (indexPath.section == 0) {
		dictionary = self.collectorRunningServers;
	} else {
		dictionary = self.collectorStoppingServers;
	}
	
	NSString* serverName = [[dictionary objectAtIndex:indexPath.row] objectForKey: @"pk"];

	cell.textLabel.text = [[dictionary objectAtIndex:indexPath.row] objectForKey:SERVER_KEY_NAME];
	
	if (indexPath.section == 1) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		@try{	
			double stopTime = [[[dictionary	objectAtIndex:indexPath.row] objectForKey:@"Down Since"] doubleValue] / 1000;
			NSString *timeText = [NSString stringWithFormat:@"%@: %@", @"Stopped at", 
							  [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:stopTime]]];
			
			cell.detailTextLabel.text = timeText;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		@catch (NSException* exception) {
			NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
			cell.detailTextLabel.text = @"N/A";
		}
	} else if (indexPath.section == 0) {
		// only able to select on running collectors
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		cell.textLabel.text = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"Server"];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"CPU: %@%@  Memory: %@%@ Disk: %@%@",
									 [[dictionary objectAtIndex:indexPath.row] objectForKey:@"CPU"], @"%", 
									 [[dictionary objectAtIndex:indexPath.row] objectForKey:@"Memory"], @"%",
									 [[dictionary objectAtIndex:indexPath.row] objectForKey:@"Disk"], @"%"];
	}
	
	
	UIImage* theImage;
	NSString* path;
	NSString* osType = [[dictionary objectAtIndex:indexPath.row] objectForKey:OS_TYPE_NAME];
	
	if ([osType isEqualToString:@"Linux"]) {
		path = [[NSBundle mainBundle] pathForResource:@"linux-icon" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	} else {
		path = [[NSBundle mainBundle] pathForResource:@"windows-icon" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	}
	
	cell.imageView.image = theImage;
	
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
	
	NSArray* dictionary;
	
	
	if (indexPath.section == 0) {
		dictionary = self.collectorRunningServers;
	} else {
		dictionary = self.collectorStoppingServers;
	}
	
	if ([AppHelper isIPad] == NO) {
		if (indexPath.section == 0) {
			AFPageViewController* detailViewController = [[AFPageViewController alloc] initWithNibName:@"AFPageViewController" bundle:nil];
			NSString* serverName = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"Server"];
			detailViewController.serverName = serverName;
			detailViewController.serverPK = [[dictionary objectAtIndex:indexPath.row] objectForKey:DB_KEY_NAME];
			detailViewController.osType = [[dictionary objectAtIndex:indexPath.row] objectForKey:OS_TYPE_NAME];
			[self.navigationController pushViewController:detailViewController animated:YES];
			[detailViewController release];
		}
		else {
			return;
		}

			
	} else {
		if (indexPath.section == 0) {
			ServerDetailViewPad* detailViewController = [[ServerDetailViewPad alloc] initWithNibName:@"ServerDetailViewPad" bundle:nil];
			NSString* serverName = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"Server"];
			detailViewController.serverName = serverName;
			detailViewController.serverPK = [[dictionary objectAtIndex:indexPath.row] objectForKey:DB_KEY_NAME];
			detailViewController.osType = [[dictionary objectAtIndex:indexPath.row] objectForKey:OS_TYPE_NAME];
			[self.navigationController pushViewController:detailViewController animated:YES];
			[detailViewController release];
		} else {
			return;
		}
	}
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
	[servers release];
	[allData release];
	[availableCookies release];
	[queryUrl release];
	[activityIndicator release];
	
	[collectorRunningServers release];
	[collectorStoppingServers release];
	
    [super dealloc];
}


@end

