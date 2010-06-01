//
//  AFUIView.m
//  AppFirst
//
//  Created by appfirst on 5/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFUIView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AFUIView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect

{
	//self.layer.borderWidth = 1;
	//self.layer.borderColor =  [[UIColor grayColor] CGColor];
	//self.layer.cornerRadius = 8;

}


- (void)dealloc {
    [super dealloc];
	
}


@end
