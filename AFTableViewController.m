//
//  AFTableViewController.m
//  AppFirst
//
//  Created by appfirst on 6/18/10.
//  Copyright 2010 AppFirst Inc. All rights reserved.
//

#import "AFTableViewController.h"
#import "AppDelegate_Shared.h"
#import "config.h"
#import "AppHelper.h"

@implementation AFTableViewController
@synthesize processNames;
@synthesize sortKey;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//mockup data
	//processNames = [[NSMutableArray alloc] init];
	
	/*
	[self.processNames addObject:[NSDictionary dictionaryWithObjectsAndKeys: 
								@"python", @"pid", 
								  [NSNumber numberWithDouble:42.0], @"memory",
								  [NSNumber numberWithDouble: 15.0], @"cpu", 
								  [NSNumber numberWithDouble: 33.0], @"disk", nil]];
	[self.processNames addObject:[NSDictionary dictionaryWithObjectsAndKeys: 
								  @"httpd", @"pid", 
								  [NSNumber numberWithDouble:18.0], @"memory",
								  [NSNumber numberWithDouble: 49.0], @"cpu", 
								  [NSNumber numberWithDouble: 82.0], @"disk", nil]];
	[self.processNames addObject:[NSDictionary dictionaryWithObjectsAndKeys: 
								  @"vim", @"pid", 
								  [NSNumber numberWithDouble:24.0], @"memory",
								  [NSNumber numberWithDouble: 33.0], @"cpu", 
								  [NSNumber numberWithDouble: 98.0], @"disk", nil]];
	 
	 */
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
	
	self.sortKey = @"cpu";
	
	
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	
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
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [processNames count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary* processData = [processNames objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ (pid: %@)", [processData objectForKey:@"Name"],[processData objectForKey:@"pid"]];
	cell.textLabel.font = [UIFont systemFontOfSize:IPAD_TABLE_CELL_BIG_FONTSIZE];
   
	
	
	NSString* detailText = [NSString stringWithFormat:@"%@:%@",self.sortKey,  [AppHelper formatMetricsValue:self.sortKey :[[processData objectForKey:self.sortKey] doubleValue]]];
	NSString* key; 
	for (key in processData) {
		if (key == nil || [key isEqualToString:self.sortKey] || 
			[key isEqualToString:@"pk"] ||  
			[key isEqualToString:@"Name"] || 
			[key isEqualToString:@"args"] || 
			[key isEqualToString:@"pid"])
			continue;
		
		detailText = [NSString stringWithFormat:@"%@ %@:%@", detailText, key, [AppHelper formatMetricsValue:key :[[processData objectForKey: key] doubleValue]]];
	}
	
	cell.detailTextLabel.text = detailText;
	
	
	
	cell.detailTextLabel.font = [UIFont systemFontOfSize:IPAD_TABLE_CELL_NORMAL_FONTSIZE];
	
	if (![AppHelper isIPad]) {
		cell.detailTextLabel.numberOfLines = 0;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:IPHONE_TABLE_FONTSIZE];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([AppHelper isIPad])
		return 42;
	else {
		return 63;
	}
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
	
	/*
	if ([AppHelper isIPad]) {
		AFGraphViewController* aGraphController = [[AFGraphViewController alloc] init];
		
		UIPopoverController* aPopover = [[UIPopoverController alloc]
										 
										 initWithContentViewController:aGraphController];
		aPopover.popoverContentSize = CGSizeMake(640, 640);
		
		[aPopover presentPopoverFromRect:CGRectZero inView:self.view.superview.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		
		self.graphController = aGraphController;
		self.popoverController = aPopover;
		
		[aPopover release];
		[aGraphController release];
	}*/
	
	
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
	[sortKey release];
	[processNames release];
    [super dealloc];
}


@end

