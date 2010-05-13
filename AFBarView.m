//
//  AFBarView.m
//  AppFirst
//
//  Created by appfirst on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFBarView.h"
#import "config.h"


@implementation AFBarView


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
	CGContextSetRGBFillColor(context, 88.0/255.0, 164.0/255.0, 59.0/255.0, 1);// green color, half transparent
	CGContextFillRect(context, CGRectMake(0, 0, AF_BAR_WIDTH, AF_BAR_HEIGHT));
}


- (void)dealloc {
    [super dealloc];
}


@end
