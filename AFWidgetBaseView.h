//
//  AFWidgetBaseView.h
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFWidgetBaseView : UIView {
	UILabel* widgetNameLabel;
	NSString* widgetNameLabelText;
}

@property (nonatomic, retain) UILabel* widgetNameLabel;
@property (nonatomic, retain) NSString* widgetNameLabelText;


@end
