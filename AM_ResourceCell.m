//
//  AM_ResourceCell.m
//  AppFirst
//
//  Created by appfirst on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AM_ResourceCell.h"


@implementation AM_ResourceCell

@synthesize resourceName, resourceUrl, resourceValue, extra, renderOption, graphOption, resourceType, resourceDetail, time;

- (void)dealloc {
    [resourceName release];
    [resourceUrl release];
    [resourceValue release];
    [resourceDetail release];
    [resourceType release];
    [extra release];
    [time release];
    [super dealloc];
}
@end
