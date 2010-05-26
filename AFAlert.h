//
//  AFAlert.h
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFAlert : UITableViewController {
	NSArray* alerts;
	NSDictionary* allData;
	NSArray* availableCookies;
	NSMutableArray* nagiosAlerts;
	NSMutableArray* otherAlerts;
	
	NSString* queryUrl;
	IBOutlet UIActivityIndicatorView* activityIndicator;
}

@property (nonatomic, retain) NSArray* alerts;
@property (nonatomic, retain) NSDictionary* allData;
@property (nonatomic, retain) NSArray* availableCookies;
@property (nonatomic, retain) NSMutableArray* nagiosAlerts;
@property (nonatomic, retain) NSMutableArray* otherAlerts;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;


- (void) getAlertListData:(BOOL)usingRefresh;
- (void) finishLoading:(id)theJobToDo;
- (void) tryUpdating:(id)theJobtoDo;

@end
