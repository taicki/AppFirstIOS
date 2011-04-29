//
//  AV_IphoneRootView.h
//  AppFirst
//
//  Created by appfirst on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AV_IphoneRootView : UITableViewController {
    NSMutableArray* items;
}

- (void) setItems:(NSMutableArray*) newItems;

@end
