//
//  AFDiskView.m
//  AppFirst
//
//  Created by appfirst on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFDiskView.h"
#import "config.h"
#import <math.h>

@implementation AFDiskView

@synthesize diskValues, diskTotals, diskNames;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	double radius = 50;
	double paddingLeft = 25;
	double paddingTop = 20;
	
	double valueSum = 0;
	double totalSum = 0;
	
	double centerX = paddingLeft + radius ;
	double centerY = paddingTop + radius ;
	
	
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
	
	
	CGContextSetRGBFillColor(contextRef,217.0/255.0, 238.0/255.0, 208.0/255.0, 1);
	CGContextSetRGBStrokeColor(contextRef, 168/255, 168/255, 168/255, 0.3);
	
	// Draw a circle (filled)
	CGContextFillEllipseInRect(contextRef, CGRectMake(paddingLeft, paddingTop, radius * 2, radius * 2));
	
	// Draw a circle (border only)
	CGContextStrokeEllipseInRect(contextRef, CGRectMake(paddingLeft, paddingTop, radius * 2, radius * 2));
	
	 
	for (int i = 0; i < [diskNames count]; i++) {
		double diskValue = [[diskValues objectAtIndex:i] doubleValue];
		double diskTotal = [[diskTotals objectAtIndex:i] doubleValue];
		
		valueSum += diskValue;
		totalSum += diskTotal;
		
		
	}
	
	double currentRadius = 0;
	double textMaxWidth = 70;
	double textMaxHeight = 50;
	for (int i = 0; i < [diskNames count]; i++) {
		double diskValue = [[diskValues objectAtIndex:i] doubleValue];
		double diskTotal = [[diskTotals objectAtIndex:i] doubleValue];
		double span = diskValue / totalSum * PI * 2;
		
		
		CGContextSetRGBStrokeColor(contextRef, 1, 1, 1, 1);
		CGContextMoveToPoint(contextRef, centerX, centerY);
		CGContextAddLineToPoint(contextRef, centerX + cos(currentRadius)* radius, centerY + sin(currentRadius) * radius);     
		CGContextStrokePath(contextRef);
		
		
		CGContextSetRGBFillColor(contextRef, 88.0/255.0, 164.0/255.0, 59.0/255.0, 1);
		CGContextMoveToPoint(contextRef, centerX, centerY);
		CGContextAddArc(contextRef, centerX, centerY, radius, currentRadius, currentRadius + span, 0);
		
		CGContextClosePath(contextRef); 
		CGContextFillPath(contextRef);
		
		double totalSpan = (diskTotal / totalSum) * 2 * PI;
		
		currentRadius += totalSpan;
		
		
		CGRect textFrame = CGRectMake(centerX + cos(currentRadius - totalSpan / 2)* radius * 1 - textMaxWidth / 2, 
									  centerY + sin(currentRadius - totalSpan / 2) * radius * 1 - textMaxHeight / 2, textMaxWidth, textMaxHeight
									  );
		UILabel* diskView = [[UILabel alloc] initWithFrame:textFrame];
		diskView.numberOfLines = 0;
		diskView.text = [diskNames objectAtIndex:i];
		diskView.font = [UIFont systemFontOfSize:9.0];
		diskView.backgroundColor = [UIColor clearColor];
		diskView.textAlignment = UITextAlignmentCenter;
		[self addSubview:diskView];
		
		[diskView release];
		
	}
	
	
}


- (void)dealloc {
	[diskNames release];
	[diskValues release];
	[diskTotals release];
	
    [super dealloc];
}


@end
