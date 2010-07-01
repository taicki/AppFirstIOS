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
#import "AFLoadingViewController.h"

@interface AFSortableTableViewController : UIViewController {
	AFTableViewController* tableController;
	AFMetricsPicker* metricsController;
	UIView* metricsViewBounder;
	UIButton* sortButton;
	UIPopoverController* popoverController;
	
	NSDictionary* detailData;
	NSMutableData* responseData;
	NSString* queryUrl;
	NSString* serverPK;
	UILabel* titleLabel;
}

@property (nonatomic, retain) AFTableViewController* tableController;
@property (nonatomic, retain) AFMetricsPicker* metricsController;
@property (nonatomic, retain) UIButton* sortButton;
@property (nonatomic, retain) UIView* metricsViewBounder;
@property (nonatomic, retain) UIPopoverController* popoverController;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) NSString* serverPK;
@property (nonatomic, retain) NSDictionary* detailData;
@property (nonatomic, retain) UILabel* titleLabel;



- (IBAction) changeMetricsViewDisplay: (id) sender;
- (void) reorderTableByMetric: (NSString*) metric;
- (id) initWithPk:(NSString*) pk;
@end
