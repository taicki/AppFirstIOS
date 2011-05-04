//
//  AC_ResouceListViewController.h
//  AppFirst
//
//  Created by appfirst on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AM_Server.h"

@interface AC_SystemResouceListViewController : UITableViewController {
    NSMutableArray* resources;
    NSMutableData* responseData;
    NSString* resourceUrl;
    AM_Server* server;
    NSMutableArray* dataArray;
}


@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSMutableArray* dataArray;
@property (nonatomic, retain) NSString* resourceUrl;
@property (nonatomic, retain) AM_Server* server;
- (void) setResources:(NSMutableArray*) list;
- (void) getData;

@end
