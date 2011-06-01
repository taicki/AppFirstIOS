//
//  AC_ApplicationPageViewController.m
//  AppFirst
//
//  Created by appfirst on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AC_ApplicationPageViewController.h"
#import "AppStrings.h"

@implementation AC_ApplicationPageViewController
@synthesize scrollView, pageControl, detailController, processesController;
@synthesize application;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [application release];
    [scrollView release];
    [pageControl release];
    [detailController release];
    [processesController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor]];
    self.navigationItem.title = @"Server detail";

	
	scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	
	
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    pageControl.numberOfPages =2;
    pageControl.currentPage = 0;
	
	
    [self loadScrollViewWithPage:0];
	[self loadScrollViewWithPage:1];
    // Do any additional setup after loading the view from its nib.
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

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= 3) return;
	
    if (page == 1) {
        self.processesController = [[AC_ProcessListContainerViewController alloc]  initWithNibName:@"AC_ProcessListContainerViewController" bundle:nil];
        NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/processes/", 
                               [AppStrings appfirstServerAddress], 
                               [AppStrings applicationListUrl], 
                               [application uid]];
        [[self processesController] setResourceUrl:urlString];
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 45;
		frame.size.height = frame.size.height -	62;
        processesController.view.frame = frame;
        [scrollView addSubview:self.processesController.view];
        
        
    } else {
		self.detailController = [[AC_ApplicationDetailViewController alloc]  initWithNibName:@"AC_ApplicationDetailViewController" bundle:nil];
        [detailController setApplication:application];
		CGRect frame = scrollView.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 45;
		frame.size.height = frame.size.height -	62;
		self.detailController.view.frame = frame;
		[scrollView addSubview:self.detailController.view];
        [self.detailController viewWillAppear:YES];
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


@end
