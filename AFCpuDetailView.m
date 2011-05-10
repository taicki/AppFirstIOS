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

#import "AFCpuDetailView.h"
#import "AFBarView.h"
#import "AFEmptyBarView.h"
#import "AFVerticalBarView.h"
#import "config.h"
#import "AppHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation AFCpuDetailView
@synthesize cpuDetail, cpuLoadArray, cpuValue;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		//[self setBackgroundColor:[UIColor lightGrayColor]];
        // Initialization code
    }
	
	// mock up the data for test
	self.cpuDetail = @"4 cores at 2400 MHZ";
	self.cpuValue = 40;
	self.cpuLoadArray = [[[NSArray alloc] initWithObjects: [NSNumber numberWithInt:30], [NSNumber numberWithInt:40], [NSNumber numberWithInt:30], [NSNumber numberWithInt:100], nil] autorelease];
	
    return self;
}

- (void) createCpuOverview: (double) topPadding {
	double rowHeight = 15;
	double usageLabelWidth = 40;
	double titleRowHeight = 20;
	double spacing = 4.0;
	double leftPadding = 5;
	
	UILabel* cpuWidgetTitle = [[UILabel alloc] initWithFrame: CGRectMake(leftPadding, topPadding, self.frame.size.width, titleRowHeight)];
	cpuWidgetTitle.font = [UIFont systemFontOfSize:IPAD_TITLE_NORMAL_FONTSIZE];
	[cpuWidgetTitle setBackgroundColor:[UIColor clearColor]];
	cpuWidgetTitle.text = self.cpuDetail;

	topPadding += titleRowHeight;
	UILabel* cpuOverallLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, usageLabelWidth, rowHeight)];
	[cpuOverallLabel setBackgroundColor:[UIColor clearColor]];
	cpuOverallLabel.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
	cpuOverallLabel.text = [NSString stringWithFormat:@"Usage:"];
	
	leftPadding += (usageLabelWidth + spacing);
	
	CGRect emptyBarFrame = CGRectMake(leftPadding, topPadding, AF_BAR_WIDTH, AF_BAR_HEIGHT);
	AFEmptyBarView* emptyBarView = [[AFEmptyBarView alloc] initWithFrame: emptyBarFrame];
	
	
	CGRect solidBarFrame = CGRectMake(leftPadding, topPadding, self.cpuValue * AF_BAR_WIDTH / 100, AF_BAR_HEIGHT);
	AFBarView* solidBarView = [[AFBarView alloc] initWithFrame: solidBarFrame];
	
	leftPadding += (AF_BAR_WIDTH + spacing);
	UILabel* cpuValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, usageLabelWidth, rowHeight)];
	cpuValueLabel.text = [NSString stringWithFormat:@"%0.1f%@", self.cpuValue, @"%"];
	cpuValueLabel.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
	[cpuValueLabel setBackgroundColor:[UIColor clearColor]];
	
	[self addSubview:cpuWidgetTitle];
	[self addSubview:cpuOverallLabel];
	[self addSubview:emptyBarView];
	[self addSubview:solidBarView];
	[self addSubview:cpuValueLabel];
	
	
	[cpuWidgetTitle release];
	[cpuOverallLabel release];
	[emptyBarView release];
	[solidBarView release];
	[cpuValueLabel release];
}


- (void) createCpuCoreDetailView: (double) offset {
	double cpuCoreWidth = self.frame.size.width / [self.cpuLoadArray count];
	double rowHeight = 15;
	double padding = 5;
	
	for (int i = 0; i < [self.cpuLoadArray count]; i++) {
		double coreValue = [[self.cpuLoadArray objectAtIndex:i] doubleValue];
		double topPadding = (100 - coreValue) * AF_VERTICAL_BAR_HEIGHT / 100 + offset + padding;
		double leftPadding = cpuCoreWidth * i;

		UILabel* coreValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, cpuCoreWidth, rowHeight)];
		coreValueLabel.text = [NSString stringWithFormat:@"%0.0f%@", coreValue, @"%"];
		coreValueLabel.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
		coreValueLabel.textAlignment = UITextAlignmentCenter;
		[coreValueLabel setBackgroundColor:[UIColor clearColor]];
		
		CGRect solidBarFrame = CGRectMake(leftPadding, topPadding + rowHeight, cpuCoreWidth, 
										  coreValue * AF_VERTICAL_BAR_HEIGHT / 100 );
		AFVerticalBarView* solidBarView = [[AFVerticalBarView alloc] initWithFrame: solidBarFrame];
		
		
		
		UILabel* coreNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, AF_VERTICAL_BAR_HEIGHT + offset + rowHeight + padding, cpuCoreWidth, rowHeight)];
		coreNameLabel.text = [NSString stringWithFormat:@"core%d", i];
		coreNameLabel.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
		coreNameLabel.textAlignment = UITextAlignmentCenter;
		[coreNameLabel setBackgroundColor:[UIColor clearColor]];
		
		
		[self addSubview:solidBarView];
		[self addSubview:coreValueLabel];
		[self addSubview:coreNameLabel];
		
		[solidBarView release];
		[coreValueLabel release];
		[coreNameLabel release];
	
	}
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[AppHelper backgroundGradientColor1] CGColor], (id)[[AppHelper backgroundGradientColor2] CGColor], nil];
	[self.layer insertSublayer:gradient atIndex:0];
	
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = YES;
	
	double topPadding = IPAD_WIDGET_INTERNAL_PADDING;
	double labelHeight = 18;
	
	UILabel* widgetNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, IPAD_WIDGET_INTERNAL_PADDING, 
																		 self.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING * 2, 
																		  labelHeight)];
	[widgetNameLabel setBackgroundColor:[UIColor clearColor]];
	widgetNameLabel.text = @"CPU";
	[self addSubview:widgetNameLabel];
	[widgetNameLabel release];
	
	topPadding += (labelHeight + IPAD_WIDGET_INTERNAL_PADDING / 2);
	
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(contextRef, 0.9, 0.9, 0.9, 0.9);
    CGContextSetLineWidth(contextRef, 1.5);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(contextRef, IPAD_WIDGET_INTERNAL_PADDING, topPadding);
    CGContextAddLineToPoint(contextRef, self.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING, topPadding);
    CGContextStrokePath(contextRef);
	
	CGContextSetShadow(contextRef, CGSizeMake(4, 4), 5);
		
	topPadding += (IPAD_WIDGET_INTERNAL_PADDING / 2);
	
	[self createCpuOverview:topPadding];
	topPadding += (30 + IPAD_WIDGET_INTERNAL_PADDING);
	
	//[self createCpuCoreDetailView:topPadding];
}


- (void)dealloc {
	[cpuDetail release];
	[cpuLoadArray release];
    [super dealloc];
}


@end
