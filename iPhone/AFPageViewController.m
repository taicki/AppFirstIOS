    //
//  AFPageViewController.m
//  AppFirst
//
//  Created by appfirst on 7/6/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AFPageViewController.h"

#import "config.h"

@implementation AFPageViewController
@synthesize scrollView, pageControl;
@synthesize sortableTableController, pollDataController, serverDetailController;
@synthesize server;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/




- (void) showMetricsView {
		
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor grayColor]];

	
	scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	
	
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
	
	
    [self loadScrollViewWithPage:0];
	[self loadScrollViewWithPage:1];
	[self loadScrollViewWithPage:2];
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		
	return interfaceOrientation == UIDeviceOrientationPortrait;
	
	if ((interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
				
	}
	else if ((interfaceOrientation == UIDeviceOrientationLandscapeLeft))	{
	
	}
	else if ((interfaceOrientation == UIDeviceOrientationPortrait))	{
				
	} else {
		
	}
	
	return YES;
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}





- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= 3) return;
	
    NSString* serverPk = [NSString stringWithFormat:@"%d", [server uid]];
	if (page == 1) {
		self.pollDataController = [[AFPollDataController alloc] initWithPk: serverPk];

		
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * page + IPHONE_WIDGET_PADDING;
		frame.origin.y = 45;
		frame.size.height = frame.size.height -	62;
		frame.size.width = frame.size.width - IPHONE_WIDGET_PADDING * 2;
		self.pollDataController.view.frame = frame;
        
		self.pollDataController.tableController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
														   20 + IPAD_WIDGET_INTERNAL_PADDING, 
														   self.pollDataController.view.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING* 2, 
														   self.pollDataController.view.frame.size.height - 20 - IPAD_WIDGET_INTERNAL_PADDING * 2);
		
		[scrollView addSubview:self.pollDataController.view];
		

    } else if (page == 2){
		self.sortableTableController = [[AFSortableTableViewController alloc] initWithPk:serverPk];
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * page + IPHONE_WIDGET_PADDING;
		frame.origin.y = 45;
		frame.size.width = frame.size.width - IPHONE_WIDGET_PADDING * 2;
		frame.size.height = frame.size.height -	62;
		self.sortableTableController.view.frame = frame;
		self.sortableTableController.sortButton.frame =  CGRectMake(self.view.frame.size.width - 35, 0, 20, 20);
		self.sortableTableController.tableController.view.frame = CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
															   20 + IPAD_WIDGET_INTERNAL_PADDING, 
															   self.pollDataController.view.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING* 2, 
															   self.pollDataController.view.frame.size.height - 20 - IPAD_WIDGET_INTERNAL_PADDING * 2);
			
		[scrollView addSubview:self.sortableTableController.view];
		self.sortableTableController.metricsViewBounder.frame = self.sortableTableController.tableController.view.frame;
		
	} else {
		self.serverDetailController = [[AFServerDetailViewController alloc]  initWithNibName:@"AFServerDetailViewController" bundle:nil];
        [serverDetailController setServer:server];
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 45;
		frame.size.height = frame.size.height -	62;
		self.serverDetailController.view.frame = frame;
		[scrollView addSubview:self.serverDetailController.view];
        [self.serverDetailController viewWillAppear:YES];
	}

}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
		
    //[self loadScrollViewWithPage:page];
	
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
	return;
    int page = pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.pageControl = nil;
	self.scrollView = nil;
}


- (void)dealloc {
	[scrollView release];
	[pageControl release];
	[serverDetailController release];
	[pollDataController release];
	[sortableTableController release];
    [super dealloc];
}


@end
