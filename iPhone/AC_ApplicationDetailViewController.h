//
//  AC_ApplicationDetailViewController.h
//  AppFirst
//
//  Created by appfirst on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AM_Application.h"


@interface AC_ApplicationDetailViewController : UIViewController {
    AM_Application* application;
    NSMutableData* responseData;
}

@property (nonatomic, retain) AM_Application* application;
@property (nonatomic, retain) NSMutableData* responseData;

@end
