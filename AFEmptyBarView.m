//
//  AFEmptyBarView.m
//  AppFirst
//
//  Created by appfirst on 5/12/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AFEmptyBarView.h"
#import "config.h"


@implementation AFEmptyBarView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 217.0/255.0, 238.0/255.0, 208.0/255.0, 1);// green color, half transparent
	CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, AF_BAR_HEIGHT));
	CGContextSetRGBStrokeColor(context, 168/255, 168/255, 168/255, 0.3);
	CGContextStrokeRect(context, CGRectMake(0, 0, self.frame.size.width, AF_BAR_HEIGHT));
}


- (void)dealloc {
    [super dealloc];
}


@end
