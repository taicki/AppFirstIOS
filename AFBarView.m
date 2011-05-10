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

#import "AFBarView.h"
#import "config.h"


@implementation AFBarView
@synthesize resourceValue;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (resourceValue > 90) {
        CGContextSetRGBFillColor(context, 255.0/255.0, 0.0/255.0, 0.0/255.0, 1);// green color, half transparent
    } else {
        CGContextSetRGBFillColor(context, 88.0/255.0, 164.0/255.0, 59.0/255.0, 1);// green color, half transparent
    }
	CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, AF_BAR_HEIGHT));
}

- (void)dealloc {
    [super dealloc];
}


@end
