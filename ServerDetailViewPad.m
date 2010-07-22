    //
//  ServerDetailViewPad.m
//  AppFirst
//
//  Created by appfirst on 6/18/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "ServerDetailViewPad.h"
#import "AFServerNameView.h"
#import "AppDelegate_Shared.h"
#import "AFMemoryDetailView.h"
#import "AFVerticalSeparator.h"
#import "JSON.h"
#import "AppHelper.h"
#import "config.h"


@implementation ServerDetailViewPad
@synthesize sortableTableView;
@synthesize pollDataController, diskViewController, alertViewController, indicatorController;
@synthesize serverName, queryUrl, serverPK, osType;
@synthesize detailData, responseData;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void) _createRefreshButton {
	UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
									  target:self 
									  action:@selector(_freshViewData)];
	//refreshButton.style = UIBarButtonItemStyleBordered;
	self.navigationItem.rightBarButtonItem = refreshButton;
	
	self.navigationItem.title = @"Updating...";
	[refreshButton release];
}

- (void) _freshViewData {
	[self asyncGetServerData];
	[self.pollDataController asyncGetServerData];
	[self.sortableTableView asyncGetServerData];
}


- (void) asyncGetServerData
{
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
	
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@?pk=%@", self.queryUrl, SERVER_DETAIL_API_STRING, self.serverPK];
	
}

- (void) finishLoading:(NSString*)theJobToDo {
	self.navigationItem.title = [NSString stringWithFormat:@"Updated at: %@", [AppHelper formatDateString:[NSDate date]]];
	
	
	
	double serverNameViewHeight = 50;
	double memoryViewHeight = 70;
	double cpuViewHeight = 70; // 160;
	double diskViewHeight = 300;
	
		
	double topPadding = IPAD_DETAIL_VIEW_MARGIN;
	
	AFServerNameView* serverNameView = [[AFServerNameView alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN, 
																						  topPadding, 
																						  IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, serverNameViewHeight)];
	serverNameView.serverName = self.serverName;
	serverNameView.osType = self.osType;
	[self.view addSubview:serverNameView];
	[serverNameView release];
	
	topPadding += (serverNameViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	
	
	AFCpuDetailView* cpuDetailView = [[AFCpuDetailView alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN, 
																					   topPadding, 
																					   IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, cpuViewHeight)];
	NSArray *cpuValues = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
	cpuDetailView.cpuDetail = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
	cpuDetailView.cpuValue = [[cpuValues objectAtIndex:0] doubleValue];
	[self.view addSubview:cpuDetailView];
	[cpuDetailView release];
	
	topPadding += (cpuViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	
	AFMemoryDetailView* memoryDetailView = [[AFMemoryDetailView alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN, 
																								topPadding, 
																								IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, memoryViewHeight)];
	
	memoryDetailView.memoryValue = [[[[[detailData objectForKey:DATA_NAME] 
							   objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME] objectAtIndex:0] doubleValue];
	memoryDetailView.memoryTotal = [[[[detailData objectForKey:DATA_NAME] 
									 objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME] doubleValue];
	
	
	[self.view addSubview:memoryDetailView];
	[memoryDetailView release];
	
	topPadding += (memoryViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	
	AFWidgetBaseView* diskViewContainer = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN, topPadding, IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, diskViewHeight)];
	diskViewContainer.widgetNameLabelText = @"Disk";
	
	self.diskViewController = [[[AFDiskDetailViewController alloc] init] autorelease];
	diskViewController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
											   IPAD_WIDGET_INTERNAL_PADDING + IPAD_WIDGET_SECTION_TITLE_HEIGHT, 
											   IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_WIDGET_INTERNAL_PADDING * 2, 
											   diskViewHeight - IPAD_WIDGET_SECTION_TITLE_HEIGHT  - IPAD_WIDGET_INTERNAL_PADDING * 2);
	
	diskViewController.diskValues = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
	diskViewController.diskTotals = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
	diskViewController.diskNames = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_NAME_NAME];
	
	[diskViewContainer addSubview:diskViewController.view];
	[self.view addSubview:diskViewContainer];
	[diskViewContainer release];
	[diskViewController.tableView reloadData];
	
	AFVerticalSeparator* separator = [[AFVerticalSeparator alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN + IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, 
																						   0, IPAD_SPLITTER_DIV_WIDTH, IPAD_SCREEN_HEIGHT)];
	[self.view addSubview:separator];
	[separator release];
	
	[self.navigationItem.leftBarButtonItem setTitle:@"back"];
	
	//[self.indicatorController.view removeFromSuperview];
	
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[connection release];
	
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
	
	@try {
		NSDictionary *dictionary = (NSDictionary*)[jsonString JSONValue];
		self.detailData = dictionary;
	}
	@catch (NSException * e) {
		NSLog(@"main: Caught %@: %@", [e name], [e reason]);
		return;
	}
	
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
	
	
	
	[self _createRefreshButton];
	[self _setQueryUrl];

	
	
	
	[self asyncGetServerData];
	
	
	self.sortableTableView = [[[AFSortableTableViewController alloc] initWithPk:self.serverPK] autorelease];
	self.sortableTableView.view.frame = CGRectMake(270, 10, 500, 350);
	
	[self.view addSubview:self.sortableTableView.view];
	
	
	self.pollDataController = [[[AFPollDataController alloc] initWithPk:self.serverPK] autorelease];
	[self.view addSubview:self.pollDataController.view];
	
	self.alertViewController = [[[AFAlertDetailViewController alloc] init] autorelease];
	//[self.view addSubview:self.alertViewController.view];
	
	
	
	
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }


 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	double titleSectionHeight = IPAD_WIDGET_SECTION_TITLE_HEIGHT;
	double sortButtonWidth = 20;
	double left = IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN;
	double landscapeTableWidth = IPAD_SCREEN_HEIGHT - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2;
	double portraitTableWidth = IPAD_SCREEN_WIDTH - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2;
	
	
	    // Overriden to allow any orientation.
    if ((interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
		//NSLog(@"%f 1", self.view.frame.size.width);
		self.sortableTableView.view.frame = CGRectMake(left, 
													   IPAD_DETAIL_VIEW_MARGIN, 
													   landscapeTableWidth, 
													   PROCESS_TABLE_LANDSCAPE_HEIGHT);
		
		self.pollDataController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_LANDSCAPE_HEIGHT, 
														landscapeTableWidth, 
														IPAD_POLL_DATA_TABLE_LANDSCAPE_HEIGHT);
		
		/*
		self.alertViewController.view.frame = CGRectMake(left, 
														 IPAD_DETAIL_VIEW_MARGIN * 3 + PROCESS_TABLE_HEIGHT + IPAD_POLL_DATA_TABLE_LANDSCAPE_HEIGHT, 
														 landscapeTableWidth, 
														 IPAD_ALERT_DATA_TABLE_LANDSCAPE_HEIGHT);
		*/
		
	}
	else if ((interfaceOrientation == UIDeviceOrientationLandscapeLeft))	{
		//NSLog(@"%f 2", self.view.frame.size.width);
		self.sortableTableView.view.frame = CGRectMake(left
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   landscapeTableWidth
													   , PROCESS_TABLE_LANDSCAPE_HEIGHT);

		self.pollDataController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_LANDSCAPE_HEIGHT, 
														landscapeTableWidth, 
														IPAD_POLL_DATA_TABLE_LANDSCAPE_HEIGHT);
		/*
		self.alertViewController.view.frame = CGRectMake(left, 
														 IPAD_DETAIL_VIEW_MARGIN * 3 + PROCESS_TABLE_HEIGHT + IPAD_POLL_DATA_TABLE_LANDSCAPE_HEIGHT, 
														 landscapeTableWidth, 
														 IPAD_ALERT_DATA_TABLE_LANDSCAPE_HEIGHT);
		*/
	}
	else if ((interfaceOrientation == UIDeviceOrientationPortrait))	{
		self.sortableTableView.view.frame = CGRectMake(left
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   portraitTableWidth
													   , PROCESS_TABLE_PORTRAIT_HEIGHT);
		
		self.pollDataController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_PORTRAIT_HEIGHT, 
														portraitTableWidth, 
														IPAD_POLL_DATA_TABLE_PORTRAIT_HEIGHT);
		
		/*
		self.alertViewController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 3 + PROCESS_TABLE_HEIGHT + IPAD_POLL_DATA_TABLE_PORTRAIT_HEIGHT, 
														portraitTableWidth, 
														IPAD_ALERT_DATA_TABLE_PORTRAIT_HEIGHT);
		
		*/
		
		
	} else {
		self.sortableTableView.view.frame = CGRectMake(left
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   portraitTableWidth
													   , PROCESS_TABLE_PORTRAIT_HEIGHT);
		
		self.pollDataController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_PORTRAIT_HEIGHT, 
														portraitTableWidth, 
														IPAD_POLL_DATA_TABLE_PORTRAIT_HEIGHT);
		
		/*
		self.alertViewController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 3 + PROCESS_TABLE_HEIGHT + IPAD_POLL_DATA_TABLE_PORTRAIT_HEIGHT, 
														portraitTableWidth, 
														IPAD_ALERT_DATA_TABLE_PORTRAIT_HEIGHT);
		*/
	}
	
	self.sortableTableView.tableController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
																   titleSectionHeight + IPAD_WIDGET_INTERNAL_PADDING, 
																   self.sortableTableView.view.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING * 2, 
																   self.sortableTableView.view.frame.size.height - titleSectionHeight - IPAD_WIDGET_INTERNAL_PADDING * 2);
	
	
	self.sortableTableView.sortButton.frame = CGRectMake(self.sortableTableView.view.frame.size.width - sortButtonWidth - IPAD_WIDGET_INTERNAL_PADDING, 
														 0, 
														 sortButtonWidth, 
														 titleSectionHeight);
	
	
	self.sortableTableView.metricsViewBounder.frame = CGRectMake(self.sortableTableView.view.frame.size.width - MATRICS_TABLE_WIDTH, 
																 titleSectionHeight, 
																 MATRICS_TABLE_WIDTH, 
																 self.sortableTableView.view.frame.size.height - titleSectionHeight);
	self.pollDataController.tableController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
																titleSectionHeight + IPAD_WIDGET_INTERNAL_PADDING, 
																self.pollDataController.view.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING* 2, 
																self.pollDataController.view.frame.size.height - titleSectionHeight - IPAD_WIDGET_INTERNAL_PADDING * 2);
	
	/*
	self.alertViewController.tableController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
																	titleSectionHeight + IPAD_WIDGET_INTERNAL_PADDING, 
																	self.alertViewController.view.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING* 2, 
																	self.alertViewController.view.frame.size.height - titleSectionHeight - IPAD_WIDGET_INTERNAL_PADDING * 2);
	*/
	return YES;
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
	[serverName release];
	[detailData release];
	//[responseData release];
	[queryUrl release];
	[osType release];
	[pollDataController release];
	[sortableTableView release];
	[diskViewController release];
	[alertViewController release];
	[indicatorController release];
	[serverPK release];
    [super dealloc];
}


@end
