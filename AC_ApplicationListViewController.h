//
//  AC_ApplicationListViewController.h
//  AppFirst
//
//  Created by appfirst on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AC_ApplicationListViewController : UITableViewController {
    NSMutableArray* applications;
}

- (void) setApplications:(NSMutableArray*) list;

@end
