//
//  AFGraphViewController.h
//  AppFirst
//
//  Created by appfirst on 7/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "S7GraphView.h"


@interface AFGraphViewController : UIViewController <S7GraphViewDataSource> {
	S7GraphView *graphView;
	NSString* queryString;
	NSDictionary* allData;
	NSMutableData* responseData;
	NSMutableArray* xValues;
	NSMutableArray* yValues;
	NSArray* labels;
	NSString* graphTitle;
}
	
@property (nonatomic, retain) S7GraphView *graphView;
@property (nonatomic, retain) NSString* queryString;
@property (nonatomic, retain) NSDictionary* allData;
@property (nonatomic, retain) NSMutableData* responseData;

@property (nonatomic, retain) NSMutableArray* xValues;
@property (nonatomic, retain) NSMutableArray* yValues;
@property (nonatomic, retain) NSArray* labels;

@property (nonatomic, retain) NSString* graphTitle;

- (void) dismissView;
- (void) asyncGetServerData;
@end
