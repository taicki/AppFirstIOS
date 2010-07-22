//
//  AFDiskView.h
//  AppFirst
//
//  Created by appfirst on 5/12/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFDiskView : UIView {
	IBOutlet NSMutableArray* diskValues;
	IBOutlet NSMutableArray* diskTotals;
	IBOutlet NSMutableArray* diskNames;
}

@property (nonatomic, retain) NSMutableArray* diskValues;
@property (nonatomic, retain) NSMutableArray* diskTotals;
@property (nonatomic, retain) NSMutableArray* diskNames;


@end
