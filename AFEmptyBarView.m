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
#import "AFEmptyBarView.h"
#import "config.h"


@implementation AFEmptyBarView


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
	CGContextSetRGBFillColor(context, 217.0/255.0, 238.0/255.0, 208.0/255.0, 1);// green color, half transparent
	CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, AF_BAR_HEIGHT));
	CGContextSetRGBStrokeColor(context, 168/255, 168/255, 168/255, 0.3);
	CGContextStrokeRect(context, CGRectMake(0, 0, self.frame.size.width, AF_BAR_HEIGHT));
}


- (void)dealloc {
    [super dealloc];
}


@end
