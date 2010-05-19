//
//  AppDelegate_Pad.h
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"


@interface AppDelegate_Pad : AppDelegate_Shared {
}

- (IBAction) login : (id) sender;

- (void) trySignIn:(id)theJobToDo;
- (void) finishLoading:(id)theJobToDo;
- (void) getServerListData;
- (void) getAlertListData;
- (void) forLoop:(id)theJobToDo;

@end

