//
//  AFPollDataController.h
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPollDataTableViewController.h"

@interface AFPollDataController : UIViewController {
	AFPollDataTableViewController* tableController;
}

@property (nonatomic, retain) AFPollDataTableViewController* tableController;

@end
