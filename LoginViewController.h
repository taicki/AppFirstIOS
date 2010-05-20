//
//  LoginViewController.h
//  AppFirst
//
//  Created by appfirst on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController {
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIButton *loginButton;
	IBOutlet UIActivityIndicatorView *loginIndicator;
	IBOutlet UILabel *invalidLoginLabel;
	IBOutlet UISwitch *savePassword;
	
}

@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIActivityIndicatorView *loginIndicator;
@property (nonatomic, retain) UILabel *invalidLoginLabel;
@property (nonatomic, retain) UISwitch *savePassword;


@end
