//
//  AC_GraphViewController.h
//  AppFirst
//
//  Created by appfirst on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S7GraphView.h"

@interface AC_GraphViewController : UIViewController <S7GraphViewDataSource> {
    S7GraphView *graphView;
    NSString* queryString;
    NSDictionary* allData;
    NSMutableData* responseData;
    NSMutableArray* xValues;
    NSMutableArray* yValues;
    NSMutableArray* labels;
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
- (void) setupGraph : (NSMutableArray*) newXvalues newYvalues: (NSMutableArray*) newYValues newLabels: (NSMutableArray*) newLabels;
@end
