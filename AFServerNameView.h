//
//  AFServerNameView.h
//  AppFirst
//
//  Created by appfirst on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFServerNameView : UIView {
	NSString* serverName;
	NSString* osType;
}

@property (nonatomic, retain) NSString* serverName;
@property (nonatomic, retain) NSString* osType;

@end
