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
#import "AM_Process.h"
#import "AC_ProcessResourceListViewController.h"

@interface AC_ProcessDetailViewController : UIViewController {
    AM_Process* process;
    UIScrollView* scrollView;
    NSMutableData* responseData;
    UIButton* detailButton;
    long long dataTime;
    UIActivityIndicatorView* activityIndicator;
    AC_ProcessResourceListViewController* resourceListViewController;
}

@property (nonatomic, retain) AM_Process* process;
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) UIButton* detailButton;
@property (nonatomic, assign) long long dataTime;
@property (nonatomic, assign) AC_ProcessResourceListViewController* resourceListViewController;

@end
