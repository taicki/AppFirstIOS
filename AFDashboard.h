//
//  AFDashboard.h
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFDashboard : UITableViewController {
	NSMutableArray* servers;
	NSDictionary* allData;
}

@property (nonatomic, retain) NSMutableArray* servers;
@property (nonatomic, retain) NSDictionary* allData;

@end
