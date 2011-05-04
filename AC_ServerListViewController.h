//
//  AC_ServerListViewController.h
//  AppFirst
//
//  Created by appfirst on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AC_ServerListViewController : UITableViewController {
    NSMutableArray* runningServerList;
    NSMutableArray* stoppedServerList;
}

- (void) setRunningServerList:(NSMutableArray*) list;
- (void) setStoppedServerList:(NSMutableArray*) list;
//- (NSMutableArray*) runningServerList;
//- (NSMutableArray*) stoppedServerList;

@end
