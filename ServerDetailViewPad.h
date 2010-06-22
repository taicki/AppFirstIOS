//
//  ServerDetailViewPad.h
//  AppFirst
//
//  Created by appfirst on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFCpuDetailView.h"
#import "AFSortableTableViewController.h"
#import "AFPollDataController.h"
#import "AFDiskDetailViewController.h"

@interface ServerDetailViewPad : UIViewController {
	AFSortableTableViewController* sortableTableView;
	AFPollDataController* pollDataController;
	AFDiskDetailViewController* diskViewController;
	NSString* serverName;
	NSDictionary *detailData;
}	

@property (nonatomic, retain) AFSortableTableViewController* sortableTableView;
@property (nonatomic, retain) AFPollDataController* pollDataController;
@property (nonatomic, retain) NSString* serverName;
@property (nonatomic, retain) NSDictionary *detailData;
@property (nonatomic, retain) AFDiskDetailViewController *diskViewController;

- (void) _createRefreshButton;
- (void) asyncGetServerData;

@end
