//
//  AC_AlertListViewController.m
//  AppFirst
//
//  Created by appfirst on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AC_AlertListViewController.h"
#import "AppDelegate_Shared.h"
#import "AM_Alert.h"
#import "AppHelper.h"
#import "config.h"


@implementation AC_AlertListViewController

- (void) setNormalAlerts:(NSMutableArray *)alerts {
    [alerts retain];
    [normalAlerts release];
    normalAlerts = alerts;
}

- (void) setInIncidentAlerts:(NSMutableArray *)alerts {
    [alerts retain];
    [inIncidentAlerts release];
    inIncidentAlerts = alerts;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSMutableArray* list = [appDelegate alertList];
    NSMutableArray* newInIncidentAlerts = [[NSMutableArray alloc] init];
    NSMutableArray* newNormalAlerts = [[NSMutableArray alloc] init];
    for (int i = 0; i < [list count]; i++) {
        AM_Alert* alert = [list objectAtIndex:i];
        if ([alert isIn_incident]) {
            [newInIncidentAlerts addObject:alert];
        } else {
            [newNormalAlerts addObject:alert];
        }
    }
    [self setInIncidentAlerts:newInIncidentAlerts];
    [self setNormalAlerts:newNormalAlerts];
    [newNormalAlerts release];
    [newInIncidentAlerts release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [inIncidentAlerts count];
    } else {
        return [normalAlerts count];
    }
}

- (void) setCellText: (AM_Alert *) alert cell: (UITableViewCell *) cell  {
  cell.textLabel.text = [alert name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([AppHelper isIPad] == NO) {
		cell.textLabel.font = [UIFont boldSystemFontOfSize:IPHONE_TABLE_TITLESIZE];
	}

}
- (void) setCellIcon: (NSIndexPath *) indexPath cell: (UITableViewCell *) cell  {
  UIImage* theImage;
	NSString* path;
    if (indexPath.section == 0) {
        path = [[NSBundle mainBundle] pathForResource:@"red_status" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
    } else {
        path = [[NSBundle mainBundle] pathForResource:@"green_status" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
    }
	
	cell.imageView.image = theImage;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AM_Alert* alert;
    if (indexPath.section == 0) {
        alert = [inIncidentAlerts objectAtIndex:indexPath.row];
        
    } else {
        alert = [normalAlerts objectAtIndex:indexPath.row];
    }
    
    [self setCellText: alert cell: cell];
    [self setCellIcon: indexPath cell: cell];

    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Alerts in incident";
	else
		return @"Alerts in normal state";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
