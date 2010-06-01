//
//  AFDashboard.h
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFDashboard : UITableViewController {
	NSArray* servers;
	NSDictionary* allData;
	NSArray* availableCookies;
	NSString* queryUrl;
	IBOutlet UIActivityIndicatorView* activityIndicator;
	
	NSMutableArray* collectorRunningServers;
	NSMutableArray* collectorStoppingServers;
}

@property (nonatomic, retain) NSArray* servers;
@property (nonatomic, retain) NSDictionary* allData;
@property (nonatomic, retain) NSArray* availableCookies;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;

@property (nonatomic, retain) NSMutableArray* collectorRunningServers;
@property (nonatomic, retain) NSMutableArray* collectorStoppingServers;


- (void) getServerListData: (BOOL)usingRefresh;
- (void) finishLoading:(NSString*)theJobToDo;
- (void) tryUpdating:(id)theJobtoDo;
@end
