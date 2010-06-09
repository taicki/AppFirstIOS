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


- (void)viewDidLoad {
    [super viewDidLoad];
		
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc]
		  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
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
	
	AFTitleView* titleView = [[AFTitleView alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
	self.navigationItem.titleView = titleView;
	
	
	[loadingView release];
	
	if (DEBUGGING) {
		self.queryUrl = DEV_SERVER_IP;
	} else {
		self.queryUrl = PROD_SERVER_IP;
	}
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@", self.queryUrl, ALERT_LIST_API_STRING];
	
	[titleView release];
	self.needRefresh = NO;
}


- (void) finishLoading:(NSString*)theJobToDo {
	

	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];
	self.tableView.userInteractionEnabled = YES;
	
	AFTitleView* titleView = (AFTitleView*) self.navigationItem.titleView;
	titleView.timeLabel.text = [NSString stringWithFormat:@"%@", theJobToDo];
	
	titleView.titleLabel.text = @"Alerts";
	
	[self.tableView reloadData];
}

- (void) refresh: (id)theJobToDo {
	
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
	[self.activityIndicator setNeedsDisplay];
	self.tableView.userInteractionEnabled = NO;
	
	[self performSelectorInBackground:@selector(tryUpdating:)
						   withObject:nil];
}

- (void) tryUpdating: (id)theJobToDo {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[self getAlertListData:YES];
	
	[pool release];
	
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
	
	
	NSDate *today = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
	NSString *currentTime = [dateFormatter stringFromDate:today];
	//self.navigationItem.title = [NSString stringWithFormat:@"Alerting (Updated at %@)", currentTime];
	//NSLog(@"%@", [NSString stringWithFormat:@"Alerting (Updated at %@)", currentTime]);
	
	[dateFormatter release];
	
	
	if (usingRefresh) {
		[self performSelectorOnMainThread:@selector(finishLoading:)
							   withObject:[NSString stringWithFormat:@"Updated at %@", currentTime]
							waitUntilDone:NO
		 ];
	}
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	
	if (self.needRefresh) {
		[self refresh:nil];
		self.needRefresh = NO;
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
		if ([[[self.allData objectForKey:[self.alerts objectAtIndex:cnt]]  objectForKey:ALERT_TRIGGER_TYPE_NAME] isEqualToString:@"Nagios"]) {
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
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
	

		cell.detailTextLabel.text = [NSString stringWithFormat:@"Last triggered: %@", 
									 [format stringFromDate:triggerTime]];
		
		[format release];
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

	
	
	if (!self.editing) {
		AlertDetailViewController *detailViewController = [[AlertDetailViewController alloc] initWithNibName:@"AlertDetailViewController" bundle:nil];
		
		if (self.view.bounds.size.width < 400) {
			detailViewController.bounds = CGSizeMake(320, 480);
		} else {
			detailViewController.bounds = CGSizeMake(768, 1024);
		}
		
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
		
		
		
		if (self.view.bounds.size.width < 400) {
			detailViewController.bounds = CGSizeMake(320, 480);
		} else {
			detailViewController.bounds = CGSizeMake(768, 1024);
		}
		
		detailViewController.alertId = [[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"];
		detailViewController.detailData = [self.allData objectForKey:[[dictionary objectAtIndex:indexPath.row] objectForKey:@"id"]];;
		detailViewController.availableCookies = self.availableCookies;
		
		
		[self presentModalViewController:editController animated:YES];
		
		//[self.navigationController pushViewController:detailViewController animated:YES];
		
		//detailViewController.alertName.text =[NSString stringWithFormat:@"Alert Name: %@", 
		//									  [[dictionary objectAtIndex:indexPath.row] objectForKey:ALERT_NAME]];
		[detailViewController release];
		[editController release];
		
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

