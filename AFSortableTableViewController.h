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
- (void) asyncGetServerData;
@end
