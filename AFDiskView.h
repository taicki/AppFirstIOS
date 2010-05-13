//
//  AFDiskView.h
//  AppFirst
//
//  Created by appfirst on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFDiskView : UIView {
	IBOutlet NSArray* diskValues;
	IBOutlet NSArray* diskTotals;
	IBOutlet NSArray* diskNames;
}

@property (nonatomic, retain) NSArray* diskValues;
@property (nonatomic, retain) NSArray* diskTotals;
@property (nonatomic, retain) NSArray* diskNames;


@end
