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

#import "ServerDetailViewPad.h"
#import "AFServerNameView.h"
#import "AppDelegate_Shared.h"
#import "AFMemoryDetailView.h"
#import "AFVerticalSeparator.h"
#import "JSON.h"
#import "AppComm.h"
#import "AppStrings.h"
#import "AppHelper.h"
#import "config.h"


@implementation ServerDetailViewPad
@synthesize pollDataController, processController, serverController, server;

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
	[self.pollDataController asyncGetServerData];
	//[self.sortableTableView asyncGetServerData];
}


- (void) finishLoading:(NSString*)theJobToDo {
		
	//[self.indicatorController.view removeFromSuperview];
	
}



/*

/* comment these two methods for release
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
    self.navigationItem.title = [NSString stringWithFormat:@"Updated at: %@", [AppHelper formatDateString:[NSDate date]]];
	
	self.serverController = [[AFServerDetailViewController alloc]  initWithNibName:@"AFServerDetailViewController" bundle:nil];
    [serverController setServer:server];
    self.serverController.view.frame = CGRectMake(0, 0, IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, self.view.frame.size.height);
    [self.view addSubview:self.serverController.view];
    
	
	[self.navigationItem.leftBarButtonItem setTitle:@"back"];

	
    AFVerticalSeparator* separator = [[AFVerticalSeparator alloc] initWithFrame:CGRectMake( IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - 2, 
																						   0, IPAD_SPLITTER_DIV_WIDTH, IPAD_SCREEN_HEIGHT)];
	[self.view addSubview:separator];
	[separator release];
	
	
	self.processController = [[AC_ProcessListContainerViewController alloc]  initWithNibName:@"AC_ProcessListContainerViewController" bundle:nil];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/processes/", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings serverListUrl], 
                           [server uid]];
    [[self processController] setResourceUrl:urlString];
    processController.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, 
                                              0, self.view.frame.size.width - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, self.view.frame.size.height);
    [self.view addSubview:self.processController.view];
    
    
    NSString* serverPk = [NSString stringWithFormat:@"%d", [server uid]];
    self.pollDataController = [[AFPollDataController alloc] initWithPk: serverPk];
        
    self.pollDataController.view.frame = CGRectMake(IPAD_DETAIL_VIEW_MARGIN + IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, 400, 300, 300);
        
    self.pollDataController.tableController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
                                                                        20 + IPAD_WIDGET_INTERNAL_PADDING, 
                                                                        self.pollDataController.view.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING* 2, 
                                                                        self.pollDataController.view.frame.size.height - 20 - IPAD_WIDGET_INTERNAL_PADDING * 2);
		
    //[self.view addSubview:self.pollDataController.view];

    
    
    
	
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
    return NO;
	double titleSectionHeight = IPAD_WIDGET_SECTION_TITLE_HEIGHT;
	double left = IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH;
	double landscapeTableWidth = IPAD_SCREEN_HEIGHT - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN;
	double portraitTableWidth = IPAD_SCREEN_WIDTH - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN ;
	
	
	    // Overriden to allow any orientation.
    if ((interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
		self.processController.view.frame = CGRectMake(left - IPAD_DETAIL_VIEW_MARGIN, 
													   IPAD_DETAIL_VIEW_MARGIN, 
													   landscapeTableWidth, 
													   PROCESS_TABLE_LANDSCAPE_HEIGHT);
		
		self.pollDataController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_LANDSCAPE_HEIGHT, 
														landscapeTableWidth, 
														IPAD_POLL_DATA_TABLE_LANDSCAPE_HEIGHT);
		
	}
	else if ((interfaceOrientation == UIDeviceOrientationLandscapeLeft))	{
		self.processController.view.frame = CGRectMake(left - IPAD_DETAIL_VIEW_MARGIN
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   landscapeTableWidth
													   , PROCESS_TABLE_LANDSCAPE_HEIGHT);

		self.pollDataController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_LANDSCAPE_HEIGHT, 
														landscapeTableWidth, 
														IPAD_POLL_DATA_TABLE_LANDSCAPE_HEIGHT);
		
	}
	else if ((interfaceOrientation == UIDeviceOrientationPortrait))	{
        
		self.processController.view.frame = CGRectMake(left - IPAD_DETAIL_VIEW_MARGIN - 2
													   , 0, 
													   portraitTableWidth + IPAD_DETAIL_VIEW_MARGIN
													   , PROCESS_TABLE_PORTRAIT_HEIGHT + IPAD_DETAIL_VIEW_MARGIN * 2);
		
		self.pollDataController.view.frame = CGRectMake(left - IPAD_DETAIL_VIEW_MARGIN, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_PORTRAIT_HEIGHT, 
														portraitTableWidth, 
														IPAD_POLL_DATA_TABLE_PORTRAIT_HEIGHT);
		
		
		
	} else {
		self.processController.view.frame = CGRectMake(left - IPAD_DETAIL_VIEW_MARGIN
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   portraitTableWidth
													   , PROCESS_TABLE_PORTRAIT_HEIGHT);
		
		self.pollDataController.view.frame = CGRectMake(left, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_PORTRAIT_HEIGHT, 
														portraitTableWidth, 
														IPAD_POLL_DATA_TABLE_PORTRAIT_HEIGHT);
		
	}
	
    
	self.processController.processListController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
																   titleSectionHeight + IPAD_WIDGET_INTERNAL_PADDING, 
																   self.processController.view.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING * 2, 
																   self.processController.view.frame.size.height - titleSectionHeight - IPAD_WIDGET_INTERNAL_PADDING * 2);
	
	self.pollDataController.tableController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
																titleSectionHeight + IPAD_WIDGET_INTERNAL_PADDING, 
																self.pollDataController.view.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING* 2, 
																self.pollDataController.view.frame.size.height - titleSectionHeight - IPAD_WIDGET_INTERNAL_PADDING * 2);
	
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
	[pollDataController release];
	[server release];
    [processController release];
    [serverController release];
    [super dealloc];
}


@end
