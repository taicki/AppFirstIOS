//
//  AFCpuDetailView.h
//  AppFirst
//
//  Created by appfirst on 6/17/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFCpuDetailView : UIView {
	NSMutableArray* cpuLoadArray;
	NSString* cpuDetail;
	double cpuValue;
}

@property (nonatomic, retain) NSMutableArray* cpuLoadArray;
@property (nonatomic, retain) NSString* cpuDetail;
@property (nonatomic, readwrite) double cpuValue;

@end
