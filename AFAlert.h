//
//  AFAlert.h
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFAlert : UITableViewController {
	NSArray* alerts;
	NSDictionary* allData;
}

@property (nonatomic, retain) NSArray* alerts;
@property (nonatomic, retain) NSDictionary* allData;

@end
