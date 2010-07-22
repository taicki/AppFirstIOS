//
//  AFVerticalSeparator.m
//  AppFirst
//
//  Created by appfirst on 6/22/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AFVerticalSeparator.h"


@implementation AFVerticalSeparator


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(contextRef, 168/255, 168/255, 168/255, 0.7);
    CGContextSetLineWidth(contextRef, 2);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(contextRef, self.frame.size.width / 2 - 1 , 0);
    CGContextAddLineToPoint(contextRef, self.frame.size.width / 2 -1 , self.frame.size.height);
    CGContextStrokePath(contextRef);
	
}


- (void)dealloc {
    [super dealloc];
}


@end
