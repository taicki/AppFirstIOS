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
	NSMutableData* responseData;
	
	NSString* queryUrl;
	IBOutlet UIActivityIndicatorView* activityIndicator;
	BOOL needRefresh;
}

@property (nonatomic, retain) NSArray* alerts;
@property (nonatomic, retain) NSDictionary* allData;
@property (nonatomic, retain) NSArray* availableCookies;
@property (nonatomic, retain) NSMutableArray* nagiosAlerts;
@property (nonatomic, retain) NSMutableArray* otherAlerts;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;

@property (nonatomic, readwrite) BOOL needRefresh;


- (void) getServerListData: (BOOL)usingRefresh;
- (void) finishLoading:(NSString*)theJobToDo;
- (void) asyncGetListData;

- (void) _createRefreshButton;
- (void)_createRefreshIndicator;
- (void)  _createNavigatorTitle;
- (void) _setQueryUrl;


@end
