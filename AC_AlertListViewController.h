//
//  AC_AlertListViewController.h
//  AppFirst
//
//  Created by appfirst on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AC_AlertListViewController : UITableViewController {
    NSMutableArray* inIncidentAlerts;
    NSMutableArray* normalAlerts;
}

- (void) setInIncidentAlerts:(NSMutableArray*) alerts;
- (void) setNormalAlerts:(NSMutableArray*) alerts;

@end
