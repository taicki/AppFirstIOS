//
//  AM_ResourceCell.h
//  AppFirst
//
//  Created by appfirst on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AF_NormalCell,
    AF_GraphCell,
    AF_ExtendedGraphCell
    
} AM_ResourceCellOption;

typedef enum {
    AF_Bar, 
    AF_Pie
} AM_ResourceGraphOption;


@interface AM_ResourceCell : NSObject {
    NSString* resourceName;
    NSString* resourceType;
    NSString* resourceUrl;
    NSString* resourceDetail;
    NSNumber* resourceValue;
    NSNumber* time;
    AM_ResourceCellOption renderOption;
    NSDictionary* extra;
    
}

@property (nonatomic, retain) NSString *resourceName;
@property (nonatomic, retain) NSString *resourceType;
@property (nonatomic, retain) NSString *resourceUrl;
@property (nonatomic, retain) NSString *resourceDetail;
@property (nonatomic, retain) NSNumber *resourceValue;
@property (nonatomic, retain) NSNumber *time;
@property (nonatomic, retain) NSDictionary* extra;

@property (nonatomic, assign) AM_ResourceCellOption renderOption;
@property (nonatomic, assign) AM_ResourceGraphOption graphOption;

@end
