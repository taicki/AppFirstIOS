//
//  AV_GenericTableCell.m
//  AppFirst
//
//  Created by appfirst on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AV_GenericTableCell.h"
#import "AFEmptyBarView.h"
#import "AFBarView.h"
#import "config.h"

@implementation AV_GenericTableCell
@synthesize data;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void) createResourceNameLabel: (int)height {
    double padding = 5;
    
    UILabel* widgetNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(padding, padding, 
                                                                          self.frame.size.width - padding * 2, 
																		  height)];
	[widgetNameLabel setBackgroundColor:[UIColor clearColor]];
    widgetNameLabel.font = [UIFont boldSystemFontOfSize:IPAD_TITLE_NORMAL_FONTSIZE];
	widgetNameLabel.text = [data resourceName];
	[self addSubview:widgetNameLabel];
	[widgetNameLabel release];
}

- (void) createResourceDetailLabel: (int) maxHeight {
    double padding = 5;
    UILabel* widgetValueLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.frame.size.width / 2 , padding, 
                                                                          (self.frame.size.width - padding * 2) / 2 , 
                                                                          maxHeight)];
    widgetValueLabel.textAlignment = UITextAlignmentRight;
    widgetValueLabel.text = [data resourceDetail];
    widgetValueLabel.font = [UIFont boldSystemFontOfSize:IPAD_TITLE_NORMAL_FONTSIZE];
    [self addSubview:widgetValueLabel];
    [widgetValueLabel release];
}

- (void) createResourcePieRow: (NSString *) titleText paddingTop: (int) paddingTop resourceValue: (double) resourceValue {
    CGSize maximumLabelSize = CGSizeMake( self.frame.size.width - AF_BAR_HEIGHT * 2 - IPAD_WIDGET_INTERNAL_PADDING * 2,AF_BAR_HEIGHT * 3);
    CGSize expectedLabelSize = [titleText sizeWithFont:[UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE]
                              constrainedToSize:maximumLabelSize 
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, 
                                                                    paddingTop + IPAD_WIDGET_INTERNAL_PADDING, expectedLabelSize.width, AF_BAR_HEIGHT)];
    titleLabel.text = titleText;
    titleLabel.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
    [self addSubview:titleLabel];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel release];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(contextRef,217.0/255.0, 238.0/255.0, 208.0/255.0, 1);
	CGContextSetRGBStrokeColor(contextRef, 168/255, 168/255, 168/255, 0.3);
    double radius = IPHONE_TABLE_ROW_HEIGHT;
    double paddingLeft = self.frame.size.width - radius * 2 - IPAD_WIDGET_INTERNAL_PADDING * 2;
    paddingTop += IPAD_WIDGET_INTERNAL_PADDING;
	
	// Draw a circle (filled)
	CGContextFillEllipseInRect(contextRef, CGRectMake(paddingLeft, paddingTop, radius * 2, radius * 2));
	
	// Draw a circle (border only)
	CGContextStrokeEllipseInRect(contextRef, CGRectMake(paddingLeft, paddingTop, radius * 2, radius * 2));
    double span = resourceValue * PI * 2 / 100;
    double centerX = paddingLeft + radius ;
	double centerY = paddingTop + radius ;
		
    int currentRadius = 0;
    CGContextSetRGBStrokeColor(contextRef, 1, 1, 1, 1);
    CGContextMoveToPoint(contextRef, centerX, centerY);
    CGContextAddLineToPoint(contextRef, centerX + cos(currentRadius)* radius, centerY + sin(currentRadius) * radius);     
    CGContextStrokePath(contextRef);
		
    if (resourceValue > 90) {
        CGContextSetRGBFillColor(contextRef, 255.0/255.0, 0.0/255.0, 0.0/255.0, 1);
    } else {
        CGContextSetRGBFillColor(contextRef, 88.0/255.0, 164.0/255.0, 59.0/255.0, 1);
    }
    
    CGContextMoveToPoint(contextRef, centerX, centerY);
    CGContextAddArc(contextRef, centerX, centerY, radius, currentRadius, currentRadius + span, 0);
		
    CGContextClosePath(contextRef); 
    CGContextFillPath(contextRef);

}

- (void) createResourceBarRow: (NSString *) titleText paddingTop: (int) paddingTop resourceValue: (double) resourceValue  {
    double padding = 5;
    NSString* longestPercentageValue = @"100.0%";
    CGSize maximumLabelSize = CGSizeMake(50,AF_BAR_HEIGHT);
    
    CGSize expectedLabelSize = [longestPercentageValue sizeWithFont:[UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE]
                                               constrainedToSize:maximumLabelSize 
                                                   lineBreakMode:UILineBreakModeWordWrap]; 
    int resourceValueWidth = expectedLabelSize.width;
    
    int leftLabelWidth = 60;
    int totalWidth = self.frame.size.width;
    int barWidth = totalWidth - leftLabelWidth - resourceValueWidth - padding * 3;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 
                                                                    paddingTop + padding, leftLabelWidth, AF_BAR_HEIGHT)];
    titleLabel.text = titleText;
    titleLabel.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
    [self addSubview:titleLabel];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel release];
    
	CGRect emptyBarFrame = CGRectMake(padding * 2 + leftLabelWidth, padding + paddingTop, barWidth, AF_BAR_HEIGHT);
	AFEmptyBarView* emptyBarView = [[AFEmptyBarView alloc] initWithFrame: emptyBarFrame];
    [self addSubview:emptyBarView];
    [emptyBarView release];
	
	CGRect solidBarFrame = CGRectMake(padding * 2 + leftLabelWidth, padding + paddingTop,  
                                      barWidth * resourceValue / 100, AF_BAR_HEIGHT);
    AFBarView* solidBarView = [[AFBarView alloc] initWithFrame: solidBarFrame];
	[solidBarView setResourceValue:resourceValue];
    [self addSubview:solidBarView];
    [solidBarView release];
	
	UILabel* valueText = [[UILabel alloc] initWithFrame:CGRectMake(totalWidth - padding - resourceValueWidth, 
                                                                       paddingTop + padding, resourceValueWidth, AF_BAR_HEIGHT)];
	valueText.text = [NSString stringWithFormat:@"%0.1f%@", resourceValue, @"%"];
    valueText.font = [UIFont systemFontOfSize:IPAD_TEXT_NORMAL_FONTSIZE];
    valueText.textAlignment = UITextAlignmentRight;
	[valueText setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:valueText];
    [valueText release];

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    double padding = 5;
    CGSize maximumLabelSize = CGSizeMake((self.frame.size.width - padding * 2)/2,9999);
    CGSize expectedLabelSize = [[data resourceName] sizeWithFont:[UIFont systemFontOfSize:IPAD_TITLE_NORMAL_FONTSIZE]
                                               constrainedToSize:maximumLabelSize 
                                                   lineBreakMode:UILineBreakModeWordWrap];
    int currentHeight = expectedLabelSize.height;
    [self createResourceNameLabel:currentHeight];
    [self createResourceDetailLabel:currentHeight];
    
    if ([[data resourceValue] doubleValue] > 0) {
        if ([data renderOption] == AF_GraphCell) {
            [self createResourceBarRow: @"All" paddingTop: currentHeight + 10 resourceValue: [[data resourceValue] doubleValue]];
        } else if ([data renderOption] == AF_ExtendedGraphCell) {
            [self createResourceBarRow: @"All" paddingTop: currentHeight + 10 resourceValue: [[data resourceValue] doubleValue]];
        }
        
        currentHeight += IPHONE_TABLE_ROW_HEIGHT;
    }
        
    if ([data extra] != nil && [[data extra] count] > 0 ) {
        NSArray* keys = [[data extra] allKeys];
        
        for (int cnt = 0; cnt < [keys count]; cnt++) {
            NSString* key = [keys objectAtIndex:cnt];
            NSLog(@"%@", key);
            if ([data graphOption] == AF_Bar) {
                [self createResourceBarRow: key paddingTop: currentHeight + 10 resourceValue: [[[data extra] objectForKey:key] doubleValue]];
                currentHeight += IPHONE_TABLE_ROW_HEIGHT;
            } else {
                [self createResourcePieRow: key paddingTop: currentHeight + 10 resourceValue: [[[data extra] objectForKey:key] doubleValue]];
                currentHeight += IPHONE_TABLE_ROW_HEIGHT * 3;
            }
        }
    }
}


- (void)dealloc
{
    [data release];
    [super dealloc];
}

@end
