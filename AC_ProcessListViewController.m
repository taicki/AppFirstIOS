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

#import "AC_ProcessListViewController.h"
#import "AC_ProcessDetailViewController.h"
#import "AM_Process.h"
#import "AM_ResourceCell.h"
#import "AV_GenericTableCell.h"
#import "AFCpuDetailView.h"
#import "config.h"
#import "AppComm.h"
#import "AppHelper.h"
#import "JSON.h"
#import "AC_GraphViewController.h"
#import "AppDelegate_Shared.h"
#import "AFWidgetBaseView.h"

@implementation AC_ProcessListViewController
@synthesize responseData, resourceUrl, processes;

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
    [processes release];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [processes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    // Configure the cell...
    AM_Process* process = [processes objectAtIndex:indexPath.row];
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSDictionary* map = [appDelegate serverIdHostNameMap];
    NSString* server_id = [NSString stringWithFormat:@"%d", [process server_id]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [process name], [map objectForKey:server_id]] ;
    [cell.textLabel setFont:[UIFont systemFontOfSize:IPAD_TABLE_CELL_NORMAL_FONTSIZE]];
    cell.detailTextLabel.numberOfLines = 0;
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    cell.detailTextLabel.text = [process args];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat		width = 0;
	CGFloat		tableViewWidth;
	CGRect		bounds = [UIScreen mainScreen].bounds;
    double height = 0;
    
	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
		tableViewWidth = bounds.size.width;
	else
		tableViewWidth = bounds.size.height;
    
	width = tableViewWidth;		// fudge factor, 115 isn't quite right
	AM_Process* process = [processes objectAtIndex:indexPath.row];
    
	if ([process args])
	{
		// The notes can be of any height
		// This needs to work for both portrait and landscape orientations.
		// Calls to the table view to get the current cell and the rect for the 
		// current row are recursive and call back this method.
		CGSize	textSize = { width, 20000};		// width and height of text area
		CGSize	size = [[process args] sizeWithFont:[UIFont systemFontOfSize:IPAD_TABLE_CELL_NORMAL_FONTSIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
        height = size.height;
        
        size = [[process name] sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
        height += size.height;
        
        if ([AppHelper isIPad]) {
            height += 10;
        }
    }
    
	return height + 10;
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
    AC_ProcessDetailViewController* detailViewController = [[AC_ProcessDetailViewController alloc] initWithNibName:@"AC_ProcessDetailViewController" bundle:nil];
    AM_Process* process = [processes objectAtIndex:indexPath.row];
    [detailViewController setProcess:process];
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	[[appDelegate navigationController] pushViewController:detailViewController animated:NO];
    [detailViewController release];
}

@end
