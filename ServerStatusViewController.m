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
	[self displayCpuValue];
	[self displayMemoryValue];
	[self displayDiskValue];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
}




- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated] ;
	nameLabel.text = name;
	timeLabel.text = timeLabelText;
	//[self displayCpuValue];
	//
	
	

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void) setTimeLabel {
	if (detailData != nil) {
				//[updateDate release];
	}
	
}

- (void) displayCpuValue {
	if (detailData != nil) {
		double leftPadding = 50;
		double topPadding = 80;
		
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
		
		[self.view addSubview:emptyBarView];
		[self.view addSubview:newView];
		[self.view addSubview:cpuValueView];
		[self.view addSubview:cpuTotalView];
		
		
		[newView release];
		[emptyBarView release];
		[cpuValueView release];
		[cpuTotalView release];
		
		cpuLabel.text = [NSString stringWithFormat:@"CPU:"];
		cpuLabel.font = [UIFont systemFontOfSize:10.0];
	}
}

- (void) displayMemoryValue {
	if (detailData != nil) {
		NSArray *memoryValues = [[[detailData objectForKey:DATA_NAME] 
								  objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		NSDecimalNumber *memoryTotal = [[[detailData objectForKey:DATA_NAME] 
								objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		NSDecimalNumber *memoryValue = [memoryValues objectAtIndex:0];
		
		
		
		double leftPadding = 50;
		double topPadding = 120;
		
				
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
		
		
		[self.view addSubview:emptyBarView];
		[self.view addSubview:newView];
		[self.view addSubview:valueView];
		[self.view addSubview:totalView];
		
		
		[newView release];
		[emptyBarView release];
		[valueView release];
		[totalView release];
		
		memoryLabel.text = [NSString stringWithFormat:@"Memory:"];
		memoryLabel.font = [UIFont systemFontOfSize:10.0];
	}
}

- (void) displayDiskValue {
	if (detailData != nil) {
		
		
		
		double leftPadding = 10;
		double topPadding = 150;
		
		AFDiskLegendView* legendView = [[AFDiskLegendView alloc] initWithFrame:CGRectMake(leftPadding + 160, topPadding + 15, 200, 25)];
		[self.view addSubview:legendView];
		[legendView release];
		
		

		CGRect diskFrame = CGRectMake(leftPadding, topPadding, 200, 200);
		
		AFDiskView* diskView = [[AFDiskView alloc] initWithFrame:diskFrame];
		
		diskView.diskValues = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		diskView.diskTotals = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		diskView.diskNames = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_NAME_NAME];
		diskLabel.font = [UIFont systemFontOfSize:9.5];
		
		[self.view addSubview:diskView];
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
		
		diskLabel.text = diskText;
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
	
    [super dealloc];
}


@end
