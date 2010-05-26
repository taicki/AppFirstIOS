    //
//  AlertDetailViewController.m
//  AppFirst
//
//  Created by appfirst on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlertDetailViewController.h"
#import "AlertEditViewController.h"
#import "config.h"


@implementation AlertDetailViewController
@synthesize alertName,lastTriggeredTime,alertTarget,alertValue,alertReset,alertTrigger,alertType,alertEnabled;
@synthesize detailData;

@synthesize viewContainer;
@synthesize bounds;

@synthesize availableCookies;
@synthesize alertId;

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
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}







- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    if(editing)
    {
		AlertEditViewController *detailViewController = [[AlertEditViewController alloc] initWithNibName:@"AlertEditViewController" bundle:nil];
		
		UINavigationController *editController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
		
		detailViewController.bounds = self.bounds;
		detailViewController.delegate = self;
		
		detailViewController.alertId = self.alertId;
		detailViewController.detailData = self.detailData;
		detailViewController.availableCookies = self.availableCookies;
		
		[self presentModalViewController:editController animated:YES];
		
		
		[detailViewController release];
		[editController release];
    }
    else
    {
        NSLog(@"Done leave editmode");
    }
}


- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated] ;
	viewContainer.contentSize = CGSizeMake(self.bounds.width, self.bounds.height);
	viewContainer.frame = CGRectMake(0, 0, self.bounds.height, self.bounds.width);
	

	self.alertTarget.text = [NSString stringWithFormat:@"Target: %@", [self.detailData objectForKey:ALERT_TARGET_NAME]];
	
	if ([[NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_VALUE_NAME]] isEqualToString:@""] == NO) {
		self.alertValue.text = [NSString stringWithFormat:@"Value: %@", [self.detailData objectForKey:ALERT_VALUE_NAME]];
	} else {
		self.alertValue.text = @"Value: N/A";
	}
	
	if ([[NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_RESET_NAME]] isEqualToString:@""] == NO) {
		self.alertReset.text = [NSString stringWithFormat:@"Reset: %@", [self.detailData objectForKey:ALERT_RESET_NAME]];
	} else {
		self.alertReset.text = @"Reset: N/A";
	}
	
	self.alertTrigger.text = [NSString stringWithFormat:@"Trigger: %@", [self.detailData  objectForKey:ALERT_TRIGGER_TYPE_NAME]];
	self.alertType.text = [NSString stringWithFormat:@"Type: %@", [self.detailData objectForKey:ALERT_TYPE_NAME]];
	
	if ([self.detailData objectForKey:AlERT_LAST_TRIGGER_NAME] != nil) {
		NSDate *triggerTime = [NSDate dateWithTimeIntervalSince1970:[[self.detailData objectForKey:AlERT_LAST_TRIGGER_NAME] doubleValue]];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		self.lastTriggeredTime.text  = [NSString stringWithFormat:@"Last triggered: %@", [format stringFromDate:triggerTime]];
		[format release];
	} else {
		self.lastTriggeredTime.text = @"Last triggered: N/A";
	}
	
	NSString* enabled = [NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_STATUS_NAME]];
	
	if ([enabled isEqualToString:@"True"]) {
		self.alertEnabled.on = YES;
	} else {
		self.alertEnabled.on = NO;
	}
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	if ((interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
		viewContainer.frame = CGRectMake(0, 0, self.bounds.height, self.bounds.width);
	}
	else if ((interfaceOrientation == UIDeviceOrientationLandscapeLeft))	{
		viewContainer.frame = CGRectMake(0, 0, self.bounds.height, self.bounds.width);
	}
	else if ((interfaceOrientation == UIDeviceOrientationPortrait))		{
		viewContainer.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height);
	} else {
		viewContainer.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height);
	}
	
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
	[alertName release];
	[lastTriggeredTime release];
	[alertTarget release];
	[alertValue release];
	[alertReset release];
	[alertTrigger release];
	[alertType release];
	[alertEnabled release];
	
	[detailData release];
	[viewContainer release];
	
	
	[availableCookies release];
	[alertId release];
	
    [super dealloc];
}


@end
