//
//  AppDelegate_Phone.h
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"

@interface AppDelegate_Phone : AppDelegate_Shared {
}

- (IBAction) login : (id) sender;

- (void) trySignIn;
- (void) getServerListData;
- (void) getAlertListData;

@end

