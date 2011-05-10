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

#import "AFMemoryDetailView.h"
#import <QuartzCore/QuartzCore.h>
#import "config.h"
#import "AFBarView.h"
#import "AFEmptyBarView.h"
#import "AFVerticalBarView.h"
#import "AppHelper.h"

@implementation AFMemoryDetailView
@synthesize memoryStatus, memoryValue, memoryTotal;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		//[self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
	
	//self.memoryStatus = @"Total: 4GB";
	//self.memoryValue = 139;
	//self.memoryTotal = 200;
    return self;
}

- (void) createMemoryOverview: (double) topPadding {
	double rowHeight = 15;
	double usageLabelWidth = 40;
	double titleRowHeight = 20;
	double spacing = 4.0;
	double leftPadding = 5;
	
	UILabel* memoryWidgetTitle = [[UILabel alloc] initWithFrame: CGRectMake(leftPadding, topPadding, self.frame.size.width, titleRowHeight)];
	memoryWidgetTitle.font = [UIFont systemFontOfSize:IPAD_TITLE_NORMAL_FONTSIZE];
	[memoryWidgetTitle setBackgroundColor:[UIColor clearColor]];
	memoryWidgetTitle.text = [NSString stringWithFormat:@"Total: %.0f MB", memoryTotal / 1024 / 1024];
	
	topPadding += titleRowHeight;
	UILabel* memoryOverallLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, usageLabelWidth, rowHeight)];
	[memoryOverallLabel setBackgroundColor:[UIColor clearColor]];
	memoryOverallLabel.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
	memoryOverallLabel.text = [NSString stringWithFormat:@"Usage:"];
	
	leftPadding += (usageLabelWidth + spacing);
	
	CGRect emptyBarFrame = CGRectMake(leftPadding, topPadding, AF_BAR_WIDTH, AF_BAR_HEIGHT);
	AFEmptyBarView* emptyBarView = [[AFEmptyBarView alloc] initWithFrame: emptyBarFrame];
	
	
	CGRect solidBarFrame = CGRectMake(leftPadding, topPadding, self.memoryValue / self.memoryTotal * AF_BAR_WIDTH, AF_BAR_HEIGHT);
	AFBarView* solidBarView = [[AFBarView alloc] initWithFrame: solidBarFrame];
	
	leftPadding += (AF_BAR_WIDTH + spacing);
	UILabel* memoryValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, usageLabelWidth, rowHeight)];
	memoryValueLabel.text = [NSString stringWithFormat:@"%0.1f%@", self.memoryValue / self.memoryTotal * 100, @"%"];
	memoryValueLabel.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
	[memoryValueLabel setBackgroundColor:[UIColor clearColor]];
	
	[self addSubview:memoryWidgetTitle];
	[self addSubview:memoryOverallLabel];
	[self addSubview:emptyBarView];
	[self addSubview:solidBarView];
	[self addSubview:memoryValueLabel];
	
	
	[memoryWidgetTitle release];
	[memoryOverallLabel release];
	[emptyBarView release];
	[solidBarView release];
	[memoryValueLabel release];
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	//[super drawRect];
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[AppHelper backgroundGradientColor1] CGColor], (id)[[AppHelper backgroundGradientColor2] CGColor], nil];
	
	[self.layer insertSublayer:gradient atIndex:0];
	
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = YES;
	
	double topPadding = IPAD_WIDGET_INTERNAL_PADDING;
	double labelHeight = 18;
	
	UILabel* aWidgetNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, IPAD_WIDGET_INTERNAL_PADDING, 
																		   self.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING * 2, 
																		   labelHeight)];
	[aWidgetNameLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:aWidgetNameLabel];
	self.widgetNameLabel = aWidgetNameLabel;
	
	[aWidgetNameLabel release];
	
	topPadding += (labelHeight + IPAD_WIDGET_INTERNAL_PADDING / 2);
	
	
	
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(contextRef, 0.9, 0.9, 0.9, 0.9);
    CGContextSetLineWidth(contextRef, 1.5);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(contextRef, IPAD_WIDGET_INTERNAL_PADDING, topPadding);
    CGContextAddLineToPoint(contextRef, self.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING, topPadding);
    CGContextStrokePath(contextRef);
	
	self.widgetNameLabel.text = @"Memory";
	
	topPadding += (IPAD_WIDGET_INTERNAL_PADDING / 2);
	
	[self createMemoryOverview:topPadding];
}

- (void)initBackground {
		
}


- (void)dealloc {
	[memoryStatus release];
	//[widgetNameLabel release];
    [super dealloc];
}


@end
