    //
//  ServerStatusViewController.m
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerStatusViewController.h"
#import "config.h"
#import <QuartzCore/QuartzCore.h>
#import "AFBarView.h"
#import "AFEmptyBarView.h"
#import "AFDiskView.h"
#import "AFDiskLegendView.h"


@implementation ServerStatusViewController
@synthesize nameLabel, cpuLabel, memoryLabel, diskLabel, timeLabel;
@synthesize detailData, name, timeLabelText;
@synthesize viewContainer, bounds;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/



- (void)loadView {
	[super loadView];
	
	viewContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.width, self.bounds.height)];
	[self.view addSubview:viewContainer];
	
	[self displayCpuValue];
	[self displayMemoryValue];
	[self displayDiskValue];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}




- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated];
	self.nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 10, 300, 20)];
	nameLabel.text = name;
	[viewContainer addSubview:self.nameLabel];
	
	self.timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 35, 300, 20)];
	timeLabel.text = timeLabelText;
	[viewContainer addSubview:self.timeLabel];
	
	viewContainer.contentSize = CGSizeMake(self.bounds.width, self.bounds.height);
	
	//NSLog(@"%f-----%f", self.bounds.width, self.bounds.height);

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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

- (void) setTimeLabel {
	if (detailData != nil) {
				//[updateDate release];
	}
	
}

- (void) displayCpuValue {
	if (detailData != nil) {
		double leftPadding = 10;
		double topPadding = 80;
		
		
		self.cpuLabel = [[UILabel alloc] initWithFrame: CGRectMake(leftPadding, topPadding, 35, 20)];
		cpuLabel.text = [NSString stringWithFormat:@"CPU:"];
		cpuLabel.font = [UIFont systemFontOfSize:10.0];
		[viewContainer addSubview:self.cpuLabel];
		
		leftPadding += 40;
		
	
		NSArray *cpuValues = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		NSString *cpuTotal = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		NSDecimalNumber *cpuValue = [cpuValues objectAtIndex:0];
		
		CGRect emptyBarFrame = CGRectMake(leftPadding, topPadding, AF_BAR_WIDTH, AF_BAR_HEIGHT);
		AFEmptyBarView* emptyBarView = [[AFEmptyBarView alloc] initWithFrame: emptyBarFrame];
		
		
		CGRect teamLogoFrame = CGRectMake(leftPadding, topPadding, 
										  [cpuValue doubleValue] * AF_BAR_WIDTH / 100, AF_BAR_HEIGHT);
		AFBarView* newView = [[AFBarView alloc] initWithFrame: teamLogoFrame];
		
		CGRect cpuValueFrame = CGRectMake(leftPadding + AF_BAR_WIDTH + 10, topPadding, 60, AF_BAR_HEIGHT);
		UILabel* cpuValueView = [[UILabel alloc] initWithFrame:cpuValueFrame];
		cpuValueView.text = [NSString stringWithFormat:@"%.1f %@", [cpuValue doubleValue], @"%"];
		cpuValueView.font = [UIFont systemFontOfSize:9];
		
		CGRect cpuTotalFrame = CGRectMake(leftPadding, topPadding + AF_BAR_HEIGHT, 300, AF_BAR_HEIGHT);
		UILabel* cpuTotalView = [[UILabel alloc] initWithFrame:cpuTotalFrame];
		cpuTotalView.text = [NSString stringWithFormat:@"Total: %@", cpuTotal];
		cpuTotalView.font = [UIFont systemFontOfSize:9];
		
		[viewContainer addSubview:emptyBarView];
		[viewContainer addSubview:newView];
		[viewContainer addSubview:cpuValueView];
		[viewContainer addSubview:cpuTotalView];
		
		
		[newView release];
		[emptyBarView release];
		[cpuValueView release];
		[cpuTotalView release];
		
		
	}
}

- (void) displayMemoryValue {
	if (detailData != nil) {
		NSArray *memoryValues = [[[detailData objectForKey:DATA_NAME] 
								  objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		NSDecimalNumber *memoryTotal = [[[detailData objectForKey:DATA_NAME] 
								objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		NSDecimalNumber *memoryValue = [memoryValues objectAtIndex:0];
		
		
		
		double leftPadding = 10;
		double topPadding = 120;
		
		self.memoryLabel = [[UILabel alloc] initWithFrame: CGRectMake(leftPadding, topPadding, 35, 20)];
		memoryLabel.text = [NSString stringWithFormat:@"Memory:"];
		memoryLabel.font = [UIFont systemFontOfSize:10.0];
		[viewContainer addSubview:self.memoryLabel];
		
		leftPadding += 40;
		
				
		CGRect emptyBarFrame = CGRectMake(leftPadding, topPadding, AF_BAR_WIDTH, AF_BAR_HEIGHT);
		AFEmptyBarView* emptyBarView = [[AFEmptyBarView alloc] initWithFrame: emptyBarFrame];
		
		
		CGRect teamLogoFrame = CGRectMake(leftPadding, topPadding, 
								[memoryValue  doubleValue] / [memoryTotal doubleValue] * AF_BAR_WIDTH, AF_BAR_HEIGHT);
		AFBarView* newView = [[AFBarView alloc] initWithFrame: teamLogoFrame];
		
		CGRect valueFrame = CGRectMake(leftPadding + AF_BAR_WIDTH + 10, topPadding, 60, AF_BAR_HEIGHT);
		UILabel* valueView = [[UILabel alloc] initWithFrame:valueFrame];
		valueView.text = [NSString stringWithFormat:@"%.1f %@", 
							[memoryValue  doubleValue] / [memoryTotal doubleValue] * 100, @"%"];
		valueView.font = [UIFont systemFontOfSize:9];
		
		CGRect totalFrame = CGRectMake(leftPadding, topPadding + AF_BAR_HEIGHT, 300, AF_BAR_HEIGHT);
		UILabel* totalView = [[UILabel alloc] initWithFrame:totalFrame];
		totalView.text = [NSString stringWithFormat:@"Total: %.0f MB", [memoryTotal doubleValue] / 1000000];
		totalView.font = [UIFont systemFontOfSize:9];
		
		
		[viewContainer addSubview:emptyBarView];
		[viewContainer addSubview:newView];
		[viewContainer addSubview:valueView];
		[viewContainer addSubview:totalView];
		
		
		[newView release];
		[emptyBarView release];
		[valueView release];
		[totalView release];
		
		
	}
}

- (void) displayDiskValue {
	if (detailData != nil) {
		double leftPadding = 10;
		double topPadding = 150;
		
		AFDiskLegendView* legendView = [[AFDiskLegendView alloc] initWithFrame:CGRectMake(leftPadding + 160, topPadding + 15, 200, 25)];
		[viewContainer addSubview:legendView];
		[legendView release];
		
		CGRect diskFrame = CGRectMake(leftPadding, topPadding, 200, 200);
		
		AFDiskView* diskView = [[AFDiskView alloc] initWithFrame:diskFrame];
		
		diskView.diskValues = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		diskView.diskTotals = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		diskView.diskNames = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_NAME_NAME];
		
		
		[viewContainer addSubview:diskView];
		[diskView release];
		
		double valueSum = 0;
		double totalSum = 0;
		NSString *diskText = @"";
		for (int i = 0; i < [diskView.diskNames count]; i++) {
			double diskValue = [[diskView.diskValues objectAtIndex:i] doubleValue];
			double diskTotal = [[diskView.diskTotals objectAtIndex:i] doubleValue];
			
			valueSum += diskValue;
			totalSum += diskTotal;
			
			diskText = [NSString stringWithFormat:@"%@%@ (%.0fMB): %.0f%@ used\n", 
						diskText, [diskView.diskNames objectAtIndex:i], diskTotal, 
						diskValue / diskTotal * 100
						, @"%"];
		}
		
		diskText = [NSString stringWithFormat:@"Overall disk used: %.1f%@ \n%@", valueSum / totalSum * 100, @"%", diskText];
		
		self.diskLabel = [[UITextView alloc] initWithFrame: CGRectMake(150, 150, 154, 164)];
		diskLabel.font = [UIFont systemFontOfSize:9.5];
		diskLabel.text = diskText;
		
		[self.viewContainer addSubview:self.diskLabel];
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
	[nameLabel release];
	[cpuLabel release];
	[memoryLabel release];
	[diskLabel release];
	[timeLabel release];
	
	[detailData release];
	[name release];
	[timeLabelText release];
	
	[viewContainer release];
	
    [super dealloc];
}


@end
