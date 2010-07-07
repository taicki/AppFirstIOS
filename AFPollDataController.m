    //
//  AFPollDataController.m
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFPollDataController.h"
#import "AFWidgetBaseView.h"
#import "AppDelegate_Shared.h"
#import "AppHelper.h"
#import "config.h"

@implementation AFPollDataController
@synthesize tableController;
@synthesize queryUrl, serverPK, responseData, detailData, titleLabel;
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
	AFWidgetBaseView* aView = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(270, 400, 500, 350)];
	aView.clipsToBounds = YES;
	//[aView setBackgroundColor:[UIColor blackColor]];
	self.view = aView;
	[aView release];
}

- (void) asyncGetServerData
{
	
	self.titleLabel.text = @"Polled Data (updating...)";
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
	
	self.queryUrl = [NSString stringWithFormat:@"%@%@?pk=%@", self.queryUrl, SERVER_POLLDATA_API_STRING, self.serverPK];
	NSLog(@"%@", self.queryUrl);
	
}

- (void) finishLoading:(NSString*)theJobToDo {
	
	NSArray* objects = [self.detailData objectForKey:LIST_QUERY_DATA_NAME];
	NSArray* keys = [self.detailData objectForKey:LIST_QUERY_COLUMN_NAME];
	
	self.tableController.pollData = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < [objects count]; i++) {
		NSMutableDictionary* dictObject = [[[NSMutableDictionary alloc] init] autorelease];
		for (int j= 0; j < [keys count]; j++) {
			[dictObject setValue: [[objects objectAtIndex:i] objectAtIndex:j] forKey:[keys objectAtIndex: j]];
		}
		[self.tableController.pollData addObject:dictObject];
	}
	
	[self.tableController.tableView reloadData];
	self.titleLabel.text = @"Polled Data";
	
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
	
	
	NSDictionary *dictionary = (NSDictionary*)[jsonString JSONValue];
	
	self.detailData = dictionary;	
	[self finishLoading:[AppHelper formatDateString:[NSDate date]]];
}

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
	//double sortButtonWidth = 100;
	
	UIView* titleSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleSectionHeight)];
	[titleSection setBackgroundColor:[UIColor clearColor]];
	
	UILabel* sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 2, 200, titleSectionHeight)];
	[sectionLabel setBackgroundColor:[UIColor clearColor]];
	//sectionLabel.text = @"Poll Data";
	[titleSection addSubview:sectionLabel];
	self.titleLabel = sectionLabel;
	[sectionLabel release];
	
	[self.view addSubview:titleSection];
	[titleSection release];
	
	self.tableController = [[[AFPollDataTableViewController alloc] initWithNibName:@"AFPollDataTableViewController" bundle:nil] autorelease];
	[self.view addSubview:self.tableController.view];
	
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tableController release];
	[serverPK release];
	[queryUrl release];
	[detailData release];
	[titleLabel release];
    [super dealloc];
}


@end
