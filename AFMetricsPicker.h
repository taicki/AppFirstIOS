//
//  AFMetricsPicker.h
//  AppFirst
//
//  Created by appfirst on 6/19/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFMetricsPicker : UITableViewController {
	NSMutableArray* metrics;
	UIViewController* parentViewController;
}

@property (nonatomic, retain) NSMutableArray* metrics;
@property (nonatomic, retain) UIViewController* parentViewController;

@end
