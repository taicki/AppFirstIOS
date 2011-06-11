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

#import "AC_ServerListViewController.h"
#import "AppDelegate_Shared.h"
#import "AFServerPageViewController.h"
#import "ServerDetailViewPad.h"
#import "AM_Server.h"
#import "AppHelper.h"
#import "config.h"


@implementation AC_ServerListViewController

- (void) setStoppedServerList:(NSMutableArray *)list {
    [list retain];
    [stoppedServerList release];
    stoppedServerList = list;
}

- (void) setRunningServerList:(NSMutableArray *)list {
    [list retain];
    [runningServerList release];
    runningServerList = list;
}

- (void) reloadView {
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSMutableArray* list = [appDelegate serverList];
    NSMutableArray* newRunningServers = [[NSMutableArray alloc] init];
    NSMutableArray* newStoppedServers = [[NSMutableArray alloc] init];
    for (int i = 0; i < [list count]; i++) {
        AM_Server* server = [list objectAtIndex:i];
        if ([server isRunning]) {
            [newRunningServers addObject:server];
        } else {
            [newStoppedServers addObject:server];
        }
    }
    
    [self setRunningServerList:newRunningServers];
    [self setStoppedServerList:newStoppedServers];
    [newRunningServers release];
    [newStoppedServers release];
    [self.tableView reloadData];
    self.navigationItem.title = @"Severs";
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
    [runningServerList release];
    [stoppedServerList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc that aren't in use.
}

- (void) refreshData {
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.title = @"Updating...";
    self.tableView.userInteractionEnabled = NO;
    [appDelegate refreshServerList];
    [self reloadView];
    self.tableView.userInteractionEnabled = YES;
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
									  target:self 
									  action:@selector(refreshData)];
	refreshButton.style = UIBarButtonItemStyleBordered;
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadView];
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
        return [runningServerList count];
    } else {
        return  [stoppedServerList count];
    }
}

- (void) setCellIcon: (AM_Server *) server cell: (UITableViewCell *) cell  {
    UIImage* theImage;
	NSString* path;
	NSString* osType = [server os];
	
	if ([osType isEqualToString:@"Linux"]) {
		path = [[NSBundle mainBundle] pathForResource:@"linux-icon" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	} else {
		path = [[NSBundle mainBundle] pathForResource:@"windows-icon" ofType:@"png"];
		theImage = [UIImage imageWithContentsOfFile:path];
	}
	
	cell.imageView.image = theImage;

}
- (void) setCellText: (AM_Server *) server cell: (UITableViewCell *) cell indexPath: (NSIndexPath *) indexPath  {
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        @try{	
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [server hostname];
        }
        @catch (NSException* exception) {
            NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
            cell.detailTextLabel.text = @"N/A";
        }
    } else if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [server hostname];
    }
    
    if ([AppHelper isIPad] == NO) {
		cell.textLabel.font = [UIFont boldSystemFontOfSize:IPHONE_TABLE_TITLESIZE];
	}

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AM_Server* server;
    if (indexPath.section == 1) {
        server = [stoppedServerList objectAtIndex:indexPath.row];
    } else {
        server = [runningServerList objectAtIndex:indexPath.row];
    }
    [self setCellText: server cell: cell indexPath: indexPath];
    [self setCellIcon: server cell: cell];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Collector Running Servers";
	else
		return @"Collector Stopped Servers";
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
    if (indexPath.section == 0) {
        if ([AppHelper isIPad]) {
            ServerDetailViewPad* detailViewController = [[ServerDetailViewPad alloc] initWithNibName:@"ServerDetailViewPad" bundle:nil];
            AM_Server* server = [runningServerList objectAtIndex:indexPath.row];
            [detailViewController setServer:server];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        } else {
            AFServerPageViewController* detailViewController = [[AFServerPageViewController alloc] initWithNibName:@"AFServerPageViewController" bundle:nil];
            AM_Server* server = [runningServerList objectAtIndex:indexPath.row];
            [detailViewController setServer:server];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
            
        }
    }
}

@end
