//
//  AFWebViewController.h
//  AppFirst
//
//  Created by appfirst on 7/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AFWebViewController : UIViewController {
	IBOutlet UIWebView* webView;
	NSString* queryUrl;
}

@property (nonatomic, retain) UIWebView* webView;
@property (nonatomic, retain) NSString* queryUrl;

@end
