    //
//  AlertEditViewController.m
//  AppFirst
//
//  Created by appfirst on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlertEditViewController.h"
#import "config.h"


@implementation AlertEditViewController

@synthesize alertName,lastTriggeredTime,alertTarget,alertValue,alertReset,alertTrigger,alertType,alertEnabled;
@synthesize detailData;

@synthesize viewContainer;
@synthesize bounds;
@synthesize availableCookies;
@synthesize alertId;
@synthesize delegate;

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
	
	self.navigationItem.rightBarButtonItem = [ [[UIBarButtonItem 
												   alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave 
													target:self 
													action: @selector(save:)] autorelease] ;
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											  target:self 
											  action: @selector(cancel:)] autorelease];
}

- (IBAction) cancel: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
	[self.delegate setEditing:NO];
}


- (IBAction) save: (id) sender {
	
	NSHTTPURLResponse *response;
	NSError *error = [[[NSError alloc] init] autorelease];
	
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:self.availableCookies];
	NSMutableURLRequest *saveAlertPost = [[[NSMutableURLRequest alloc] init] autorelease];
	
	NSString *queryUrl;
	if (DEBUGGING == YES) {
		queryUrl = [NSString stringWithFormat:@"%@%@", DEV_SERVER_IP, ALERT_EDIT_API_STRING];
	} else {
		queryUrl = [NSString stringWithFormat:@"%@%@", PROD_SERVER_IP, ALERT_EDIT_API_STRING];
	}
	
	
	saveAlertPost.URL = [NSURL URLWithString:queryUrl];
	
	
	NSLog(@"%@", self.alertId);
	NSLog(@"%@", self.alertReset.text);
	
	NSString* alertEnabledString = @"True";
	
	if (self.alertEnabled.on == NO)
		alertEnabledString = @"False";
	
	NSString *postData = [NSString stringWithFormat:@"alert=%@&interval=%@&enabled=%@", self.alertId, self.alertReset.text, alertEnabledString];
	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	
	[saveAlertPost setValue:length forHTTPHeaderField:@"Content-Length"];
	[saveAlertPost setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
	[saveAlertPost setHTTPMethod:@"POST"];
	[saveAlertPost setAllHTTPHeaderFields:headers];
	
	NSData * data = [NSURLConnection sendSynchronousRequest:saveAlertPost returningResponse:&response error:&error];
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
		return;
	}
	
	
	AlertDetailViewController* controller = self.delegate;
	controller.alertEnabled.on = self.alertEnabled.on;
	controller.alertReset.text = self.alertReset.text;
	
	
	NSString *jsonString = [[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding] autorelease];
	NSLog(@"The server saw:\n%@", jsonString);
	

	
	[self dismissModalViewControllerAnimated:YES];
	[self.delegate setEditing:NO];
	//self.delegate = nil;
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

- (void) viewWillDisappear: (BOOL) animated { 
	[[NSNotificationCenter defaultCenter] removeObserver: self] ; 
}

- (void) keyboardDidShow: (NSNotification *) notif {
	if (keyboardVisible) {
		return;
	}
	
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	CGRect viewFrame = viewContainer.frame;
	viewFrame.size.height -= keyboardSize.height;
	
	viewContainer.frame = viewFrame;
	keyboardVisible = YES;
		
}

- (void) keyboardDidHide: (NSNotification *) notif { 
	if (!keyboardVisible) {
		return;
	}
	
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	CGRect viewFrame = viewContainer.frame;
	viewFrame.size.height += keyboardSize.height;
	
	viewContainer.frame = viewFrame;
	keyboardVisible = NO;
}


- (void) viewWillAppear: (BOOL) animated {
	
	[super viewWillAppear: animated];
	
	viewContainer.contentSize = CGSizeMake(self.bounds.width, self.bounds.height);
	viewContainer.frame = CGRectMake(0, 0, self.bounds.height, self.bounds.width);
	
	

	[[NSNotificationCenter defaultCenter] addObserver: self selector:@
	 selector(keyboardDidShow: )  name: UIKeyboardDidShowNotification object:nil] ;  
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @
	 selector(keyboardDidHide: ) name: UIKeyboardDidHideNotification object: nil] ; 
	// Initially the keyboard is hidden, so reset our variable 
	keyboardVisible = NO; 
	
	self.alertName.text = [ NSString stringWithFormat:@"Alert Name: %@", 
							[self.detailData objectForKey:ALERT_NAME]];
	
	
	self.alertTarget.text = [NSString stringWithFormat:@"Target: %@", [self.detailData objectForKey:ALERT_TARGET_NAME]];
	

	if ([[NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_VALUE_NAME]] isEqualToString:@""] == NO) {
		self.alertValue.text = [NSString stringWithFormat:@"Value: %@", [self.detailData objectForKey:ALERT_VALUE_NAME]];
	} else {
		self.alertValue.text = @"Value: N/A";
	}
	
	if ([[NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_RESET_NAME]] isEqualToString:@""] == NO) {
		self.alertReset.text = [NSString stringWithFormat:@"%@", 
								[[self.detailData objectForKey:ALERT_RESET_NAME] stringByReplacingOccurrencesOfString:@" mins" withString:@""]];

		
	} else {
		self.alertReset.text = @"";
	}
	
	self.alertTrigger.text = [NSString stringWithFormat:@"Trigger: %@", [self.detailData  objectForKey:ALERT_TRIGGER_TYPE_NAME]];
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
	[delegate release];
	
    [super dealloc];
}


@end
