//
//  AV_GenericTableCell.h
//  AppFirst
//
//  Created by appfirst on 5/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AM_ResourceCell.h"


@interface AV_GenericTableCell : UIView {
    AM_ResourceCell* data;
}

@property (nonatomic, retain) AM_ResourceCell* data;

@end
