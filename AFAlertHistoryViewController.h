//
//  AFAlertHistoryViewController.h
//  AppFirst
//
//  Created by appfirst on 7/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFAlertHistoryViewController : UITableViewController {
	NSDictionary* allData;
	NSString* queryUrl;
	IBOutlet UIActivityIndicatorView* activityIndicator;
	NSMutableData* responseData;
	
	NSMutableArray* notifications;
}


@property (nonatomic, retain) NSDictionary* allData;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, retain) NSMutableArray* notifications;


- (void) getServerListData: (BOOL)usingRefresh;
- (void) finishLoading:(NSString*)theJobToDo;
- (void) asyncGetServerListData;

- (void) _createRefreshButton;
- (void) _createRefreshIndicator;
- (void) _createNavigatorTitle;
- (void) _setQueryUrl;

@end
