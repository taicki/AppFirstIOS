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
#import "config.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// right button: refresh
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
	refreshButton.style = UIBarButtonItemStyleBordered;
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
	
	// left button: refreshing indicator
	CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
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
	
	AFTitleView* titleView = [[AFTitleView alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
	self.navigationItem.titleView = titleView;
	
	if (DEBUGGING) {
		self.queryUrl = DEV_SERVER_IP;
	} else {
		self.queryUrl = PROD_SERVER_IP;
	}
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@", self.queryUrl, SERVER_LIST_API_STRING];
	[titleView release];
	
}

- (void) finishLoading:(NSString*)theJobToDo {
	
	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];
	self.tableView.userInteractionEnabled = YES;
	
	AFTitleView* titleView = (AFTitleView*)self.navigationItem.titleView;
	titleView.timeLabel.text = [NSString stringWithFormat:@"Updated at %@", theJobToDo];
	
	titleView.titleLabel.text = @"Servers";
	[self.tableView reloadData];
	
}

- (void) refresh: (id)theJobToDo {
	
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
	[self.activityIndicator setNeedsDisplay];
	self.tableView.userInteractionEnabled = NO;
	//[NSThread detachNewThreadSelector:@selector(tryUpdating) toTarget:self withObject:nil];  
	
	[self performSelectorInBackground:@selector(tryUpdating:)
						   withObject:nil];
}

- (void) tryUpdating: (id)theJobToDo {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[self getServerListData:YES];
	
	[pool drain];
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
	[serverListRequest setTimeoutInterval:20];
	
	serverListRequest.URL = [NSURL URLWithString:self.queryUrl];
	
	
	NSData * data = [NSURLConnection sendSynchronousRequest:serverListRequest returningResponse:&response error:&error];
	if (error) {
		UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Could not refresh. " message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[networkError show];
		[networkError release];
		return;
	}
	
	NSString *jsonString = [[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding] autorelease];
	
	if (DEBUGGING)
		NSLog(@"The server saw:\n%@", jsonString);
	
	NSDictionary *dictionary = (NSDictionary*)[jsonString JSONValue];
	
	
	self.servers = dictionary.allKeys;
	self.allData = dictionary;
	
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	NSString *currentTime = [dateFormatter stringFromDate:today];
	[dateFormatter release];
	
	
	if (usingRefresh) {
		[self performSelectorOnMainThread:@selector(finishLoading:)
							   withObject:[NSString stringWithFormat:@"%@", currentTime]
							waitUntilDone:NO
		 ];
	}
	
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
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
	
	
	for(int cnt = 0; cnt < [self.servers count]; cnt ++) {
		
		NSObject* tmpDetailData = [self.allData objectForKey:[self.servers objectAtIndex:cnt]];
		
		if ([tmpDetailData isKindOfClass:[NSDictionary class]] == YES) {
			[self.collectorRunningServers addObject:[NSDictionary dictionaryWithObjectsAndKeys: [self.servers objectAtIndex:cnt], @"id", nil]];
		} else {
			[self.collectorStoppingServers addObject:[NSDictionary dictionaryWithObjectsAndKeys: [self.servers objectAtIndex:cnt], @"id", nil]];
		}
	}
	
	NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] 
									initWithKey: @"id" ascending: YES selector: @selector(caseInsensitiveCompare
																							   : ) ] ;
    [collectorRunningServers sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
	[collectorStoppingServers sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
    [nameSorter release] ;
	
	
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
	
	/*
	NSObject* tmpDetailData = [self.allData objectForKey:[servers objectAtIndex:indexPath.row]];
	
	if ([tmpDetailData isKindOfClass:[NSDictionary class]] == YES) {
		cell.textLabel.text = [self.servers objectAtIndex:indexPath.row];
	} else {
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [self.servers objectAtIndex:indexPath.row], @"(stopped)"];
	}*/
	
	NSArray* dictionary;
	if (indexPath.section == 0) {
		dictionary = self.collectorRunningServers;
	} else {
		dictionary = self.collectorStoppingServers;
	}
	
	NSString* serverName = [[dictionary objectAtIndex:indexPath.row] objectForKey: @"id"];
	
	
	//NSDictionary* detailData = [self.allData objectForKey:[dictionary objectAtIndex:indexPath.row]];
	cell.textLabel.text = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"];//[detailData objectForKey:ALERT_NAME];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	if (indexPath.section == 1) {
		double stopTime = [[[self.allData objectForKey:serverName] stringByReplacingOccurrencesOfString:@"stopped:" withString:@""] doubleValue];
		NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:stopTime];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		NSString *timeText = [NSString stringWithFormat:@"%@: %@", @"Stopped at", [format stringFromDate:updateDate]];
		[format release];
		cell.detailTextLabel.text = timeText;
	} else if (indexPath.section == 0) {
		NSDictionary* detailData = [self.allData objectForKey:serverName];
		
		NSArray *cpuValues = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		NSDecimalNumber *cpuValue = [cpuValues objectAtIndex:0];
		
		NSArray *memoryValues = [[[detailData objectForKey:DATA_NAME] 
								  objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		NSDecimalNumber *memoryTotal = [[[detailData objectForKey:DATA_NAME] 
										 objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		NSDecimalNumber *memoryValue = [memoryValues objectAtIndex:0];
		
		cell.detailTextLabel.text = [NSString stringWithFormat:@"CPU: %@  Memory: %@", 
		
		[NSString stringWithFormat:@"%.1f%@", [cpuValue doubleValue], @"%"], 
		[NSString stringWithFormat:@"%.1f%@", [memoryValue  doubleValue] / [memoryTotal doubleValue] * 100, @"%"]];
		
	}
    
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
	
	NSArray* dictionary;
	
	
	if (indexPath.section == 0) {
		dictionary = self.collectorRunningServers;
	} else {
		dictionary = self.collectorStoppingServers;
	}
	
	NSString* serverName = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"];
	ServerStatusViewController *detailViewController = [[ServerStatusViewController alloc] initWithNibName:@"ServerStatusViewController" bundle:nil];


	if (indexPath.section == 0) {
		NSDictionary* tmpDetailData = [self.allData objectForKey:serverName];
		
		detailViewController.detailData = tmpDetailData;
		
		NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:[[[tmpDetailData objectForKey:DATA_NAME] objectForKey:RESOURCE_TIME_NAME] doubleValue] / 1000];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		
		NSString *timeText = [NSString stringWithFormat:@"%@: %@", @"Updated at", [format stringFromDate:updateDate]];
		detailViewController.timeLabelText = timeText;
		[format release];
	} else {
		
		NSString* tmpDetailData = [self.allData objectForKey:serverName];
		
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
	
	detailViewController.name = serverName;
	

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
	
	[collectorRunningServers release];
	[collectorStoppingServers release];
	
    [super dealloc];
}


@end

