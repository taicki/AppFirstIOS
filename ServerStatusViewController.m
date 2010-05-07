    //
//  ServerStatusViewController.m
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerStatusViewController.h"
#import "config.h"


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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/



- (void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated] ;
	nameLabel.text = name;
	timeLabel.text = timeLabelText;
	[self displayCpuValue];
	[self displayMemoryValue];
	[self displayDiskValue];
	

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
		NSArray *cpuValues = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		NSString *cpuTotal = [[[detailData objectForKey:DATA_NAME] objectForKey:CPU_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		NSDecimalNumber *cpuValue = [cpuValues objectAtIndex:0];
		cpuLabel.text = [NSString stringWithFormat:@"CPU usage: %.1f %@ (%@)", [cpuValue  doubleValue], @"%", cpuTotal];
	}
}

- (void) displayMemoryValue {
	if (detailData != nil) {
		NSArray *memoryValues = [[[detailData objectForKey:DATA_NAME] 
								  objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		NSDecimalNumber *memoryTotal = [[[detailData objectForKey:DATA_NAME] 
								objectForKey:MEMORY_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		NSDecimalNumber *memoryValue = [memoryValues objectAtIndex:0];
		memoryLabel.text = [NSString stringWithFormat:@"Memory usage: %.1f %@ (%d bytes)", 
							[memoryValue  doubleValue] / [memoryTotal doubleValue] * 100, @"%", memoryTotal];
	}
}

- (void) displayDiskValue {
	if (detailData != nil) {
		NSArray *diskValues = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_VALUE_NAME];
		NSArray *diskTotals = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_TOTAL_NAME];
		NSArray *diskNames = [[[detailData objectForKey:DATA_NAME] objectForKey:DISK_RESOURCE_NAME] objectForKey:RESOURCE_NAME_NAME];
		
		double valueSum = 0;
		double totalSum = 0;
		NSString *diskText = @"";
		for (int i = 0; i < [diskNames count]; i++) {
			double diskValue = [[diskValues objectAtIndex:i] doubleValue];
			double diskTotal = [[diskTotals objectAtIndex:i] doubleValue];
			
			valueSum += diskValue;
			totalSum += diskTotal;
			
			diskText = [NSString stringWithFormat:@"%@Disk Name: %@, used: %.0f%@, total: %.0fMB \n", 
						diskText, [diskNames objectAtIndex:i], 
						diskValue / diskTotal * 100
						, @"%", diskTotal];
		}
		
		diskText = [NSString stringWithFormat:@"Disk Usage: %.1f%@ \n%@", valueSum / totalSum * 100, @"%", diskText];
		
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
