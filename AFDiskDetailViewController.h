//
//  AFDiskDetailViewController.h
//  AppFirst
//
//  Created by appfirst on 6/22/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFDiskDetailViewController : UITableViewController {
	NSDictionary* dataSource;
	NSMutableArray* diskValues;
	NSMutableArray* diskTotals;
	NSMutableArray* diskNames;
}
@property (nonatomic, retain) NSDictionary* dataSource;
@property (nonatomic, retain) NSMutableArray* diskValues;
@property (nonatomic, retain) NSMutableArray* diskTotals;
@property (nonatomic, retain) NSMutableArray* diskNames;
@end
