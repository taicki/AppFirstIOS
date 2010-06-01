//
//  AFTitleView.m
//  AppFirst
//
//  Created by appfirst on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFTitleView.h"


@implementation AFTitleView
@synthesize titleLabel, timeLabel;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		
		self.titleLabel = [[[UILabel alloc] initWithFrame: CGRectMake(0, 0, 150, 30)] autorelease];
		
		self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
		self.titleLabel.textColor = [UIColor whiteColor];
		[self.titleLabel setBackgroundColor:[UIColor clearColor]];
		self.titleLabel.userInteractionEnabled = NO;
		
		
		self.timeLabel = [[[UILabel alloc] initWithFrame: CGRectMake(90, 15, 150, 10)] autorelease];
		
		self.timeLabel.font = [UIFont systemFontOfSize:9];
		self.timeLabel.textColor = [UIColor whiteColor];
		[self.timeLabel setBackgroundColor:[UIColor clearColor]];
		self.timeLabel.userInteractionEnabled = NO;
		
		[self addSubview:self.titleLabel];
		[self addSubview:self.timeLabel];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
}


- (void)dealloc {
	[self.titleLabel release];
	[self.timeLabel release];
    [super dealloc];
}


@end
