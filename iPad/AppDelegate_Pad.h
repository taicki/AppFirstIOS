//
//  AppDelegate_Pad.h
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"
#import "PieChart_SampleViewController.h"

@interface AppDelegate_Pad : AppDelegate_Shared {
	PieChart_SampleViewController *viewController;
}

- (IBAction) login : (id) sender;

- (void) trySignIn;
- (void) getServerListData;

@property (nonatomic, retain) IBOutlet PieChart_SampleViewController *viewController;


@end

