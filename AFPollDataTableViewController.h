//
//  AFPollDataTableViewController.h
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFPollDataTableViewController : UITableViewController {
	NSMutableArray* pollData;
}

@property (nonatomic, retain) NSMutableArray* pollData;

@end
