//
//  AlertEditViewController.h
//  AppFirst
//
//  Created by appfirst on 5/25/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertDetailViewController.h"


@interface AlertEditViewController : UIViewController {
	UILabel* alertName;
	UILabel* lastTriggeredTime;
	UILabel* alertTarget;
	UILabel* alertValue;
	UITextField* alertReset;
	UILabel* alertTrigger;
	UILabel* alertType;
	UISwitch* alertEnabled;
	
	NSDictionary* detailData;
	NSArray* availableCookies;
	
	IBOutlet UIScrollView* viewContainer;
	CGSize bounds;
	
	BOOL keyboardVisible;
	NSString* alertId;
	AlertDetailViewController* delegate;
}


@property (nonatomic, retain) UILabel* alertName;
@property (nonatomic, retain) UILabel* lastTriggeredTime;
@property (nonatomic, retain) UILabel* alertTarget;
@property (nonatomic, retain) UILabel* alertValue;
@property (nonatomic, retain) UITextField* alertReset;
@property (nonatomic, retain) UILabel* alertTrigger;
@property (nonatomic, retain) UILabel* alertType;
@property (nonatomic, retain) UISwitch* alertEnabled;
@property (nonatomic, retain) NSDictionary* detailData;
@property (nonatomic, retain) UIScrollView* viewContainer;
@property (nonatomic, readwrite) CGSize bounds;
@property (nonatomic, retain) NSArray* availableCookies;
@property (nonatomic, retain) NSString* alertId;
@property (nonatomic, retain) AlertDetailViewController* delegate;


- (IBAction) save: (id) sender;
- (IBAction) cancel: (id) sender;
- (void) keyboardDidShow: (NSNotification *) notif;
- (void) keyboardDidHide: (NSNotification *) notif;

@end
