//
//  AFDashboard.m
//  AppFirst
//
//  Created by appfirst on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFDashboard.h"
#import "ServerStatusViewController.h"
#import "config.h"

@implementation AFDashboard


@synthesize servers;
@synthesize allData;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithObjects: @"Firecracker", @"Lemon Drop", 
	//							@"Mojito", nil] ;
	//self.servers = tmpArray;
	//[tmpArray release];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.servers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSObject* tmpDetailData = [self.allData objectForKey:[servers objectAtIndex:indexPath.row]];
	
	if ([tmpDetailData isKindOfClass:[NSDictionary class]] == YES) {
		cell.textLabel.text = [self.servers objectAtIndex:indexPath.row];
	} else {
		cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [self.servers objectAtIndex:indexPath.row], @"(stopped)"];
	}
	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	
    // Navigation logic may go here. Create and push another view controller.
	
	ServerStatusViewController *detailViewController = [[ServerStatusViewController alloc] initWithNibName:@"ServerStatusViewController" bundle:nil];
	NSObject* tmpDetailData = [self.allData objectForKey:[servers objectAtIndex:indexPath.row]];
	

	if ([tmpDetailData isKindOfClass:[NSDictionary class]] == YES) {
		
		detailViewController.detailData = [self.allData objectForKey:[servers objectAtIndex:indexPath.row]];
		
		NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:[[[tmpDetailData objectForKey:DATA_NAME] objectForKey:RESOURCE_TIME_NAME] doubleValue] / 1000];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		
		NSString *timeText = [NSString stringWithFormat:@"%@: %@", @"Updated at", [format stringFromDate:updateDate]];
		NSLog(@"%@", timeText);
		detailViewController.timeLabelText = timeText;
		[format release];
	} else {
		
		double stopTime = [[tmpDetailData stringByReplacingOccurrencesOfString:@"stopped:" withString:@""] doubleValue];
		NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:stopTime];
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM dd, yyyy HH:mm"];
		
		NSString *timeText = [NSString stringWithFormat:@"%@: %@", @"Stopped at", [format stringFromDate:updateDate]];
		NSLog(@"%@", timeText);
		
		detailViewController.timeLabelText = timeText;
		[format release];
	}
	
	detailViewController.name = [servers objectAtIndex:indexPath.row];
	

	[self.navigationController pushViewController:detailViewController animated:YES];
		
	[detailViewController release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[servers release];
	[allData release];
    [super dealloc];
}


@end

