/*
 * Copyright 2009-2011 AppFirst, Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AFDiskView.h"
#import "config.h"
#import <math.h>

@implementation AFDiskView

@synthesize diskValues, diskTotals, diskNames;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
		
		if (self.diskValues == nil) {
			self.diskValues = [[[NSMutableArray alloc] init] autorelease];
			self.diskTotals = [[[NSMutableArray alloc] init] autorelease];
		}
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	double radius = self.frame.size.height / 2.5;
	double paddingLeft = 5;
	double paddingTop = 5;
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
	
    for (int i = 0; i < [diskTotals count]; i++) {
		double diskValue = [[diskValues objectAtIndex:i] doubleValue];
		double diskTotal = [[diskTotals objectAtIndex:i] doubleValue];
		valueSum += diskValue;
		totalSum += diskTotal;
	}
	
	double currentRadius = 0;
	for (int i = 0; i < [diskValues count]; i++) {
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
	}
}


- (void)dealloc {
	[diskNames release];
	[diskValues release];
	[diskTotals release];
	
    [super dealloc];
}


@end
