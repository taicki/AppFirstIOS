/*
 * Copyright 2009-2011 AppFirst, Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "AFPollDataController.h"
#import "AFLoadingViewController.h"
#import "AFServerDetailViewController.h"
#import "AC_ProcessListContainerViewController.h"
#import "AM_Server.h"

@interface ServerDetailViewPad : UIViewController {
	AC_ProcessListContainerViewController* processController;
    AFServerDetailViewController* serverController;
	AFPollDataController* pollDataController;
    AM_Server* server;

}

@property (nonatomic, retain) AFPollDataController* pollDataController;
@property (nonatomic, retain) AM_Server* server;
@property (nonatomic, retain) AFServerDetailViewController *serverController;
@property (nonatomic, retain) AC_ProcessListContainerViewController* processController;

- (void) _createRefreshButton;
- (void) _freshViewData;

@end
