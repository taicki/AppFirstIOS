//
//  AC_AlertHistoryListViewController.h
//  AppFirst
//
//  Created by appfirst on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AC_AlertHistoryListViewController : UITableViewController {
    NSMutableArray* alertHistories;
}

- (void) setAlertHistories:(NSMutableArray*) list;

@end
