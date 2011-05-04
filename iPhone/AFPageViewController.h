//
//  AFPageViewController.h
//  AppFirst
//
//  Created by appfirst on 7/6/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPollDataController.h"
#import "AFSortableTableViewController.h"
#import "AFServerDetailViewController.h"
#import "AM_Server.h"


@interface AFPageViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	BOOL pageControlUsed;
	AM_Server* server;
	
	AFServerDetailViewController* serverDetailController;
	AFPollDataController* pollDataController;
	AFSortableTableViewController* sortableTableController;
}

@property (nonatomic, retain) AM_Server* server;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, retain) AFServerDetailViewController* serverDetailController;
@property (nonatomic, retain) AFPollDataController* pollDataController;
@property (nonatomic, retain) AFSortableTableViewController* sortableTableController;

- (IBAction)changePage:(id)sender;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)sender ;
- (void)loadScrollViewWithPage:(int)page;
- (void) showMetricsView;

@end
