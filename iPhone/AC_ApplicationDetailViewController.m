//
//  AC_ApplicationDetailViewController.m
//  AppFirst
//
//  Created by appfirst on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AC_ApplicationDetailViewController.h"
#import "AC_ProcessResourceListViewController.h"
#import "AFWidgetBaseView.h"
#import "AM_ProcessData.h"
#import "AppComm.h"
#import "config.h"
#import "AppStrings.h"
#import "AppHelper.h"


@implementation AC_ApplicationDetailViewController

@synthesize application, responseData;

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
																						  IPHONE_SERVER_DETAIL_VIEW_WIDTH - 
                                                                                          IPHONE_WIDGET_PADDING * 2, nameViewHeight)];
	nameView.widgetNameLabelText = [application name];
	[self.view addSubview:nameView];
	[nameView release];
    
}


- (void) createResourceListView: (double) topPadding resources:(NSMutableArray*) resources data:(AM_ProcessData*) data {
    int resourceViewContainerWidth = IPHONE_SERVER_DETAIL_VIEW_WIDTH - IPHONE_WIDGET_PADDING * 2;
    int resourceViewContainerHeight = self.view.frame.size.height - topPadding - IPHONE_WIDGET_PADDING;
    AFWidgetBaseView* resourceViewContainer = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, topPadding, 
                                                                                                 resourceViewContainerWidth,resourceViewContainerHeight 
                                                                                                 )];
    NSString *timeText = [NSString stringWithFormat:@"Resource usage at: %@", 
                          [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:[data time]]]];
    resourceViewContainer.widgetNameLabelText = timeText;
    
    AC_ProcessResourceListViewController* resourceListViewController = [[AC_ProcessResourceListViewController alloc] initWithNibName:@"AC_ProcessResourceListViewController" bundle:nil];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/data/?num=60", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings applicationListUrl], 
                           [application uid]];
    //[resourceListViewController setApplication:application];
    [resourceListViewController setResourceUrl:urlString];
    resourceListViewController.view.frame = CGRectMake(IPHONE_WIDGET_PADDING, 
                                                       IPAD_WIDGET_SECTION_TITLE_HEIGHT + IPHONE_WIDGET_PADDING * 2, 
                                                       resourceViewContainerWidth - IPHONE_WIDGET_PADDING * 2, 
                                                       resourceViewContainerHeight - IPHONE_WIDGET_PADDING * 3 - IPAD_WIDGET_SECTION_TITLE_HEIGHT );
    [resourceListViewController setResources:resources];
    [resourceViewContainer addSubview:resourceListViewController.view];
    [self.view addSubview: resourceViewContainer];
    [resourceViewContainer release];
    
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
	
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    NSMutableArray* resources = [[NSMutableArray alloc] init];
	
	@try {
        NSLog(@"%@", jsonString);
		NSDictionary *dictionary = [(NSMutableArray*)[jsonString JSONValue] objectAtIndex:0];
        AM_ProcessData* data = [[AM_ProcessData alloc] initWithJSONObject:dictionary];
        [data generateResourceArray:resources];
		//self.detailData = dictionary;
        [jsonString release];
        [self renderView:resources data:data];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    
}

- (void)dealloc
{
    [application release];
    [responseData release];
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
