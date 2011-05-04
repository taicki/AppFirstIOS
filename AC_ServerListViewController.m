//
//  AC_ServerListViewController.m
//  AppFirst
//
//  Created by appfirst on 4/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AC_ServerListViewController.h"
#import "AppDelegate_Shared.h"
#import "AFPageViewController.h"
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
            //long stopTime = server  / 1000;
            //NSString *timeText = [NSString stringWithFormat:@"%@: %@", @"Stopped at", 
            //					  [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:stopTime]]];
        
            //cell.detailTextLabel.text = timeText;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [server hostname];
        }
        @catch (NSException* exception) {
            NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
            cell.detailTextLabel.text = @"N/A";
        }
    } else if (indexPath.section == 0) {
        // only able to select on running collectors
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
        AFPageViewController* detailViewController = [[AFPageViewController alloc] initWithNibName:@"AFPageViewController" bundle:nil];
        AM_Server* server = [runningServerList objectAtIndex:indexPath.row];
        [detailViewController setServer:server];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    }
    
    
    
}

@end
