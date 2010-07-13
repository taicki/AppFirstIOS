    //
//  AFGraphViewController.m
//  AppFirst
//
//  Created by appfirst on 7/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFGraphViewController.h"
#import "AppDelegate_Shared.h"
#import "AppHelper.h"
#import "config.h"


@implementation AFGraphViewController

@synthesize graphView;
@synthesize graphTitle;
@synthesize queryString;
@synthesize allData;
@synthesize responseData;
@synthesize xValues, yValues, labels;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	//self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.graphView = [[S7GraphView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = self.graphView;
	self.graphView.dataSource = self;
	//self.view.backgroundColor = [UIColor yellowColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:0];
	[numberFormatter setMaximumFractionDigits:0];
	
	self.graphView.yValuesFormatter = numberFormatter;
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	[dateFormatter setDateFormat:@"MMM dd, HH:mm"];
	
	self.graphView.xValuesFormatter = dateFormatter;
	
	[dateFormatter release];        
	[numberFormatter release];
	
	self.graphView.backgroundColor = [UIColor blackColor];
	
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	
	self.graphView.xValuesColor = [UIColor whiteColor];
	self.graphView.yValuesColor = [UIColor whiteColor];
	
	self.graphView.gridXColor = [UIColor whiteColor];
	self.graphView.gridYColor = [UIColor whiteColor];
	
	self.graphView.drawInfo = YES;
	self.graphView.info = self.graphTitle;
	self.graphView.infoColor = [UIColor whiteColor];
	
	//When you need to update the data, make this call:
	
	//[self.graphView reloadData];
	
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
														initWithBarButtonSystemItem:UIBarButtonSystemItemDone
														target:self
														action:@selector(dismissView)] autorelease];
	xValues = [[NSMutableArray alloc] init];
	yValues = [[NSMutableArray alloc] init];
	[self asyncGetServerData];
}

- (void) dismissView
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void) asyncGetServerData
{
	self.navigationItem.title = @"Loading...";
	
	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:appDelegate.availableCookies];
	responseData = [[NSMutableData data] retain];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setAllHTTPHeaderFields:headers];
	[request setTimeoutInterval:30];
	request.URL = [NSURL URLWithString:self.queryString];
	
	if (DEBUGGING) {
		NSLog(@"%@", self.queryString);
	}
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void) finishLoading:(NSString*)theJobToDo {

	NSDictionary *data = (NSDictionary*)[[self.allData objectForKey:@"data"] JSONValue];
	
	self.labels = [data objectForKey:@"labels"];
	NSDictionary* objects = [data objectForKey:@"data"];
	
	
	for (id key in objects) {
		NSDictionary* dictionary = [objects objectForKey:key];
		
		[xValues addObject:key];
		[yValues addObject:dictionary];
	}
	
	if (DEBUGGING) {
		NSLog(@"%@", data);
		NSLog(@"%@", xValues);
		NSLog(@"%@", yValues);
	}
	
	self.graphView.legendNames = [[[NSMutableArray alloc] init] autorelease];
	
	for (int cnt = 0; cnt < [self.labels count]; cnt ++) 
		[self.graphView.legendNames addObject:[self.labels objectAtIndex:cnt]];
	
	self.navigationItem.title = @"";
	[self.graphView reloadData];
	sleep(1);
	[self.graphView.legendController.tableView reloadData];
	
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Can't update poll data history. " 
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
	
	self.allData = dictionary;	
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
*/



/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
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

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[graphView release];
	[queryString release];
	[allData release];
	[xValues release];
	[yValues release];
	[labels release];
	[graphTitle release];
	graphView = nil;
	
    [super dealloc];
}

#pragma mark protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */
	return [self.labels count];
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
	
	return xValues;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
	/* Return the values for a specific graph. Each plot is meant to have equal number of points.
	 And this amount should be equal to the amount of elements you return from graphViewXValues: method. */
	
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	
	for ( int i = 0 ; i < [yValues count] ; i ++ ) {
		[array addObject:[[yValues objectAtIndex:i] objectAtIndex:plotIndex]];	// y = x*x		
	}
	
	return array;
}


@end
