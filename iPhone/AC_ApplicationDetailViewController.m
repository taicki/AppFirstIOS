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

#import "AC_ApplicationDetailViewController.h"
#import "AC_ProcessResourceListViewController.h"
#import "AC_MinuteDetailViewController.h"
#import "AFWidgetBaseView.h"
#import "AM_ProcessData.h"
#import "AppDelegate_Shared.h"
#import "AppComm.h"
#import "config.h"
#import "AppStrings.h"
#import "AppHelper.h"


@implementation AC_ApplicationDetailViewController

@synthesize application, responseData, detailButton, dataTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void) createNameView: (double) nameViewHeight topPadding: (double) topPadding  {
    AFWidgetBaseView* nameView = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
																						  topPadding, 
																						  self.view.frame.size.width - 
                                                                                          IPHONE_WIDGET_PADDING * 2, nameViewHeight)];
	nameView.widgetNameLabelText = [application name];
	[self.view addSubview:nameView];
	[nameView release];
    
}

- (void) createInfoButton: (UIView*) container {
    [self setDetailButton: [[UIButton buttonWithType:UIButtonTypeInfoDark] autorelease]];
    self.detailButton.frame = CGRectMake(self.view.frame.size.width - 30, 2, 20, 20);
    [self.detailButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:self.detailButton];
}

- (void) showDetailView: (id) sender {

    AC_MinuteDetailViewController* detailController = [[AC_MinuteDetailViewController alloc] init];
   
	// show the navigation controller modally
	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/detail/?time=%lld", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings applicationListUrl], 
                           [application uid],
                           [self dataTime]];
    NSString* title = [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:[self dataTime]]];
    [detailController setResourceUrl:urlString];
    [detailController setMyTitle:title];
    [[appDelegate navigationController] presentModalViewController:detailController animated:YES];
    //[[appDelegate window] addSubview:navController.view];
    [detailController release];
}


- (void) createResourceListView: (double) topPadding resources:(NSMutableArray*) resources data:(AM_ProcessData*) data {
    int resourceViewContainerWidth = self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2;
    
    int resourceViewContainerHeight = self.view.frame.size.height - topPadding - IPHONE_WIDGET_PADDING;
    if ([AppHelper isIPad]) {
        resourceViewContainerHeight -= 200;
    }
    AFWidgetBaseView* resourceViewContainer = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, topPadding, 
                                                                                                 resourceViewContainerWidth,resourceViewContainerHeight 
                                                                                                 )];
    [self createInfoButton:resourceViewContainer];
    NSString *timeText = [NSString stringWithFormat:@"Resource usage at: %@", 
                          [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:[data time]]]];
    [self setDataTime:[data time]];
    resourceViewContainer.widgetNameLabelText = timeText;
    
    AC_ProcessResourceListViewController* resourceListViewController = [[AC_ProcessResourceListViewController alloc] initWithNibName:@"AC_ProcessResourceListViewController" bundle:nil];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/data/?num=60", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings applicationListUrl], 
                           [application uid]];
    [resourceListViewController setResourceUrl:urlString];
    resourceListViewController.view.frame = CGRectMake(IPHONE_WIDGET_PADDING, 
                                                       IPAD_WIDGET_SECTION_TITLE_HEIGHT + IPHONE_WIDGET_PADDING * 2, 
                                                       resourceViewContainerWidth - IPHONE_WIDGET_PADDING * 2, 
                                                       resourceViewContainerHeight - IPHONE_WIDGET_PADDING * 3 - IPAD_WIDGET_SECTION_TITLE_HEIGHT );
    [resourceListViewController setResources:resources];
    [resourceViewContainer addSubview:resourceListViewController.view];
    [self.view addSubview: resourceViewContainer];
    [resourceViewContainer release];
        //[resourceListViewController release];
    
}

- (void) renderView: (NSMutableArray*) resources data:(AM_ProcessData*) data{
    double topPadding = IPHONE_WIDGET_PADDING;
    double nameViewHeight = 50;
	[self createNameView: nameViewHeight topPadding: topPadding];
    topPadding += nameViewHeight + IPHONE_WIDGET_PADDING;
    [self createResourceListView: topPadding resources:resources data: data];
}
- (void) finishLoading:(NSString*)theJobToDo {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[connection release];
    [activityIndicator stopAnimating];
	
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSMutableArray* resources = [[NSMutableArray alloc] init];
	
	@try {
		NSDictionary *dictionary = [(NSMutableArray*)[jsonString JSONValue] objectAtIndex:0];
        AM_ProcessData* data = [[AM_ProcessData alloc] initWithJSONObject:dictionary];
        [data generateResourceArray:resources];
		//self.detailData = dictionary;
        [jsonString release];
        [self renderView:resources data:data];
        [resources release];
        [data release];
	}
	@catch (NSException * e) {
		NSLog(@"main: Caught %@: %@", [e name], [e reason]);
		return;
	}
}

- (void) getData
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/data/", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings applicationListUrl], 
                           [application uid]];
	responseData = [[NSMutableData data] retain];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setTimeoutInterval:20];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppComm authString] forHTTPHeaderField:@"Authorization"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    [activityIndicator stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        //activityIndicator.center = self.view.center;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Application detail";
    [self getData];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(self.view.frame.size.width /2, self.view.frame.size.height /2, 40.0, 40.0);
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
      ;
    activityIndicator.center = self.view.center;
	[self.view addSubview: activityIndicator];
    
}

- (void)dealloc
{
    [application release];
    [responseData release];
    [activityIndicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
