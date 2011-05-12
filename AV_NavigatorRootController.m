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

#import "AV_NavigatorRootController.h"
#import "AppDelegate_Shared.h"
#import "AC_ServerListViewController.h"
#import "AC_AlertListViewController.h"
#import "AC_PolledDataListViewController.h"
#import "AC_ApplicationListViewController.h"
#import "AC_AlertHistoryListViewController.h"


@implementation AV_NavigatorRootController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
                // Custom initialization
    }
    return self;
}

- (void) setItems:(NSMutableArray *)newItems {
    [newItems retain];
    [items release];
    items = newItems;
}

- (void)dealloc
{
    [items release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) addRootViewData:(NSMutableArray*)newItems WithName:(NSString*) name withCount:(int) count {
    NSMutableDictionary* newItem = [[NSMutableDictionary alloc] init];
    [newItem setValue:name forKey:@"name"];
    [newItem setValue:[NSNumber numberWithInt:count] forKey:@"count"];
    [newItems addObject:newItem];
    [newItem release];
}

#pragma mark - View lifecycle


- (void) _createLogoutButton {
	UIBarButtonItem* logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Sign out"
                                     style:UIBarButtonItemStyleBordered
									 target:self
                                     action:@selector(_logout)];
	self.navigationItem.rightBarButtonItem = logoutButton;
	[logoutButton release];
}

- (void)_logout {
	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	[appDelegate trySignOut];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createLogoutButton];
    items = [[NSMutableArray alloc]init];
    
    
    
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
    [items removeAllObjects];
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    
    [self addRootViewData:items WithName:@"Server" withCount:[[appDelegate serverList] count]];
    [self addRootViewData:items WithName:@"Alert" withCount:[[appDelegate alertList] count]];
    [self addRootViewData:items WithName:@"PolledData" withCount:[[appDelegate polledDataList] count]];
    [self addRootViewData:items WithName:@"Application" withCount:[[appDelegate applicationList] count]];
    [self addRootViewData:items WithName:@"Recent alerts" withCount:[[appDelegate alertHistoryList] count]];
    [self.tableView reloadData];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (items != NULL) {
        return [items count];
    } else {
        return  0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", 
                           [[items objectAtIndex:indexPath.row] objectForKey:@"name"],
                           [[items objectAtIndex:indexPath.row] objectForKey:@"count"]] ;
    
    // Configure the cell...
    
    return cell;
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
    UIViewController* detailViewController;
    if (indexPath.row == 0) {
        detailViewController = [[AC_ServerListViewController alloc] initWithNibName:@"AC_ServerListViewController" bundle:nil];
        // ...
        // Pass the selected object to the new view controller.
                
    } else if (indexPath.row == 1) {
        detailViewController = [[AC_AlertListViewController alloc] initWithNibName:@"AC_AlertListViewController" bundle:nil];
        // ...
        // Pass the selected object to the new view controller.
    } else if (indexPath.row == 2) {
        detailViewController = [[AC_PolledDataListViewController alloc] initWithNibName:@"AC_PolledDataListViewController" bundle:nil];
    } else if (indexPath.row == 3) {
        detailViewController = [[AC_ApplicationListViewController alloc] initWithNibName:@"AC_ApplicationListViewController" bundle:nil];
    } else if (indexPath.row == 4) {
        detailViewController = [[AC_AlertHistoryListViewController alloc] initWithNibName:@"AC_AlertHistoryListViewController" bundle:nil];
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
