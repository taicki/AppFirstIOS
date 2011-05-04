//
//  AC_PolledDataListViewController.h
//  AppFirst
//
//  Created by appfirst on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AC_PolledDataListViewController : UITableViewController {
    NSMutableArray* healthyPolledData;
    NSMutableArray* unhealthyPolledData;
}

- (void) setHealthyPolledData:(NSMutableArray*) list;
- (void) setUnhealthPolledDat:(NSMutableArray*) list;

@end
