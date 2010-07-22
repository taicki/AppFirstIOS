//
//  AFPollDataController.h
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPollDataTableViewController.h"

@interface AFPollDataController : UIViewController {
	AFPollDataTableViewController* tableController;
	NSMutableData* responseData;
	NSString* queryUrl;
	NSString* serverPK;
	NSDictionary* detailData;
	UILabel* titleLabel;
	
	
}
- (void) asyncGetServerData;
- (id) initWithPk:(NSString*) pk;

@property (nonatomic, retain) AFPollDataTableViewController* tableController;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) NSString* serverPK;
@property (nonatomic, retain) NSDictionary* detailData;
@property (nonatomic, retain) UILabel* titleLabel;
@end
