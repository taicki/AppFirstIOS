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

#import "AC_AlertHistoryListViewController.h"
#import "AM_AlertHistory.h"
#import "config.h"
#import "AC_AlertHistoryDetailViewController.h"
#import "AppDelegate_Shared.h"
#import "AppHelper.h"


@implementation AC_AlertHistoryListViewController

- (void) setAlertHistories:(NSMutableArray *)list {
    [list retain];
    [alertHistories release];
    alertHistories = list;
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
    [alertHistories release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) reloadView {
    
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSMutableArray* list = [appDelegate alertHistoryList];
    [self setAlertHistories:list];
    [self.tableView reloadData];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [AppHelper formatShortDateString:[NSDate date]]];
}


- (void) refreshData {
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    self.navigationItem.title = @"Updating...";
    self.tableView.userInteractionEnabled = NO;
    [appDelegate loadAlertHistoryList];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) resetBadgeValue {
	NSHTTPURLResponse *response;
	NSError *error = nil;
	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
	NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:appDelegate.availableCookies];
	NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc] init] autorelease];
	
	NSString *url = [NSString stringWithFormat:@"%@%@", PROD_SERVER_IP, BADGE_SET_API_STRING];
	
	if ([UIApplication sharedApplication].applicationIconBadgeNumber == 0) 
		return;
	
	postRequest.URL = [NSURL URLWithString:url];
	
	NSString *postData = [NSString stringWithFormat:@"uid=%@&badge=%d", appDelegate.UUID, 0];
	
	NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
	
	[postRequest setValue:length forHTTPHeaderField:@"Content-Length"];
	[postRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
	[postRequest setHTTPMethod:@"POST"];
	[postRequest setAllHTTPHeaderFields:headers];
	
	[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
	
	if (error) {
		NSLog(@"%@", [error localizedDescription]);
	}
	
	[NSURLConnection release];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [alertHistories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    AM_AlertHistory* alertHistory = [alertHistories objectAtIndex:indexPath.row];
    cell.textLabel.text = [alertHistory subject];
    cell.textLabel.font = [UIFont systemFontOfSize:IPAD_TABLE_CELL_BIG_FONTSIZE];
    
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
    AC_AlertHistoryDetailViewController* detailViewController = [[AC_AlertHistoryDetailViewController alloc] initWithNibName:@"AC_AlertHistoryDetailViewController" bundle:nil];
    AM_AlertHistory* history = [alertHistories objectAtIndex:indexPath.row];
    [detailViewController setAlert_history:history];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
