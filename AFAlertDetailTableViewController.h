//
//  AFAlertDetailTableViewController.h
//  AppFirst
//
//  Created by appfirst on 6/30/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFAlertDetailTableViewController : UITableViewController {
	NSString* alertName;
	NSDictionary* detailData;
	NSMutableArray* recipients;
	UISwitch* alertEnabled;
	UITextField* alertReset;
	NSString* alertID;
}

@property (nonatomic, retain) NSString* alertName;
@property (nonatomic, retain) NSDictionary* detailData;
@property (nonatomic, retain) UISwitch* alertEnabled;
@property (nonatomic, retain) UITextField* alertReset;
@property (nonatomic, retain) NSMutableArray* recipients;
@property (nonatomic, retain) NSString* alertID;

@end
