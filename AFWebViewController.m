    //
//  AFWebViewController.m
//  AppFirst
//
//  Created by appfirst on 7/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFWebViewController.h"
#import "AppHelper.h"

@implementation AFWebViewController

@synthesize webView;
@synthesize queryUrl;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	if ([AppHelper isIPad] == NO) {
		self.webView.frame = CGRectMake(0, 0, 320, 300);
	}
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:self.queryUrl];
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[webView release];
	[queryUrl release];
    [super dealloc];
}


@end
