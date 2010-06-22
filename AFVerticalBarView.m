//
//  AFVerticalBarView.m
//  AppFirst
//
//  Created by appfirst on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFVerticalBarView.h"
#import "config.h"


@implementation AFVerticalBarView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 88.0/255.0, 164.0/255.0, 59.0/255.0, 1);// green color, half transparent
	CGContextFillRect(context, CGRectMake((self.frame.size.width - AF_VERTICAL_BAR_WIDTH) / 2, 0, 
										  AF_VERTICAL_BAR_WIDTH, self.frame.size.height));
}


- (void)dealloc {
    [super dealloc];
}


@end
