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

#import "AFSortableTableViewController.h"
#import "AFTableViewController.h"
#import "AFWidgetBaseView.h"
#import "AppHelper.h"
#import "AppDelegate_Shared.h"
#import "config.h"
//#import "AFMetricsPicker.h"

@implementation AFSortableTableViewController
@synthesize tableController;
@synthesize metricsController, popoverController;
@synthesize sortButton, metricsViewBounder, titleLabel;
@synthesize queryUrl, serverPK, responseData, detailData;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id) initWithPk:(NSString*) pk {
	if ((self = [super init])) {
        // Custom initialization
		self.serverPK = pk;
    }
	
	return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	AFWidgetBaseView* aView = [[AFWidgetBaseView alloc] initWithFrame:CGRectZero];
	aView.clipsToBounds = YES;
	self.view = aView;
	[aView release];
}


- (void) asyncGetServerData
{
	titleLabel.text = @"Running Processes (loading...)";
	self.view.userInteractionEnabled = NO;

	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
	
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:appDelegate.availableCookies];
	responseData = [[NSMutableData data] retain];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setAllHTTPHeaderFields:headers];
	[request setTimeoutInterval:20];
	request.URL = [NSURL URLWithString:self.queryUrl];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void) _setQueryUrl {
	if (DEBUGGING) {
		self.queryUrl = DEV_SERVER_IP;
	} else {
		self.queryUrl = PROD_SERVER_IP;
	}
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@?pk=%@", self.queryUrl, SERVER_PROCESS_LIST_API_STRING, self.serverPK];
	if (DEBUGGING) {
		NSLog(@"%@", self.queryUrl);
	}
}

- (void) finishLoading:(NSString*)theJobToDo {
	NSArray* objects = [self.detailData objectForKey:LIST_QUERY_DATA_NAME];
	NSMutableArray* keys = [self.detailData objectForKey:LIST_QUERY_COLUMN_NAME];
	
	self.tableController.processNames = [[[NSMutableArray alloc] init] autorelease];
	
	for (int i = 0; i < [objects count]; i++) {
		NSMutableDictionary* dictObject = [[[NSMutableDictionary alloc] init] autorelease];
		for (int j= 0; j < [keys count]; j++) {
			[dictObject setValue: [[objects objectAtIndex:i] objectAtIndex:j] forKey:[[keys objectAtIndex: j] objectAtIndex:0]];
		}
		[self.tableController.processNames addObject:dictObject];
	}

	titleLabel.text = [NSString stringWithFormat:@"Running processes (total %d)", [self.tableController.processNames count]];
	[keys removeObjectAtIndex:2];

	[self.tableController setSortKey:@"CPU"];
	[self.tableController.tableView reloadData];
	

	
	
	self.metricsController.metrics = [[[NSMutableArray alloc] init] autorelease];
	[self.metricsController setMetrics:keys];
	[self.metricsController.tableView reloadData];
	
	self.view.userInteractionEnabled = YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Can't processs list. " 
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
	
	self.detailData = dictionary;
	
	[jsonString release];
	
	[self finishLoading:[AppHelper formatDateString:[NSDate date]]];
}

/*
///* comment these two methods for release
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

//*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	double titleSectionHeight = 20;
	double sortButtonWidth = 100;
	
	UIView* titleSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleSectionHeight)];
	[titleSection setBackgroundColor:[UIColor clearColor]];
	
	UILabel* sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 2, 250, titleSectionHeight)];
	[sectionLabel setBackgroundColor:[UIColor clearColor]];
	[titleSection addSubview:sectionLabel];
	titleLabel = sectionLabel;
	[sectionLabel release];

	[self.view addSubview:titleSection];
	[titleSection release];
	
	
	self.metricsController = [[AFMetricsPicker alloc]  initWithNibName:@"AFMetricsPicker" bundle:nil];
	self.metricsController.parentViewController = self;
	
	UIView* viewBounder = [[UIView alloc] initWithFrame:CGRectMake(250, titleSectionHeight, 250, 300 - titleSectionHeight)];
	viewBounder.clipsToBounds = YES;
	self.metricsViewBounder = viewBounder;
	
	
	
	if ([AppHelper isIPad]) {
		
		self.sortButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] autorelease];
		self.sortButton.frame = CGRectMake(self.view.frame.size.width - sortButtonWidth, 0, 20, titleSectionHeight);
		[self.sortButton addTarget:self action:@selector(changeMetricsViewDisplay:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.sortButton];
		[self.view addSubview:viewBounder];
	} else {
		self.sortButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] autorelease];
		[self.sortButton addTarget:self action:@selector(changeMetricsViewDisplayIphone:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.sortButton];
		[self.metricsViewBounder addSubview:self.metricsController.view];
		[self.metricsViewBounder setBackgroundColor:[UIColor whiteColor]];
	}
	
	[viewBounder release];
	
	self.tableController = [[[AFTableViewController alloc] init] autorelease];
	[self.view addSubview:self.tableController.view];
	
	[self _setQueryUrl];
	[self asyncGetServerData];
}

- (IBAction) changeMetricsViewDisplayIphone: (id) sender {
	if (self.metricsViewBounder.superview == nil) {
		[self.view addSubview:self.metricsViewBounder];
	} else {
		[self.metricsViewBounder removeFromSuperview];
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
													   
    return YES;
}

- (IBAction) changeMetricsViewDisplay: (id) sender {
	//self.metricsViewBounder.hidden = !self.metricsViewBounder.hidden;
	
	UIPopoverController* aPopover = [[UIPopoverController alloc]
									 
									 initWithContentViewController:self.metricsController];
	aPopover.popoverContentSize = CGSizeMake(self.metricsViewBounder.frame.size.width, self.metricsViewBounder.frame.size.height - 40);
	
	self.popoverController = aPopover;
	[aPopover release];
	[self.popoverController presentPopoverFromRect:CGRectMake(240, 0, 1, 1) inView:self.metricsViewBounder permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
}

- (void) reorderTableByMetric: (NSString*) metric {
	if (DEBUGGING) {
		NSLog(@"%@", self.tableController.processNames);
	}
	self.tableController.sortKey = metric;
	NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] 
									initWithKey: metric ascending: NO];// selector: @selector(compare://caseInsensitiveCompare: ) ] ;
    [self.tableController.processNames sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
	
	[self.tableController.tableView reloadData];
	
	if ([AppHelper isIPad]) {
		self.metricsViewBounder.hidden = YES;
	} else {
		[self.metricsViewBounder removeFromSuperview];
	}
	[nameSorter release];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tableController release];
	[metricsController release];
	[sortButton release];
	[popoverController release];
	[metricsViewBounder release];
	[serverPK release];
	[queryUrl release];
	[detailData release];
	[titleLabel release];
    [super dealloc];
}


@end
