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
#import "AC_SocketListViewController.h"
#import "AC_ThreadListViewController.h"
#import "AC_RegistryListViewController.h"
#import "AC_FileListViewController.h"
#import "AC_IncidentsListViewController.h"

@interface AC_MinuteDetailViewController : UIViewController {
    NSString* myTitle;
    UITabBarController *tabcontroller;
    NSString* resourceUrl;
    NSMutableData* responseData;
    
    AC_FileListViewController* fileController;
    AC_IncidentsListViewController* incidentController;
    AC_SocketListViewController* socketController;
    AC_RegistryListViewController* registryController;
    AC_ThreadListViewController* threadController;
    
    NSMutableArray* mytabs;
}


@property (nonatomic, retain) NSMutableArray* mytabs;
@property (nonatomic, retain) NSString* myTitle;
@property (nonatomic, retain) NSString* resourceUrl;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) IBOutlet UITabBarController* tabController;
@property (nonatomic, retain) IBOutlet AC_FileListViewController* fileController;
@property (nonatomic, retain) IBOutlet AC_IncidentsListViewController* incidentController;
@property (nonatomic, retain) IBOutlet AC_SocketListViewController* socketController;
@property (nonatomic, retain) IBOutlet AC_RegistryListViewController* registryController;
@property (nonatomic, retain) IBOutlet AC_ThreadListViewController* threadController;

//@property (nonatomic, retain) UINavigationController* socketContainer;
//@property (nonatomic, retain) 



@end
