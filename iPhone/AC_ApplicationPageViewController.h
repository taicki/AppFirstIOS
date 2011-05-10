//
//  AC_ApplicationPageViewController.h
//  AppFirst
//
//  Created by appfirst on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AM_Application.h"
#import "AC_ApplicationDetailViewController.h"
#import "AC_ProcessListContainerViewController.h"

@interface AC_ApplicationPageViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	BOOL pageControlUsed;
	AM_Application* application;
	
	AC_ApplicationDetailViewController* detailController;
    AC_ProcessListContainerViewController* processesController;
}

@property (nonatomic, retain) AM_Application* application;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, retain) AC_ApplicationDetailViewController* detailController;
@property (nonatomic, retain) AC_ProcessListContainerViewController* processesController;

- (IBAction)changePage:(id)sender;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)sender ;
- (void)loadScrollViewWithPage:(int)page;
//- (void) showMetricsView;

@end
