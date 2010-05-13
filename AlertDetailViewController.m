    //
//  AlertDetailViewController.m
//  AppFirst
//
//  Created by appfirst on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlertDetailViewController.h"
#import "config.h"


@implementation AlertDetailViewController
@synthesize alertName,lastTriggeredTime,alertTarget,alertValue,alertReset,alertTrigger,alertType,alertEnabled;
@synthesize detailData;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated] ;

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
	
	self.alertTrigger.text = [NSString stringWithFormat:@"Trigger: %@", [self.detailData objectForKey:ALERT_TRIGGER_TYPE_NAME]];
	self.alertType.text = [NSString stringWithFormat:@"Type: %@", [self.detailData objectForKey:ALERT_TYPE_NAME]];
	
	if ([self.detailData objectForKey:AlERT_LAST_TRIGGER_NAME] != nil) {
		NSDate *triggerTime = [NSDate dateWithTimeIntervalSince1970:[[self.detailData objectForKey:AlERT_LAST_TRIGGER_NAME] doubleValue]];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		self.lastTriggeredTime.text  = [NSString stringWithFormat:@"Last triggered: %@", [format stringFromDate:triggerTime]];
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
	
    [super dealloc];
}


@end
