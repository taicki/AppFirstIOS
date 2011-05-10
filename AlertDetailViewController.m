    //
//  AlertDetailViewController.m
//  AppFirst
//
//  Created by appfirst on 5/13/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AlertDetailViewController.h"
#import "AlertEditViewController.h"
#import "config.h"


@implementation AlertDetailViewController
@synthesize alertName,lastTriggeredTime,alertTarget,alertValue,alertReset,alertTrigger,alertType,alertEnabledLabel;
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
		if (DEBUGGING) {
			NSLog(@"Done leave editmode");
		}
    }
}



- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated] ;
	
	//viewContainer.contentSize = CGSizeMake(self.bounds.width, self.bounds.height);
	viewContainer.frame = CGRectMake(0, 0, self.bounds.height, self.bounds.width);
	
	int leftPadding = 10;
	int topPadding = 0;
	
	self.alertName = [[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, ALERT_CELL_WIDTH, ALERT_CELL_HEIGHT)] autorelease];
	self.alertName.numberOfLines = 0;
	self.alertName.text = [NSString stringWithFormat:@"Name: %@", [self.detailData objectForKey:ALERT_NAME]];
	self.alertName.font = [UIFont boldSystemFontOfSize:15];
	[self.viewContainer addSubview:self.alertName];
	
	topPadding += ALERT_CELL_HEIGHT;
	
	self.alertTarget = [[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, ALERT_CELL_WIDTH, ALERT_CELL_HEIGHT)] autorelease];
	self.alertTarget.numberOfLines = 0;
	self.alertTarget.text = [NSString stringWithFormat:@"Target: %@", [self.detailData objectForKey:ALERT_TARGET_NAME]];
	self.alertTarget.font = [UIFont systemFontOfSize:ALERT_TAB_NORMAL_FONT_SIZE];
	[self.viewContainer addSubview:self.alertTarget];
	
	topPadding += ALERT_CELL_HEIGHT;
	
	self.alertValue = [[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, ALERT_CELL_WIDTH, ALERT_CELL_HEIGHT)] autorelease];
	self.alertValue.numberOfLines = 0;
	
	if ([[NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_VALUE_NAME]] isEqualToString:@""] == NO) {
		self.alertValue.text = [NSString stringWithFormat:@"Value: %@", [self.detailData objectForKey:ALERT_VALUE_NAME]];
	} else {
		self.alertValue.text = @"Value: N/A";
	}
	self.alertValue.font = [UIFont systemFontOfSize:ALERT_TAB_NORMAL_FONT_SIZE];
	[self.viewContainer addSubview:self.alertValue];
	
	topPadding += ALERT_CELL_HEIGHT;
	
	self.alertReset = [[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, ALERT_CELL_WIDTH, ALERT_CELL_HEIGHT)] autorelease];
	self.alertReset.numberOfLines = 0;
		
	if ([[NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_RESET_NAME]] isEqualToString:@""] == NO) {
		self.alertReset.text = [NSString stringWithFormat:@"Reset: %@", [self.detailData objectForKey:ALERT_RESET_NAME]];
	} else {
		self.alertReset.text = @"Reset: N/A";
	}
	self.alertReset.font = [UIFont systemFontOfSize:ALERT_TAB_NORMAL_FONT_SIZE];
	[self.viewContainer addSubview:self.alertReset];
	
	topPadding += ALERT_CELL_HEIGHT;
	
	
	self.alertTrigger = [[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, ALERT_CELL_WIDTH, ALERT_CELL_HEIGHT)] autorelease];
	self.alertTrigger.numberOfLines = 0;
	
	self.alertTrigger.text = [NSString stringWithFormat:@"Trigger: %@", [self.detailData  objectForKey:ALERT_TRIGGER_TYPE_NAME]];
	self.alertTrigger.font = [UIFont systemFontOfSize:ALERT_TAB_NORMAL_FONT_SIZE];
	[self.viewContainer addSubview:self.alertTrigger];
	
	topPadding += ALERT_CELL_HEIGHT;
	
	
	self.alertType = [[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, ALERT_CELL_WIDTH, ALERT_CELL_HEIGHT)] autorelease];
	self.alertType.numberOfLines = 0;
	self.alertType.text = [NSString stringWithFormat:@"Type: %@", [self.detailData objectForKey:ALERT_TYPE_NAME]];
	self.alertType.font = [UIFont systemFontOfSize:ALERT_TAB_NORMAL_FONT_SIZE];
	[self.viewContainer addSubview:self.alertType];
	
	topPadding += ALERT_CELL_HEIGHT;
	
	self.lastTriggeredTime = [[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, ALERT_CELL_WIDTH, ALERT_CELL_HEIGHT)] autorelease];
	self.lastTriggeredTime.numberOfLines = 0;
	
	if ([self.detailData objectForKey:AlERT_LAST_TRIGGER_NAME] != nil) {
		NSDate *triggerTime = [NSDate dateWithTimeIntervalSince1970:[[self.detailData objectForKey:AlERT_LAST_TRIGGER_NAME] doubleValue]];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		self.lastTriggeredTime.text  = [NSString stringWithFormat:@"Last triggered: %@", [format stringFromDate:triggerTime]];
		[format release];
	} else {
		self.lastTriggeredTime.text = @"Last triggered: N/A";
	}
	self.lastTriggeredTime.font = [UIFont systemFontOfSize:ALERT_TAB_NORMAL_FONT_SIZE];
	[self.viewContainer addSubview:self.lastTriggeredTime];
	topPadding += ALERT_CELL_HEIGHT;
	
	self.alertEnabledLabel = [[[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, ALERT_CELL_WIDTH, ALERT_CELL_HEIGHT)] autorelease];
	self.alertEnabledLabel.font = [UIFont systemFontOfSize:ALERT_TAB_NORMAL_FONT_SIZE];
	
	
	NSString* enabled = [NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_STATUS_NAME]];
	
	if ([enabled isEqualToString:@"True"]) {
		self.alertEnabledLabel.text = @"Enabled: YES";
		//self.alertEnabled.on = YES;
	} else {
		self.alertEnabledLabel.text = @"Enabled: NO";
		//self.alertEnabled.on = NO;
	}
	
	
	[self.viewContainer addSubview:self.alertEnabledLabel];
	
	topPadding += ALERT_CELL_HEIGHT;
	
	NSLog(@"%d", topPadding);
	
	
	self.viewContainer.contentSize = CGSizeMake(self.bounds.width, topPadding + 100);
	
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
	[alertEnabledLabel release];

	[detailData release];
	[viewContainer release];

	
	[availableCookies release];
	[alertId release];
	
    [super dealloc];
}


@end
