    //
//  ServerDetailViewPad.m
//  AppFirst
//
//  Created by appfirst on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerDetailViewPad.h"
#import "AFServerNameView.h"
#import "AFMemoryDetailView.h"
#import "AFVerticalSeparator.h"
#import "config.h"


@implementation ServerDetailViewPad
@synthesize sortableTableView;
@synthesize pollDataController, diskViewController;
@synthesize serverName;
@synthesize detailData;

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
									  action:@selector(asyncGetServerData)];
	//refreshButton.style = UIBarButtonItemStyleBordered;
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
}

- (void) asyncGetServerData
{
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	double serverNameViewHeight = 50;
	double memoryViewHeight = 70;
	double cpuViewHeight = 180;
	double diskViewHeight = 300;
	
	[self _createRefreshButton];
	
	double topPadding = IPAD_DETAIL_VIEW_MARGIN;
	
	AFServerNameView* serverNameView = [[AFServerNameView alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN, 
																				  topPadding, 
																				  IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, serverNameViewHeight)];
	serverNameView.serverName = self.serverName;
	[self.view addSubview:serverNameView];
	[serverNameView release];
	
	topPadding += (serverNameViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	

	AFCpuDetailView* cpuDetailView = [[AFCpuDetailView alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN, 
																					   topPadding, 
																					   IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, cpuViewHeight)];
	[self.view addSubview:cpuDetailView];
	[cpuDetailView release];
	
	topPadding += (cpuViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	
	AFMemoryDetailView* memoryDetailView = [[AFMemoryDetailView alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN, 
																							topPadding, 
																							 IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, memoryViewHeight)];	
	[self.view addSubview:memoryDetailView];
	[memoryDetailView release];
	
	topPadding += (memoryViewHeight + IPAD_DETAIL_VIEW_SEPARATION_DIV_WIDTH);
	
	AFWidgetBaseView* diskViewContainer = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN, topPadding, IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, diskViewHeight)];
	diskViewContainer.widgetNameLabelText = @"Disk";
	
	self.diskViewController = [[[AFDiskDetailViewController alloc] init] autorelease];
	diskViewController.dataSource = [[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME];
	diskViewController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
											   IPAD_WIDGET_INTERNAL_PADDING + IPAD_WIDGET_SECTION_TITLE_HEIGHT, 
											   IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_WIDGET_INTERNAL_PADDING * 2, 
											   diskViewHeight - IPAD_WIDGET_SECTION_TITLE_HEIGHT  - IPAD_WIDGET_INTERNAL_PADDING * 2);
	
	[diskViewContainer addSubview:diskViewController.view];
	[self.view addSubview:diskViewContainer];
	[diskViewContainer release];
	
	AFVerticalSeparator* separator = [[AFVerticalSeparator alloc] initWithFrame:CGRectMake(IPAD_DETAIL_VIEW_MARGIN + IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH, 
																						   0, IPAD_SPLITTER_DIV_WIDTH, IPAD_SCREEN_HEIGHT)];
	[self.view addSubview:separator];
	[separator release];
	
	
	self.sortableTableView = [[[AFSortableTableViewController alloc] init] autorelease];
	self.sortableTableView.view.frame = CGRectMake(270, 10, 500, 350);
	
	[self.view addSubview:self.sortableTableView.view];
	
	
	self.pollDataController = [[[AFPollDataController alloc] init] autorelease];
	[self.view addSubview:self.pollDataController.view];
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	double titleSectionHeight = IPAD_WIDGET_SECTION_TITLE_HEIGHT;
	double sortButtonWidth = 20;
	
	NSLog(@"height: %f", self.view.frame.size.height); 
	
	    // Overriden to allow any orientation.
    if ((interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
		//NSLog(@"%f 1", self.view.frame.size.width);
		self.sortableTableView.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   IPAD_SCREEN_HEIGHT - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2
													   , PROCESS_TABLE_HEIGHT);
		
		self.pollDataController.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_HEIGHT, 
														IPAD_SCREEN_HEIGHT - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2, 
														IPAD_SECOND_TABLE_LANDSCAPE_HEIGHT);
		
	}
	else if ((interfaceOrientation == UIDeviceOrientationLandscapeLeft))	{
		//NSLog(@"%f 2", self.view.frame.size.width);
		self.sortableTableView.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   IPAD_SCREEN_HEIGHT - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2
													   , PROCESS_TABLE_HEIGHT);

		self.pollDataController.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_HEIGHT, 
														IPAD_SCREEN_HEIGHT - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2, 
														IPAD_SECOND_TABLE_LANDSCAPE_HEIGHT);
		
	}
	else if ((interfaceOrientation == UIDeviceOrientationPortrait))		{
		NSLog(@"%f 3", self.view.frame.size.height);
		self.sortableTableView.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   IPAD_SCREEN_WIDTH - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2
													   , PROCESS_TABLE_HEIGHT);
		/*
		self.sortableTableView.tableController.view.frame = CGRectMake(0, 
																	   titleSectionHeight, 
																	   self.sortableTableView.view.frame.size.width, 
																	   self.sortableTableView.view.frame.size.height - titleSectionHeight);
		
		self.sortableTableView.sortButton.frame = CGRectMake(self.sortableTableView.view.frame.size.width - sortButtonWidth, 
															 0, 
															 sortButtonWidth, 
															 titleSectionHeight); */
		self.pollDataController.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_HEIGHT, 
														IPAD_SCREEN_WIDTH - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2, 
														IPAD_SECOND_TABLE_PORTRAIT_HEIGHT);
		
		NSLog(@"%f 5", self.pollDataController.view.frame.size.width);
		
		
	} else {
		NSLog(@"%f 4", self.view.frame.size.width);
		self.sortableTableView.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN
													   , IPAD_DETAIL_VIEW_MARGIN, 
													   IPAD_SCREEN_WIDTH - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2
													   , PROCESS_TABLE_HEIGHT);
		/*
		self.sortableTableView.tableController.view.frame = CGRectMake(0, 
																	   titleSectionHeight, 
																	   self.sortableTableView.view.frame.size.width, 
																	   self.sortableTableView.view.frame.size.height - titleSectionHeight);
		self.sortableTableView.sortButton.frame = CGRectMake(self.sortableTableView.view.frame.size.width - sortButtonWidth, 
															 0, 
															 sortButtonWidth, 
															 titleSectionHeight);
		 
		*/
		self.pollDataController.view.frame = CGRectMake(IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH + IPAD_SPLITTER_DIV_WIDTH + IPAD_DETAIL_VIEW_MARGIN, 
														IPAD_DETAIL_VIEW_MARGIN * 2 + PROCESS_TABLE_HEIGHT, 
														IPAD_SCREEN_WIDTH - IPAD_DETAIL_VIEW_FIRST_COLUMN_WIDTH - IPAD_SPLITTER_DIV_WIDTH - IPAD_DETAIL_VIEW_MARGIN * 2, 
														IPAD_SECOND_TABLE_PORTRAIT_HEIGHT);
		
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
	[pollDataController release];
	[sortableTableView release];
	[diskViewController release];
    [super dealloc];
}


@end
