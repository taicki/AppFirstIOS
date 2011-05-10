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

#import "AC_PolledDataResourceListViewController.h"
#import "AM_ProcessData.h"
#import "AM_ResourceCell.h"
#import "AV_GenericTableCell.h"
#import "AFCpuDetailView.h"
#import "config.h"
#import "AppComm.h"
#import "JSON.h"
#import "AM_PolledDataData.h"
#import "AC_GraphViewController.h"
#import "AppDelegate_Shared.h"

@implementation AC_PolledDataResourceListViewController
@synthesize responseData, resourceUrl, dataArray, resources;

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
    [resources release];
    [resourceUrl release];
    [responseData release];
    [dataArray release];
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
    [self getData];

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
    return [resources count];
}

- (int) calculateHeight: (int) row {
    int height = IPHONE_TABLE_ROW_HEIGHT;
    return  height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AM_ResourceCell* resource = [resources objectAtIndex:indexPath.row];
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AC_PolledDataResourceListViewController"] autorelease];
    AV_GenericTableCell* cellView = [[AV_GenericTableCell alloc] initWithFrame:CGRectMake(0, 
                                                                                          0, 
                                                                                          tableView.frame.size.width,
                                                                                          [self calculateHeight:indexPath.row])];
    [cellView setData:resource];
    [cell.contentView addSubview: cellView];
    [cellView release];
    
    return cell;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Can't get resource data. " 
														message: [error localizedDescription] 
													   delegate: self 
											  cancelButtonTitle: @"Ok" 
											  otherButtonTitles: nil];
	[errorView show];
	[errorView release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[connection release];
	
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	@try {
        NSMutableArray* newDataArray = (NSMutableArray*)[jsonString JSONValue];
        dataArray = [[NSMutableArray alloc] init];
        for (int cnt = 0; cnt < [newDataArray count]; cnt ++) {
            AM_PolledDataData* data = [[AM_PolledDataData alloc] initWithJSONObject:[newDataArray objectAtIndex:cnt]];
            [dataArray addObject:data];
        }
    }
	@catch (NSException * e) {
		NSLog(@"main: Caught %@: %@", [e name], [e reason]);
		return;
	}
	
	[jsonString release];
    [self.tableView reloadData];
	
}

// this function is responsible for getting data of last hour. 
- (void) getData
{
	responseData = [[NSMutableData data] retain];
    NSLog(@"%@", resourceUrl);
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:resourceUrl]];
	[request setTimeoutInterval:20];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppComm authString] forHTTPHeaderField:@"Authorization"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateHeight:indexPath.row];
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

- (NSMutableArray*) getResourceLabelsByIndex: (int) index dataObject: (AM_ProcessData*) dataObject resourceName: (NSString*) resourceName{
    NSMutableArray* labels = [[[NSMutableArray alloc] init] autorelease];
    switch (index) {
        default:
            [labels addObject:resourceName];
            break;
    }
    return labels;
}


- (NSMutableArray*) getResourceValueByIndex: (int) index dataObject: (AM_PolledDataData*) dataObject {
    NSMutableArray* newArray = [[[NSMutableArray alloc] init] autorelease];
    NSString* key = [[resources objectAtIndex:index] resourceName];
    NSNumber* value = [[[[dataObject values] objectForKey:key] objectAtIndex:1] objectForKey:@"val"];
    [newArray addObject:value];    
    return newArray;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dataArray count] == 0) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Please wait... " 
                                                            message: @"Historical data is still loading."
                                                           delegate: self 
                                                  cancelButtonTitle: @"Ok" 
                                                  otherButtonTitles: nil];
        [errorView show];
        [errorView release];
        return;
    }
    
    AC_GraphViewController* aGraphController = [[AC_GraphViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:aGraphController];
	NSMutableArray* newXvalues = [[NSMutableArray alloc] init];
    NSMutableArray* newYvalues = [[NSMutableArray alloc] init];
    AM_ResourceCell* resource = [resources objectAtIndex:indexPath.row];
    
    for (int cnt = 0; cnt < [dataArray count]; cnt ++) {
        [newXvalues addObject:[NSNumber numberWithLong:[(AM_PolledDataData*)[dataArray objectAtIndex:cnt] time]]];
        [newYvalues addObject:[self getResourceValueByIndex:indexPath.row
                                                 dataObject:[dataArray objectAtIndex:cnt]]];
    }
    
    [aGraphController setupGraph:newXvalues newYvalues:newYvalues newLabels:[self getResourceLabelsByIndex:indexPath.row dataObject:[dataArray objectAtIndex:0] resourceName:[resource resourceName]]];
	// show the navigation controller modally
	AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
	[[appDelegate navigationController] presentModalViewController:navController animated:YES];
	
	// Clean up resources
	[navController release];
	[aGraphController release];
    [newXvalues release];
    [newYvalues release];
}

@end
