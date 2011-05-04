//
//  AC_ProcessResourceListViewController.h
//  AppFirst
//
//  Created by appfirst on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AC_ProcessResourceListViewController : UITableViewController {
    NSMutableArray* resources;
    NSMutableData* responseData;
    NSString* resourceUrl;
    NSMutableArray* dataArray;
}


@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSMutableArray* dataArray;
@property (nonatomic, retain) NSString* resourceUrl;
- (void) setResources:(NSMutableArray*) list;
- (void) getData;

@end