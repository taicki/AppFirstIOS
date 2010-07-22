//
//  AFAlertDetailViewController.h
//  AppFirst
//
//  Created by appfirst on 6/23/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAlertTableViewController.h"


@interface AFAlertDetailViewController : UIViewController {
	AFAlertTableViewController* tableController;
	
	NSMutableData* responseData;
	NSString* queryUrl;
	NSString* serverPK;
	NSDictionary* detailData;
}

@property (nonatomic, retain) AFAlertTableViewController* tableController;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) NSString* serverPK;
@property (nonatomic, retain) NSDictionary* detailData;
@end
