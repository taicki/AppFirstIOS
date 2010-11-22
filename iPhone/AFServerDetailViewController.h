//
//  AFServerDetailViewController.h
//  AppFirst
//
//  Created by appfirst on 7/7/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFCpuDetailView.h"
#import "AFDiskDetailViewController.h"

@interface AFServerDetailViewController : UIViewController {
	AFDiskDetailViewController* diskViewController;
	NSDictionary *detailData;
	NSMutableData* responseData;
	NSString* queryUrl;
	NSString* serverPK;
	NSString* serverName;
	NSString* osType;
}



@property (nonatomic, retain) NSDictionary *detailData;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) AFDiskDetailViewController *diskViewController;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) NSString* serverPK;
@property (nonatomic, retain) NSString* serverName;
@property (nonatomic, retain) NSString* osType;

- (void) asyncGetServerData;
- (id) initWithPk:(NSString*)pk;

@end
