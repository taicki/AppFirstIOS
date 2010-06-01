//
//  AFTitleView.h
//  AppFirst
//
//  Created by appfirst on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFTitleView : UIView {
	IBOutlet UILabel* titleLabel;
	IBOutlet UILabel* timeLabel;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* timeLabel;


@end
