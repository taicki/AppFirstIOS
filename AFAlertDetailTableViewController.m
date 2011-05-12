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

#import "AFAlertDetailTableViewController.h"
#import "AppDelegate_Shared.h"
#import "AppHelper.h"
#import "AppStrings.h"
#import "config.h"
#import "AppComm.h"

@implementation AFAlertDetailTableViewController
@synthesize alert;
@synthesize alertEnabled, alertReset;


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
	
	self.navigationItem.title = [alert name];
 
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleNone;
}





- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    if(editing)
    {
		self.alertReset.userInteractionEnabled = YES;
		self.alertEnabled.userInteractionEnabled = YES;
    
	}
    else
    {
		NSHTTPURLResponse *response;
		NSError *error = nil;
		
		AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
		
		NSMutableURLRequest *saveAlertPost = [[[NSMutableURLRequest alloc] init] autorelease];
		
		NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/", 
                               [AppStrings appfirstServerAddress], 
                               [AppStrings alertListUrl], 
                               [alert uid]];
		
		
		saveAlertPost.URL = [NSURL URLWithString:urlString];

		NSString* alertEnabledString = @"true";
		
		if (self.alertEnabled.on == NO)
			alertEnabledString = @"false";
		
		NSString *postData = [NSString stringWithFormat:@"id=%d&active=%@", [alert uid], alertEnabledString];
		NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
		
		[saveAlertPost setValue:length forHTTPHeaderField:@"Content-Length"];
		[saveAlertPost setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
		[saveAlertPost setHTTPMethod:@"PUT"];
		[saveAlertPost setValue:[AppComm authString] forHTTPHeaderField:@"Authorization"];
        
		[NSURLConnection sendSynchronousRequest:saveAlertPost returningResponse:&response error:&error];
		if (error) {
			UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Could not save alert. " 
																message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
			[errorView show];
			[errorView release];
			return;
		} else {
			UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Alert saved. " 
																message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
            for (int cnt = 0; cnt < [[appDelegate alertList] count]; cnt ++) {
                AM_Alert* oldAlert = [[appDelegate alertList] objectAtIndex:cnt];
                if ([oldAlert uid] == [alert uid]) {
                    [oldAlert setActive:self.alertEnabled.on];
                    break;
                }
            }
			[errorView show];
			[errorView release];
		}
		
		self.alertEnabled.userInteractionEnabled = NO;
		self.alertReset.userInteractionEnabled = NO;
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//[self setRecipients:[self.detailData objectForKey:ALERT_RECIPIENTS_NAME]];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
}

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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
		return 2;
	} else if (section == 1){
		return 2;
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
		
			cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", 
								   [alert name]
								   , [alert target]];
			cell.textLabel.numberOfLines = 0;
			
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Enabled:";
			self.alertEnabled = [[[UISwitch alloc] initWithFrame:CGRectMake(130, 10, 100, ALERT_CELL_HEIGHT / 2)] autorelease];
			[cell.contentView addSubview:self.alertEnabled];
			self.alertEnabled.userInteractionEnabled = NO;
			
			if ([alert isActive]) {
				self.alertEnabled.on = YES;
			} else {
				self.alertEnabled.on = NO;
			}
		} else {
            /*
			cell.textLabel.text = @"Reset (in minutes):";
			
			
			self.alertReset = [[[UITextField alloc] initWithFrame:CGRectMake(130, 10, 100, 25 )] autorelease];
			[self.alertReset setBorderStyle:UITextBorderStyleRoundedRect];
			
			if ([[NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_RESET_NAME]] isEqualToString:@""] == NO) {
				self.alertReset.text = [NSString stringWithFormat:@"%@", 
										[[[self.detailData objectForKey:ALERT_RESET_NAME] stringByReplacingOccurrencesOfString:@" mins" withString:@""] stringByReplacingOccurrencesOfString:@" min" withString:@""]];
			} else {
				self.alertReset.text = @"";
			}
			self.alertReset.keyboardType = UIKeyboardTypeNumberPad;
			//self.alertReset.font = [UIFont systemFontOfSize:ALERT_TAB_NORMAL_FONT_SIZE];
			alertReset.userInteractionEnabled = NO;
			[cell.contentView addSubview:self.alertReset];
			*/
		}

	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = [NSString stringWithFormat:@"%@", [alert type]];
		} else if (indexPath.row == 1) {
			if ([alert last_triggered] > 0) {
				NSDate *triggerTime = [NSDate dateWithTimeIntervalSince1970:[alert last_triggered]];
				cell.textLabel.text = [NSString stringWithFormat:@"Last triggered: %@", [AppHelper formatDateString:triggerTime]];
			} else {
				cell.textLabel.text = @"Last triggered: N/A";
			}	
		} 
	} else {
		//cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.recipients objectAtIndex: indexPath.row]];
	}
	
	cell.textLabel.font = [UIFont systemFontOfSize:13];
	
	
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Target";
	else if (section == 1) 
		return @"Trigger";
	else
		return @"Recipients";
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
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
	[alertEnabled release];
	[alertReset release];
	[alert release];
    [super dealloc];
}


@end

