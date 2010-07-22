//
//  ServerDetailViewPad.h
//  AppFirst
//
//  Created by appfirst on 6/18/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFCpuDetailView.h"
#import "AFSortableTableViewController.h"
#import "AFPollDataController.h"
#import "AFDiskDetailViewController.h"
#import "AFAlertDetailViewController.h"
#import "AFLoadingViewController.h"

@interface ServerDetailViewPad : UIViewController {
	AFSortableTableViewController* sortableTableView;
	AFPollDataController* pollDataController;
	AFDiskDetailViewController* diskViewController;
	AFAlertDetailViewController* alertViewController;
	AFLoadingViewController* indicatorController;
	NSString* serverName;
	NSString* osType;
	NSDictionary *detailData;
	NSMutableData* responseData;
	NSString* queryUrl;
	NSString* serverPK;
}

@property (nonatomic, retain) AFSortableTableViewController* sortableTableView;
@property (nonatomic, retain) AFPollDataController* pollDataController;
@property (nonatomic, retain) NSString* serverName;
@property (nonatomic, retain) NSDictionary *detailData;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) AFDiskDetailViewController *diskViewController;
@property (nonatomic, retain) AFAlertDetailViewController *alertViewController;
@property (nonatomic, retain) AFLoadingViewController* indicatorController;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) NSString* serverPK;
@property (nonatomic, retain) NSString* osType;

- (void) _createRefreshButton;
- (void) asyncGetServerData;
- (void) _freshViewData;

@end
