//
//  AFTitleView.m
//  AppFirst
//
//  Created by appfirst on 5/27/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AFTitleView.h"
#import "AppHelper.h"
#import "config.h"


@implementation AFTitleView
@synthesize titleLabel, timeLabel;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		self.titleLabel = [[[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width / 2, frame.size.height)] autorelease];
		self.timeLabel = [[[UILabel alloc] initWithFrame: CGRectMake(frame.size.width / 3, frame.size.height / 2, frame.size.width / 3 * 2, frame.size.height / 3)] autorelease];
		
		if (![AppHelper isIPad]) {
			self.titleLabel.font = [UIFont boldSystemFontOfSize:IPHONE_TITLE_BIG_FONTSIZE];
			self.timeLabel.font = [UIFont boldSystemFontOfSize:IPHONE_TITLE_NORMAL_FONTSIZE];
		} else {
			//self.titleLabel = [[[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width / 2, frame.size.height)] autorelease];
			self.titleLabel.font = [UIFont boldSystemFontOfSize:IPAD_TITLE_BIG_FONTSIZE];
			//self.timeLabel = [[[UILabel alloc] initWithFrame: CGRectMake(frame.size.width / 3, frame.size.height / 2, frame.size.width / 3 * 2, frame.size.height / 3)] autorelease];
			self.timeLabel.font = [UIFont boldSystemFontOfSize:IPAD_TITLE_NORMAL_FONTSIZE];
		}
		
		self.titleLabel.textColor = [UIColor grayColor];
		[self.titleLabel setBackgroundColor:[UIColor clearColor]];
		self.titleLabel.userInteractionEnabled = NO;
		
		self.timeLabel.textColor = [UIColor grayColor];
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
