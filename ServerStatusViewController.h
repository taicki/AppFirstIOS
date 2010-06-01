//
//  ServerStatusViewController.h
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServerStatusViewController : UIViewController {
	UILabel *nameLabel;
	UILabel *cpuLabel;
	UILabel *memoryLabel;
	UILabel *diskLabel;
	UILabel *timeLabel;

	NSDictionary *detailData;
	NSString *name;
	NSString *timeLabelText;
	
	UIScrollView* viewContainer;
	
	CGSize bounds;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *cpuLabel;
@property (nonatomic, retain) UILabel *memoryLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *diskLabel;

@property (nonatomic, retain) NSDictionary *detailData;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *timeLabelText;

@property (nonatomic, retain) UIScrollView* viewContainer;
@property (nonatomic, readwrite) CGSize bounds;

- (void) displayCpuValue;
- (void) displayMemoryValue;
- (void) displayDiskValue;

@end
