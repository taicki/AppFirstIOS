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
