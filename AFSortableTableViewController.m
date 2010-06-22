    //
//  AFSortableTableViewController.m
//  AppFirst
//
//  Created by appfirst on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFSortableTableViewController.h"
#import "AFTableViewController.h"
#import "AFWidgetBaseView.h"
#import "config.h"
//#import "AFMetricsPicker.h"

@implementation AFSortableTableViewController
@synthesize tableController;
@synthesize metricsController;
@synthesize sortButton, metricsViewBounder;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	AFWidgetBaseView* aView = [[AFWidgetBaseView alloc] initWithFrame:CGRectZero];
	aView.clipsToBounds = YES;
	self.view = aView;
	[aView release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	double titleSectionHeight = 20;
	double sortButtonWidth = 100;
	
	UIView* titleSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleSectionHeight)];
	[titleSection setBackgroundColor:[UIColor clearColor]];
	
	UILabel* sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 2, 200, titleSectionHeight)];
	sectionLabel.text = @"Running Processes";
	[sectionLabel setBackgroundColor:[UIColor clearColor]];
	[titleSection addSubview:sectionLabel];
	[sectionLabel release];
	
	self.sortButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] autorelease];//[[UIButton alloc] initWithFrame:CGRectMake(300, 0, 100, 18)];
	//[self.sortButton setTitle:@"Sort by" forState:UIControlStateNormal];
	//NSLog(@"%f", self.view.frame.size.width);
	self.sortButton.frame = CGRectMake(self.view.frame.size.width - sortButtonWidth, 0, 20, titleSectionHeight);
	[self.sortButton addTarget:self action:@selector(changeMetricsViewDisplay:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.sortButton];
	
	
	[self.view addSubview:titleSection];
	[titleSection release];
	
	
	self.tableController = [[[AFTableViewController alloc] init] autorelease];
	[self.view addSubview:self.tableController.view];
	
	self.metricsController = [[AFMetricsPicker alloc]  initWithNibName:@"AFMetricsPicker" bundle:nil];
	self.metricsController.parentViewController = self;
	
	UIView* viewBounder = [[UIView alloc] initWithFrame:CGRectMake(250, titleSectionHeight, 250, 300 - titleSectionHeight)];
	viewBounder.clipsToBounds = YES;
	[viewBounder addSubview:self.metricsController.view];
	viewBounder.hidden = YES;
	self.metricsViewBounder = viewBounder;
	[self.view addSubview:viewBounder];
	[viewBounder release];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
													   
    return YES;
}

- (IBAction) changeMetricsViewDisplay: (id) sender {
	
	self.metricsViewBounder.hidden = !self.metricsViewBounder.hidden;
}

- (void) reorderTableByMetric: (NSString*) metric {
	
	NSLog(@"%@", metric);
	self.tableController.sortKey = metric;
	NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] 
									initWithKey: metric ascending: NO];// selector: @selector(compare://caseInsensitiveCompare: ) ] ;
    [self.tableController.processNames sortUsingDescriptors: [NSArray arrayWithObject: nameSorter] ] ;
	
	[self.tableController.tableView reloadData];
	self.metricsViewBounder.hidden = YES;
	
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
	[metricsViewBounder release];
    [super dealloc];
}


@end
