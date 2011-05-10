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

#import "AFWidgetBaseView.h"
#import <QuartzCore/QuartzCore.h>
#import "config.h"
#import "AppHelper.h"


@implementation AFWidgetBaseView
@synthesize widgetNameLabel, widgetNameLabelText;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		//[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)initBackground {
	CAGradientLayer *gradient = [CAGradientLayer layer];
    float frameHeight = IPAD_SCREEN_WIDTH;
    if (self.frame.size.height > IPAD_SCREEN_WIDTH) {
        frameHeight = self.frame.size.height;
    }
	gradient.frame = CGRectMake(0, 0, IPAD_SCREEN_WIDTH, frameHeight);
	gradient.colors = [NSArray arrayWithObjects:(id)[[AppHelper backgroundGradientColor1] CGColor], (id)[[AppHelper backgroundGradientColor2] CGColor], nil];
	
	[self.layer insertSublayer:gradient atIndex:0];
	
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = YES;
	
	double topPadding = IPAD_WIDGET_INTERNAL_PADDING;
	double labelHeight = 18;
	
	UILabel* aWidgetNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, IPAD_WIDGET_INTERNAL_PADDING, 
																		   self.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING * 2, 
																		   labelHeight)];
	[aWidgetNameLabel setBackgroundColor:[UIColor clearColor]];
    [aWidgetNameLabel setFont:[UIFont systemFontOfSize:IPAD_TABLE_CELL_BIG_FONTSIZE]];
	[self addSubview:aWidgetNameLabel];
	self.widgetNameLabel = aWidgetNameLabel;
	self.widgetNameLabel.text = widgetNameLabelText;
	[aWidgetNameLabel release];
	
	topPadding += (labelHeight + IPAD_WIDGET_INTERNAL_PADDING / 2);
	
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(contextRef, 0.9, 0.9, 0.9, 0.9);
    CGContextSetLineWidth(contextRef, 1.5);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(contextRef, IPAD_WIDGET_INTERNAL_PADDING, topPadding);
    CGContextAddLineToPoint(contextRef, self.frame.size.width - IPAD_WIDGET_INTERNAL_PADDING, topPadding);
    //CGContextStrokePath(contextRef);
	
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
	[self initBackground];
}



- (void)dealloc {
	[widgetNameLabel release];
	[widgetNameLabelText release];
    [super dealloc];
}


@end
