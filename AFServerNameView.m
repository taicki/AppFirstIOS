//
//  AFServerNameView.m
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFServerNameView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppHelper.h"
#import "config.h"

@implementation AFServerNameView
@synthesize osType, serverName;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)[[AppHelper backgroundGradientColor1] CGColor], (id)[[AppHelper backgroundGradientColor2] CGColor], nil];
	
	[self.layer insertSublayer:gradient atIndex:0];
	
	
	UIImage* theImage;
	NSString* path;

	
	if ([self.osType isEqualToString:@"Linux"]) {
		path = [[NSBundle mainBundle] pathForResource:@"linux-icon" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	} else {
		path = [[NSBundle mainBundle] pathForResource:@"windows-icon" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	}
	
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(IPAD_WIDGET_INTERNAL_PADDING, IPAD_WIDGET_INTERNAL_PADDING, 35, 35)];
	imageview.image = theImage;
	[self addSubview:imageview];  
	[imageview release];
		
	self.layer.cornerRadius = 5;
	self.layer.masksToBounds = YES;
	
	UILabel* serverNameLabel = [[UILabel alloc] initWithFrame: CGRectMake(IPAD_WIDGET_INTERNAL_PADDING * 2 + 35, 
																		  IPAD_WIDGET_INTERNAL_PADDING, self.frame.size.width - 
																		  IPAD_WIDGET_INTERNAL_PADDING * 3 - 35,
																		  (self.frame.size.height - IPAD_WIDGET_INTERNAL_PADDING * 2))];
	serverNameLabel.font = [UIFont systemFontOfSize:15];
	serverNameLabel.numberOfLines = 0;
	//serverNameLabel.textAlignment = UITextAlignmentCenter;
	[serverNameLabel setBackgroundColor: [UIColor clearColor]];
	serverNameLabel.text = [NSString stringWithFormat:@"%@",  self.serverName];
	[self addSubview:serverNameLabel];
	[serverNameLabel release];
	
	
	
}


- (void)dealloc {
	[serverName release];
	[osType release];
    [super dealloc];
}


@end
