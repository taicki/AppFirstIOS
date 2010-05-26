//
//  AFDashboard.m
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFDashboard.h"
#import "ServerStatusViewController.h"
#import "config.h"

@implementation AFDashboard


@synthesize servers;
@synthesize allData, availableCookies, queryUrl, activityIndicator;

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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getServerListData:)];
	refreshButton.style = UIBarButtonItemStyleBordered;
	
	
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
	
	
	CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
	self.activityIndicator = [[UIActivityIndicatorView alloc]
							  initWithFrame:frame];
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
	
	
	
	if (DEBUGGING) {
		self.queryUrl = DEV_SERVER_IP;
	} else {
		self.queryUrl = PROD_SERVER_IP;
	}
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@", self.queryUrl, SERVER_LIST_API_STRING];
	
	
}

- (void) finishLoading:(id)theJobToDo {
	
	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];
	
}

- (void) refresh: (id)theJobToDo {
	
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
	[self.activityIndicator setNeedsDisplay];
	
	[self performSelectorInBackground:@selector(tryUpdating:)
						   withObject:nil];
}

- (void) tryUpdating: (id)theJobToDo {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[self getServerListData:YES];
	[self.tableView reloadData];
	[pool release];
}



- (void) getServerListData: (BOOL)usingRefresh{
	NSHTTPURLResponse *response;
	NSError *error;
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.availableCookies];
	
	
	NSMutableURLRequest *serverListRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	// we are just recycling the original request
	[serverListRequest setHTTPMethod:@"GET"];
	[serverListRequest setAllHTTPHeaderFields:headers];
	[serverListRequest setHTTPBody:nil];
	
	serverListRequest.URL = [NSURL URLWithString:self.queryUrl];
	
	
	NSData * data = [NSURLConnection sendSynchronousRequest:serverListRequest returningResponse:&response error:&error];
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
		return;
	}
	
	NSString *jsonString = [[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding] autorelease];
	NSLog(@"The server saw:\n%@", jsonString);
	
	NSDictionary *dictionary = [jsonString JSONValue];
	
	
	self.servers = dictionary.allKeys;
	self.allData = dictionary;
	
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	NSString *currentTime = [dateFormatter stringFromDate:today];
	self.navigationItem.title = [NSString stringWithFormat:@"Dashboard (Updated at %@)", currentTime];
	
	[dateFormatter release];
	
	
	if (usingRefresh) {
		[self performSelectorOnMainThread:@selector(finishLoading:)
							   withObject:nil
							waitUntilDone:NO
		 ];
	}
	
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithObjects: @"Firecracker", @"Lemon Drop", 
	//							@"Mojito", nil] ;
	//self.servers = tmpArray;
	//[tmpArray release];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
    return [self.servers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSObject* tmpDetailData = [self.allData objectForKey:[servers objectAtIndex:indexPath.row]];
	
	if ([tmpDetailData isKindOfClass:[NSDictionary class]] == YES) {
		cell.textLabel.text = [self.servers objectAtIndex:indexPath.row];
	} else {
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [self.servers objectAtIndex:indexPath.row], @"(stopped)"];
	}
	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
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
	
	ServerStatusViewController *detailViewController = [[ServerStatusViewController alloc] initWithNibName:@"ServerStatusViewController" bundle:nil];
	NSObject* tmpDetailData = [self.allData objectForKey:[servers objectAtIndex:indexPath.row]];
	

	if ([tmpDetailData isKindOfClass:[NSDictionary class]] == YES) {
		
		detailViewController.detailData = [self.allData objectForKey:[servers objectAtIndex:indexPath.row]];
		
		NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:[[[tmpDetailData objectForKey:DATA_NAME] objectForKey:RESOURCE_TIME_NAME] doubleValue] / 1000];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		
		NSString *timeText = [NSString stringWithFormat:@"%@: %@", @"Updated at", [format stringFromDate:updateDate]];
		//NSLog(@"%@", timeText);
		detailViewController.timeLabelText = timeText;
		[format release];
	} else {
		
		double stopTime = [[tmpDetailData stringByReplacingOccurrencesOfString:@"stopped:" withString:@""] doubleValue];
		NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:stopTime];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		
		NSString *timeText = [NSString stringWithFormat:@"%@: %@", @"Stopped at", [format stringFromDate:updateDate]];
		//NSLog(@"%@", timeText);
		
		detailViewController.timeLabelText = timeText;
		[format release];
	}
	
	// temp solutions, should be better ways. 
	
	if (self.view.bounds.size.width < 400) {
		detailViewController.bounds = CGSizeMake(320, 480);
	} else {
		detailViewController.bounds = CGSizeMake(768, 1024);
	}
	
	detailViewController.name = [servers objectAtIndex:indexPath.row];
	

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
	[servers release];
	[allData release];
	[availableCookies release];
	[queryUrl release];
	[activityIndicator release];
    [super dealloc];
}


@end

