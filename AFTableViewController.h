//
//  AFTableViewController.h
//  AppFirst
//
//  Created by appfirst on 6/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFTableViewController : UITableViewController {
	NSMutableArray* processNames;
	NSString* sortKey;
}

@property (nonatomic, retain) NSMutableArray* processNames;
@property (nonatomic, retain) NSString* sortKey;


- (void) asyncGetServerData;
@end
