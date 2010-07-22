//
//  DiskLegendView.m
//  AppFirst
//
//  Created by appfirst on 5/12/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AFDiskLegendView.h"
#import "config.h"


@implementation AFDiskLegendView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(contextRef, 88.0/255.0, 164.0/255.0, 59.0/255.0, 1);
	CGContextSetRGBStrokeColor(contextRef, 168/255, 168/255, 168/255, 0.3);
	
	double paddingLeft = 5;
	CGContextFillRect(contextRef, CGRectMake(paddingLeft, 5, AF_LEGEND_WIDTH, AF_LEGEND_WIDTH));
	CGContextStrokeRect(contextRef, CGRectMake(paddingLeft, 5, AF_LEGEND_WIDTH, AF_LEGEND_WIDTH));
	
    UILabel* usedLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, 0, 50, 20)];
	usedLabel.numberOfLines = 0;
	usedLabel.text = @"used";
	usedLabel.font = [UIFont systemFontOfSize:9.0];
	usedLabel.backgroundColor = [UIColor clearColor];
	usedLabel.textAlignment = UITextAlignmentCenter;
	[self addSubview:usedLabel];
	
	paddingLeft += 60;
	
	
	CGContextSetRGBFillColor(contextRef, 217.0/255.0, 238.0/255.0, 208.0/255.0, 1);
	CGContextFillRect(contextRef, CGRectMake(paddingLeft, 5, AF_LEGEND_WIDTH, AF_LEGEND_WIDTH));
	CGContextStrokeRect(contextRef, CGRectMake(paddingLeft, 5, AF_LEGEND_WIDTH, AF_LEGEND_WIDTH));

	
    UILabel* freeLabel = [[UILabel alloc] initWithFrame: CGRectMake(paddingLeft, 0, 50, 20)];
	freeLabel.numberOfLines = 0;
	freeLabel.text = @"free";
	freeLabel.font = [UIFont systemFontOfSize:9.0];
	freeLabel.backgroundColor = [UIColor clearColor];
	freeLabel.textAlignment = UITextAlignmentCenter;
	[self addSubview:freeLabel];
	
	[usedLabel release];
	[freeLabel release];
	
}


- (void)dealloc {
    [super dealloc];
}


@end
