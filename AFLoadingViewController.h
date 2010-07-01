//
//  AFLoadingViewController.h
//  AppFirst
//
//  Created by appfirst on 7/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFLoadingViewController : UIViewController {
	IBOutlet UIActivityIndicatorView* indicator;

}

@property (nonatomic, retain) UIActivityIndicatorView* indicator;

@end
