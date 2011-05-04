    //
//  AFServerDetailViewController.m
//  AppFirst
//
//  Created by appfirst on 7/7/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AFServerDetailViewController.h"
#import "AFServerNameView.h"
#import "AFWidgetBaseView.h"
#import "AppDelegate_Shared.h"
#import "AC_SystemResouceListViewController.h"
#import "JSON.h"
#import "AppHelper.h"
#import "AppStrings.h"
#import "config.h"
#import "AppComm.h"
#import "AM_SystemData.h"

@implementation AFServerDetailViewController

@synthesize server;
@synthesize responseData;



- (void) createServerNameView: (double) serverNameViewHeight topPadding: (double) topPadding  {
    AFServerNameView* serverNameView = [[AFServerNameView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
																						  topPadding, 
																						  IPHONE_SERVER_DETAIL_VIEW_WIDTH - 
                                                                                        IPHONE_WIDGET_PADDING * 2, serverNameViewHeight)];
	serverNameView.serverName = [server hostname];
	serverNameView.osType = [server os];
	[self.view addSubview:serverNameView];
	[serverNameView release];

}


- (void) createResourceListView: (double) topPadding resources:(NSMutableArray*) resources systemData:(AM_SystemData*) systemData {
    int resourceViewContainerWidth = IPHONE_SERVER_DETAIL_VIEW_WIDTH - IPHONE_WIDGET_PADDING * 2;
    int resourceViewContainerHeight = self.view.frame.size.height - topPadding - IPHONE_WIDGET_PADDING;
    AFWidgetBaseView* resourceViewContainer = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, topPadding, 
																							 resourceViewContainerWidth,resourceViewContainerHeight 
																							 )];
    NSString *timeText = [NSString stringWithFormat:@"Resource usage at: %@", 
                          [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:[systemData time]]]];
    resourceViewContainer.widgetNameLabelText = timeText;
    
    AC_SystemResouceListViewController* resourceListViewController = [[AC_SystemResouceListViewController alloc] initWithNibName:@"AC_SystemResouceListViewController" bundle:nil];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/data/?num=60", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings serverListUrl], 
                           [server uid]];
    [resourceListViewController setServer:server];
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

- (void) renderView: (NSMutableArray*) resources systemData:(AM_SystemData*) systemData{
    double topPadding = IPHONE_WIDGET_PADDING;
    double serverNameViewHeight = 50;
	[self createServerNameView: serverNameViewHeight topPadding: topPadding];
    topPadding += serverNameViewHeight + IPHONE_WIDGET_PADDING;
    [self createResourceListView: topPadding resources:resources systemData: systemData];
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
        AM_SystemData* systemData = [[AM_SystemData alloc] initWithJSONObject:dictionary];
        [systemData generateResourceArray:resources server:server];
		//self.detailData = dictionary;
        [jsonString release];
        [self renderView:resources systemData:systemData];
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
                           [AppStrings serverListUrl], 
                           [server uid]];
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
	[server release];
    [responseData release];
    [super dealloc];
}


@end
