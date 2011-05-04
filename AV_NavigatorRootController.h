//
//  AV_NavigatorRootController.h
//  AppFirst
//
//  Created by appfirst on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AV_NavigatorRootController : UITableViewController {
    NSMutableArray* items;
}

- (void) setItems:(NSMutableArray*) newItems;

@end
