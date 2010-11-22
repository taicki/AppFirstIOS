    //
//  AFServerDetailViewController.m
//  AppFirst
//
//  Created by appfirst on 7/7/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AFServerDetailViewController.h"
#import "AFServerNameView.h"
#import "AppDelegate_Shared.h"
#import "AFMemoryDetailView.h"
#import "JSON.h"
#import "AppHelper.h"
#import "config.h"

@implementation AFServerDetailViewController

@synthesize diskViewController;
@synthesize queryUrl, serverPK, serverName, osType;
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
- (id) initWithPk:(NSString*) pk {
	if ((self = [super init])) {
        // Custom initialization
		self.serverPK = pk;
    }
	
	return self;
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

	double serverNameViewHeight = 50;
	double memoryViewHeight = 70;
	double cpuViewHeight = 70; 
	double diskViewHeight = 150;
	
	
	double topPadding = IPHONE_WIDGET_PADDING;
	
	AFServerNameView* serverNameView = [[AFServerNameView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
																						  topPadding, 
																						  IPHONE_SERVER_DETAIL_VIEW_WIDTH - 
																						  IPHONE_WIDGET_PADDING * 2, serverNameViewHeight)];
	serverNameView.serverName = self.serverName;
	serverNameView.osType = self.osType;
	[self.view addSubview:serverNameView];
	[serverNameView release];
	
	topPadding += (serverNameViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	
	
	AFCpuDetailView* cpuDetailView = [[AFCpuDetailView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
																					   topPadding, 
																					   IPHONE_SERVER_DETAIL_VIEW_WIDTH - IPHONE_WIDGET_PADDING * 2,
																					   cpuViewHeight)];
	
	NSArray *cpuValues = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
	cpuDetailView.cpuDetail = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
	cpuDetailView.cpuValue = [[cpuValues objectAtIndex:0] doubleValue];
	[self.view addSubview:cpuDetailView];
	[cpuDetailView release];
	
	topPadding += (cpuViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	
	AFMemoryDetailView* memoryDetailView = [[AFMemoryDetailView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
																								topPadding, 
																								IPHONE_SERVER_DETAIL_VIEW_WIDTH - IPHONE_WIDGET_PADDING * 2, memoryViewHeight)];
	
	memoryDetailView.memoryValue = [[[[[detailData objectForKey:DATA_NAME] 
									   objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME] objectAtIndex:0] doubleValue];
	memoryDetailView.memoryTotal = [[[[detailData objectForKey:DATA_NAME] 
									  objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME] doubleValue];
	
	
	[self.view addSubview:memoryDetailView];
	[memoryDetailView release];
	
	topPadding += (memoryViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	
	
	AFWidgetBaseView* diskViewContainer = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, topPadding, 
																							 IPHONE_SERVER_DETAIL_VIEW_WIDTH - IPHONE_WIDGET_PADDING * 2, 
																							 diskViewHeight)];
	diskViewContainer.widgetNameLabelText = @"Disk";
	
	self.diskViewController = [[[AFDiskDetailViewController alloc] init] autorelease];
	diskViewController.view.frame = CGRectMake(IPHONE_WIDGET_PADDING, 
											   IPHONE_WIDGET_PADDING + IPAD_WIDGET_SECTION_TITLE_HEIGHT, 
											   IPHONE_SERVER_DETAIL_VIEW_WIDTH - IPAD_WIDGET_INTERNAL_PADDING * 2, 
											   diskViewHeight - IPAD_WIDGET_SECTION_TITLE_HEIGHT  - IPAD_WIDGET_INTERNAL_PADDING * 2);
	
	diskViewController.diskValues = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
	diskViewController.diskTotals = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
	diskViewController.diskNames = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_NAME_NAME];
	
	[diskViewContainer addSubview:diskViewController.view];
	[self.view addSubview:diskViewContainer];
	[diskViewContainer release];
	[diskViewController.tableView reloadData];
	

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
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
	[self _setQueryUrl];
	[self asyncGetServerData];
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[detailData release];
	[queryUrl release];
	[diskViewController release];
	[serverPK release];
	[serverName release];
	[osType release];
    [super dealloc];
}


@end
