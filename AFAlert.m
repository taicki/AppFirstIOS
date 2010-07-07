//
//  AFAlert.m
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFAlert.h"
#import "AlertDetailViewController.h"
#import "AlertEditViewController.h"
#import "config.h"
#import "JSON/JSON.h"
#import "AFTitleView.h"
#import "AFAlertDetailTableViewController.h"
#import "AppHelper.h"

@implementation AFAlert


@synthesize alerts, allData, availableCookies;
@synthesize nagiosAlerts, otherAlerts, needRefresh;
@synthesize queryUrl;
@synthesize activityIndicator;

#pragma mark -
#pragma mark Initialization



/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self.tabBarItem.image = [UIImage imageNamed:@"Alerts.png"];
    return self;
}*/



#pragma mark -
#pragma mark View lifecycle

- (void) _createRefreshButton {
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
									  target:self 
									  action:@selector(asyncGetListData)];
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
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@", self.queryUrl, ALERT_LIST_API_STRING];
	
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
	[responseData release];
	
	
	NSDictionary *dictionary = (NSDictionary*)[jsonString JSONValue];
	
	self.alerts = dictionary.allKeys;
	self.allData = dictionary;
	
	if ([AppHelper isIPad]) 
		[self finishLoading:[AppHelper formatDateString:[NSDate date]]];
	else {
		[self finishLoading:[AppHelper formatShortDateString:[NSDate date]]];
	}

	
	NSMutableArray* tmpOtherAlerts = [[NSMutableArray alloc] init];
	NSMutableArray* tmpNagiosAlerts = [[NSMutableArray alloc] init];
	
	if (self.otherAlerts == nil) {
		self.otherAlerts = tmpOtherAlerts;
	} else {
		[self setOtherAlerts:tmpOtherAlerts];
	}
	
	if (self.nagiosAlerts == nil) {
		self.nagiosAlerts = tmpNagiosAlerts;
	} else {
		[self setNagiosAlerts:tmpNagiosAlerts];
	}
	
	[tmpOtherAlerts release];
	[tmpNagiosAlerts release];
	
	
	for(int cnt = 0; cnt < [self.alerts count]; cnt ++) {
		if ([[[self.allData objectForKey:[self.alerts objectAtIndex:cnt]]  objectForKey:ALERT_TYPE_NAME] isEqualToString:@"Polled Data"]) {
			[self.nagiosAlerts addObject:[NSDictionary dictionaryWithObjectsAndKeys: [self.alerts objectAtIndex:cnt], @"id", 
										  [[self.allData objectForKey:[self.alerts objectAtIndex:cnt]] objectForKey:ALERT_NAME], ALERT_NAME, nil]];
		}
		else {
			[self.otherAlerts addObject:[NSDictionary dictionaryWithObjectsAndKeys: [self.alerts objectAtIndex:cnt], @"id", 
										 [[self.allData objectForKey:[self.alerts objectAtIndex:cnt]] objectForKey:ALERT_NAME], ALERT_NAME, nil]];
		}
	}
	
	NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] 
									initWithKey: ALERT_NAME ascending: YES selector: @selector(caseInsensitiveCompare
																							   : ) ] ;
    [nagiosAlerts sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
	[otherAlerts sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
    [nameSorter release] ;

	[self.tableView reloadData];
	
}



-(void) asyncGetListData {
	
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.availableCookies];
	responseData = [[NSMutableData data] retain];
	
	[self.navigationItem setTitle:@"Updating..."];
	
	NSMutableURLRequest *serverListRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	[serverListRequest setHTTPMethod:@"GET"];
	[serverListRequest setAllHTTPHeaderFields:headers];
	[serverListRequest setHTTPBody:nil];
	[serverListRequest setTimeoutInterval:40];
	
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
	[self _setQueryUrl];
	
	//[self asyncGetListData];
	[self setNeedRefresh:NO];
}


- (void) finishLoading:(NSString*)theJobToDo {
	

	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];
	self.tableView.userInteractionEnabled = YES;
	
	//AFTitleView* titleView = (AFTitleView*) self.navigationItem.titleView;
	//titleView.timeLabel.text = [NSString stringWithFormat:@"%@", theJobToDo];
	//titleView.titleLabel.text = @"Alerts";
	
	self.navigationItem.title = [NSString stringWithFormat:@"Alerts (%@)", theJobToDo];
	
	[self.tableView reloadData];
}


- (void) getAlertListData: (BOOL)usingRefresh{
	NSHTTPURLResponse *response;
	NSError *error;
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.availableCookies];
	
	
	
	
	NSMutableURLRequest *alertListRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	// we are just recycling the original request
	[alertListRequest setHTTPMethod:@"GET"];
	[alertListRequest setAllHTTPHeaderFields:headers];
	[alertListRequest setHTTPBody:nil];
	[alertListRequest setTimeoutInterval:30];
	
	alertListRequest.URL = [NSURL URLWithString:self.queryUrl];
	

	
	NSData * data = [NSURLConnection sendSynchronousRequest:alertListRequest returningResponse:&response error:&error];
	if (error) {
		UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Could not refresh. " message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[networkError show];
		[networkError release];
		return;
	}
	
	NSString *jsonString = [[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding] autorelease];
	
	if (DEBUGGING)
		NSLog(@"The server saw:\n%@", jsonString);
	
	NSDictionary *dictionary = [jsonString JSONValue];
	
	self.alerts = dictionary.allKeys;
	self.allData = dictionary;
	
	
	
	
	
	if (usingRefresh) {
		[self performSelectorOnMainThread:@selector(finishLoading:)
							   withObject:[NSString stringWithFormat:@"Updated at %@", [AppHelper formatDateString:[NSDate date]]]
							waitUntilDone:NO
		 ];
	}
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (self.needRefresh) {
		[self asyncGetListData];
		[self setNeedRefresh:NO];
	}
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
	if (![AppHelper isIPad])
		return interfaceOrientation == UIDeviceOrientationPortrait;
	
	
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

//RootViewController.m
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"System Alerts";
	else
		return @"Nagios Alerts";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return [self.otherAlerts count];
	}
	else if (section == 1) {
		return [self.nagiosAlerts count];
	}
	
    return [self.alerts count];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSArray *dictionary;
	
	if (indexPath.section == 0) {
		dictionary = self.otherAlerts;
	} else {
		dictionary = self.nagiosAlerts;
	}
	
	
	
	//NSDictionary* detailData = [self.allData objectForKey:[dictionary objectAtIndex:indexPath.row]];
	cell.textLabel.text = [[dictionary objectAtIndex:indexPath.row] objectForKey:ALERT_NAME];//[detailData objectForKey:ALERT_NAME];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	NSString* alertId = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"];
	
	if ([[self.allData objectForKey:alertId] objectForKey:AlERT_LAST_TRIGGER_NAME] != nil) {
	
		NSDate *triggerTime = [NSDate dateWithTimeIntervalSince1970:[[[self.allData objectForKey:alertId] objectForKey:AlERT_LAST_TRIGGER_NAME] doubleValue]];
	
		cell.detailTextLabel.text = [NSString stringWithFormat:@"Last triggered: %@", 
									 [AppHelper formatDateString:triggerTime]];
		
	} else {
		cell.detailTextLabel.text = @"Last triggered: N/A";
	}
	
	
	NSString* enabled = [[self.allData objectForKey:alertId] objectForKey:ALERT_STATUS_NAME];
	
	
	NSString *path;
	UIImage* theImage;
	
	if ([enabled isEqualToString:@"True"]) {
		path = [[NSBundle mainBundle] pathForResource:@"checked_box" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	} else {
		path = [[NSBundle mainBundle] pathForResource:@"unchecked_box" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	}
	
	cell.imageView.image = theImage;
	
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



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
	
	NSArray* dictionary;
	
	
	if (indexPath.section == 0) {
		dictionary = self.otherAlerts;
	} else {
		dictionary = self.nagiosAlerts;
	}

	AFAlertDetailTableViewController *detailViewController = [[AFAlertDetailTableViewController alloc] initWithNibName:@"AFAlertDetailTableViewController" bundle:nil];
	detailViewController.alertName = [NSString stringWithFormat:@"%@", [[dictionary objectAtIndex:indexPath.row] objectForKey:ALERT_NAME]];
	detailViewController.detailData = [self.allData objectForKey:[[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"]];
	detailViewController.alertID = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"];
	//detailViewController.parentController = self;
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	
	
	[detailViewController release];
	
	/*
	if (!self.editing) {
		AlertDetailViewController *detailViewController = [[AlertDetailViewController alloc] initWithNibName:@"AlertDetailViewController" bundle:nil];
		detailViewController.bounds = [AppHelper getDeviceBound];
		
		
		detailViewController.alertId = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"];
		detailViewController.detailData = [self.allData objectForKey:[[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"]];;
		detailViewController.availableCookies = self.availableCookies;
		detailViewController.parentController = self;
		
		[self.navigationController pushViewController:detailViewController animated:YES];
		
		//detailViewController.alertName.text = [NSString stringWithFormat:@"Alert Name: %@", 
		//									   [[dictionary objectAtIndex:indexPath.row] objectForKey:ALERT_NAME]];
		
		[detailViewController release];
		
	} else {
		
		AlertEditViewController *detailViewController = [[AlertEditViewController alloc] initWithNibName:@"AlertEditViewController" bundle:nil];
		
		UINavigationController *editController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
		
		detailViewController.bounds = [AppHelper getDeviceBound];
		
		detailViewController.alertId = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"];
		detailViewController.detailData = [self.allData objectForKey:[[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"]];;
		detailViewController.availableCookies = self.availableCookies;
		
		
		[self presentModalViewController:editController animated:YES];
		
		//[self.navigationController pushViewController:detailViewController animated:YES];
		
		//detailViewController.alertName.text =[NSString stringWithFormat:@"Alert Name: %@", 
		//									  [[dictionary objectAtIndex:indexPath.row] objectForKey:ALERT_NAME]];
		[detailViewController release];
		[editController release];
		
	}*/
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
	[alerts release];
	[allData release];
	[availableCookies release];
	[nagiosAlerts release];
	[otherAlerts release];
	[activityIndicator release];
	[queryUrl release];
	
    [super dealloc];
}


@end

