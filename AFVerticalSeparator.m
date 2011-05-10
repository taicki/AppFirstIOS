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

#import "AFVerticalSeparator.h"


@implementation AFVerticalSeparator


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(contextRef, 168/255, 168/255, 168/255, 0.7);
    CGContextSetLineWidth(contextRef, 2);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(contextRef, self.frame.size.width / 2 - 1 , 0);
    CGContextAddLineToPoint(contextRef, self.frame.size.width / 2 -1 , self.frame.size.height);
    CGContextStrokePath(contextRef);
	
}


- (void)dealloc {
    [super dealloc];
}


@end
