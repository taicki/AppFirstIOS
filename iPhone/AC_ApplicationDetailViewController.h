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
    UIButton* detailButton;
    long long dataTime;
}

@property (nonatomic, assign) long long dataTime;
@property (nonatomic, retain) AM_Application* application;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) UIButton* detailButton;

-(void) showDetailView: (id) sender;

@end
