//
//  DiskLegendView.m
//  AppFirst
//
//  Created by appfirst on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DiskLegendView.h"


@implementation DiskLegendView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	double paddingLeft = 5;
	
    UILabel* usedLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, 0, 50, 20)];
	usedLabel.numberOfLines = 0;
	usedLabel.text = @"used";
	usedLabel.font = [UIFont systemFontOfSize:9.0];
	usedLabel.backgroundColor = [UIColor clearColor];
	usedLabel.textAlignment = UITextAlignmentCenter;
	[self addSubview:usedLabel];
	
	paddingLeft += 100;
	
    UILabel* freeLabel = [[UILabel alloc] initWithFrame: CGRectMake(paddingLeft, 0, 50, 20)];
	freeLabel.numberOfLines = 0;
	freeLabel.text = @"free";
	freeLabel.font = [UIFont systemFontOfSize:9.0];
	freeLabel.backgroundColor = [UIColor clearColor];
	freeLabel.textAlignment = UITextAlignmentCenter;
	[self addSubview:freeLabel];
	
	[usedLabel release];
	[freeLabel release];
	
}


- (void)dealloc {
    [super dealloc];
}


@end
