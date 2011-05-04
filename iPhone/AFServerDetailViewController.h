//
//  AFServerDetailViewController.h
//  AppFirst
//
//  Created by appfirst on 7/7/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFCpuDetailView.h"
#import "AFDiskDetailViewController.h"
#import "AM_Server.h"

@interface AFServerDetailViewController : UIViewController {
	AM_Server* server;
	NSMutableData* responseData;
}

@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) AM_Server* server;

@end
