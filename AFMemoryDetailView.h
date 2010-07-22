//
//  AFMemoryDetailView.h
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFWidgetBaseView.h"


@interface AFMemoryDetailView : AFWidgetBaseView
{
	NSString* memoryStatus;
	double memoryTotal;
	double memoryValue;
	//UILabel* widgetNameLabel;
	
}

@property (nonatomic, retain) NSString* memoryStatus;
@property (nonatomic, readwrite) double memoryTotal;
@property (nonatomic, readwrite) double memoryValue;
//@property (nonatomic, retain) UILabel* widgetNameLabel;

@end
