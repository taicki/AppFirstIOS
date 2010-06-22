//
//  AFSortableTableViewController.h
//  AppFirst
//
//  Created by appfirst on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFTableViewController.h"
#import "AFMetricsPicker.h"

@interface AFSortableTableViewController : UIViewController {
	AFTableViewController* tableController;
	AFMetricsPicker* metricsController;
	UIView* metricsViewBounder;
	UIButton* sortButton;
}

@property (nonatomic, retain) AFTableViewController* tableController;
@property (nonatomic, retain) AFMetricsPicker* metricsController;
@property (nonatomic, retain) UIButton* sortButton;
@property (nonatomic, retain) UIView* metricsViewBounder;

- (IBAction) changeMetricsViewDisplay: (id) sender;
- (void) reorderTableByMetric: (NSString*) metric;
@end
