//
//  AlertDetailViewController.h
//  AppFirst
//
//  Created by appfirst on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAlert.h"


@interface AlertDetailViewController : UIViewController {
	IBOutlet UILabel* alertName;
	IBOutlet UILabel* lastTriggeredTime;
	IBOutlet UILabel* alertTarget;
	IBOutlet UILabel* alertValue;
	IBOutlet UILabel* alertReset;
	IBOutlet UILabel* alertTrigger;
	IBOutlet UILabel* alertType;
	IBOutlet UISwitch* alertEnabled;
	IBOutlet UILabel* alertEnabledLabel;
	
	
	NSDictionary* detailData;
	
	IBOutlet UIScrollView* viewContainer;
	CGSize bounds;
	
	NSArray* availableCookies;
	NSString* alertId;
	
	AFAlert* parentController;
}

@property (nonatomic, retain) UILabel* alertName;
@property (nonatomic, retain) UILabel* lastTriggeredTime;
@property (nonatomic, retain) UILabel* alertTarget;
@property (nonatomic, retain) UILabel* alertValue;
@property (nonatomic, retain) UILabel* alertReset;
@property (nonatomic, retain) UILabel* alertTrigger;
@property (nonatomic, retain) UILabel* alertType;
@property (nonatomic, retain) UISwitch* alertEnabled;
@property (nonatomic, retain) NSDictionary* detailData;
@property (nonatomic, retain) UIScrollView* viewContainer;
@property (nonatomic, readwrite) CGSize bounds;
@property (nonatomic, retain) NSArray* availableCookies;
@property (nonatomic, retain) NSString* alertId;
@property (nonatomic, retain) UILabel* alertEnabledLabel;
@property (nonatomic, retain) AFAlert* parentController;


@end
