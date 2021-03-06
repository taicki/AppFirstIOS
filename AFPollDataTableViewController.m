/*
 * Copyright 2009-2011 AppFirst, Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AFPollDataTableViewController.h"
#import "AppHelper.h"
#import "AFGraphViewController.h"
#import "AppDelegate_Shared.h"
#import "config.h"


@implementation AFPollDataTableViewController
@synthesize pollData;

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
	
	/*
	self.pollData = [[NSMutableArray alloc] init];
	[self.pollData addObject:[NSDictionary dictionaryWithObjectsAndKeys: 
								  @"check_total_procs", @"service", 
								  @"OK", @"status",
								  @"PROCS OK: 133 processes", @"last message", 
								  [NSNumber numberWithDouble: 1277134440000], @"updateTime", nil]];
	[self.pollData addObject:[NSDictionary dictionaryWithObjectsAndKeys: 
							  @"check_users", @"service", 
							  @"OK", @"status",
							  @"USERS OK - 1 users currently logged in |users=1;5;10;0", @"last message", 
							  [NSNumber numberWithDouble: 1277134440000], @"updateTime", nil]];
	[self.pollData addObject:[NSDictionary dictionaryWithObjectsAndKeys: 
							  @"check_hd1", @"service", 
							  @"CRITICAL", @"status",
							  @"DISK CRITICAL - /dev/hda1 is not accessible: No such file or directory", @"last message", 
							  [NSNumber numberWithDouble: 1277134440000], @"updateTime", nil]];
	*/
	
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
 return @"top running processes";
 }*/


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
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	NSString* queryString;
	if (DEBUGGING) {
		queryString = DEV_SERVER_IP;
	} else {
		queryString = PROD_SERVER_IP;
	}
	
	queryString = [NSString stringWithFormat:@"%@%@?hostname=%@&script=%@&secs=%d", queryString, POLLDATA_GRAPH_API_STRING,
				   [[pollData objectAtIndex:indexPath.row] objectForKey: @"Server"], 
				   [[pollData objectAtIndex:indexPath.row] objectForKey: @"Service"], 3600];
	
	
	AFGraphViewController* aGraphController = [[AFGraphViewController alloc] init];
	aGraphController.queryString = queryString;
	aGraphController.graphTitle = [NSString stringWithFormat:@"%@ on %@", 
								   [[pollData objectAtIndex:indexPath.row] objectForKey: @"Service"],
	[[pollData objectAtIndex:indexPath.row] objectForKey: @"Server"]];
    NSLog(@"herere");
	
	// Create a Navigation controller
	UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:aGraphController];
	
	
	// show the navigation controller modally
	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
	[[appDelegate navigationController] presentModalViewController:navController animated:YES];
	
	// Clean up resources
	[navController release];
	[aGraphController release];
	
	
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [pollData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ at %@", [[pollData objectAtIndex:indexPath.row] objectForKey:@"Service"],
						   [AppHelper formatDateString: [NSDate dateWithTimeIntervalSince1970:[[[pollData objectAtIndex:indexPath.row] objectForKey:@"Last Run"] doubleValue] / 1000]]];
	cell.textLabel.font = [UIFont systemFontOfSize:IPAD_TABLE_CELL_BIG_FONTSIZE];
    // Configure the cell...
	//cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", 
								 [[pollData objectAtIndex:indexPath.row] objectForKey:@"Last Message"]];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:IPAD_TABLE_CELL_NORMAL_FONTSIZE];
	//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (![AppHelper isIPad]) {
		cell.detailTextLabel.numberOfLines = 0;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:IPHONE_TABLE_FONTSIZE];
	}
	
	UIImage* theImage;
	NSString* path;
	
	if ([[[pollData objectAtIndex:indexPath.row] objectForKey:@"Status"] doubleValue] == 0) {
		path = [[NSBundle mainBundle] pathForResource:@"green_status" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	} else if ([[[pollData objectAtIndex:indexPath.row] objectForKey:@"Status"] doubleValue] == 1){
		path = [[NSBundle mainBundle] pathForResource:@"red_status" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	} else {
		path = [[NSBundle mainBundle] pathForResource:@"yellow_status" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	}
	
	cell.imageView.image = theImage;
	
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([AppHelper isIPad])
		return 45;
	else {
		float height = [[[pollData objectAtIndex:indexPath.row] objectForKey:@"Last Message"] length] / 40 * 15 + 30;
		
		if (height < 45)
			height = 45;
		return height;
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
	[pollData release];
    [super dealloc];
}


@end
