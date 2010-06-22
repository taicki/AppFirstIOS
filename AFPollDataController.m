    //
//  AFPollDataController.m
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFPollDataController.h"
#import "AFWidgetBaseView.h"
#import "config.h"

@implementation AFPollDataController
@synthesize tableController;
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
	AFWidgetBaseView* aView = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(270, 400, 500, 350)];
	aView.clipsToBounds = YES;
	//[aView setBackgroundColor:[UIColor blackColor]];
	self.view = aView;
	[aView release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	double titleSectionHeight = 20;
	//double sortButtonWidth = 100;
	
	UIView* titleSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleSectionHeight)];
	[titleSection setBackgroundColor:[UIColor clearColor]];
	
	UILabel* sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 2, 200, titleSectionHeight)];
	[sectionLabel setBackgroundColor:[UIColor clearColor]];
	sectionLabel.text = @"Poll Data";
	[titleSection addSubview:sectionLabel];
	[sectionLabel release];
	
	[self.view addSubview:titleSection];
	[titleSection release];
	
	self.tableController = [[[AFPollDataTableViewController alloc] initWithNibName:@"AFPollDataTableViewController" bundle:nil] autorelease];
	[self.view addSubview:self.tableController.view];
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
    [super dealloc];
}


@end
