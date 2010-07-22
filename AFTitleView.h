//
//  AFTitleView.h
//  AppFirst
//
//  Created by appfirst on 5/27/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFTitleView : UIView {
	UILabel* titleLabel;
	UILabel* timeLabel;
}

@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UILabel* timeLabel;


@end
