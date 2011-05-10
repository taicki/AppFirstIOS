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
