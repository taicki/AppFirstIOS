//
//  AFAlertDetailTableViewController.m
//  AppFirst
//
//  Created by appfirst on 6/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AFAlertDetailTableViewController.h"
#import "AppDelegate_Shared.h"
#import "AppHelper.h"
#import "config.h"

@implementation AFAlertDetailTableViewController
@synthesize alertName, detailData, recipients, alertID;
@synthesize alertEnabled, alertReset;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
	
	self.navigationItem.title = self.alertName;
 
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
		
		NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:appDelegate.availableCookies];
		NSMutableURLRequest *saveAlertPost = [[[NSMutableURLRequest alloc] init] autorelease];
		
		NSString *queryUrl;
		if (DEBUGGING == YES) {
			queryUrl = [NSString stringWithFormat:@"%@%@", DEV_SERVER_IP, ALERT_EDIT_API_STRING];
		} else {
			queryUrl = [NSString stringWithFormat:@"%@%@", PROD_SERVER_IP, ALERT_EDIT_API_STRING];
		}
		
		
		saveAlertPost.URL = [NSURL URLWithString:queryUrl];
		
		if ([self.alertReset.text isEqualToString:@""] || [self.alertReset.text isEqualToString:@"0"])
			self.alertReset.text = @"1";
		
		NSString* alertEnabledString = @"True";
		
		if (self.alertEnabled.on == NO)
			alertEnabledString = @"False";
		
		NSString *postData = [NSString stringWithFormat:@"alert=%@&interval=%@&enabled=%@", self.alertID, self.alertReset.text, alertEnabledString];
		NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
		
		[saveAlertPost setValue:length forHTTPHeaderField:@"Content-Length"];
		[saveAlertPost setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
		[saveAlertPost setHTTPMethod:@"POST"];
		[saveAlertPost setAllHTTPHeaderFields:headers];
		
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
			[errorView show];
			[errorView release];
		}
		
		self.alertEnabled.userInteractionEnabled = NO;
		self.alertReset.userInteractionEnabled = NO;
		appDelegate.alertController.needRefresh = YES;
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self setRecipients:[self.detailData objectForKey:ALERT_RECIPIENTS_NAME]];
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
		return 3;
	} else if (section == 1){
		return 2;
	} else {
		return [self.recipients count];
	}
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
								   [self.detailData objectForKey:ALERT_TYPE_NAME]
								   , [self.detailData objectForKey:ALERT_TARGET_NAME]];
			
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Enabled:";
			self.alertEnabled = [[[UISwitch alloc] initWithFrame:CGRectMake(110, 10, 100, ALERT_CELL_HEIGHT / 2)] autorelease];
			[cell.contentView addSubview:self.alertEnabled];
			self.alertEnabled.userInteractionEnabled = NO;
			
			NSString* enabled = [NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_STATUS_NAME]];
			
			if ([enabled isEqualToString:@"True"]) {
				self.alertEnabled.on = YES;
			} else {
				self.alertEnabled.on = NO;
			}
		} else {
			cell.textLabel.text = @"Reset:                               mins";
			
			
			self.alertReset = [[[UITextField alloc] initWithFrame:CGRectMake(75, 10, 130, 25 )] autorelease];
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
			
		}

	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.detailData objectForKey:ALERT_TRIGGER_TYPE_NAME]];
		} else if (indexPath.row == 1) {
			if ([self.detailData objectForKey:AlERT_LAST_TRIGGER_NAME] != nil) {
				NSDate *triggerTime = [NSDate dateWithTimeIntervalSince1970:[[self.detailData objectForKey:AlERT_LAST_TRIGGER_NAME] doubleValue]];
				cell.textLabel.text = [NSString stringWithFormat:@"Last triggered: %@", [AppHelper formatDateString:triggerTime]];
			} else {
				cell.textLabel.text = @"Last triggered: N/A";
			}	
		} 
	} else {
		cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.recipients objectAtIndex: indexPath.row]];
	}
	
	
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
		return @"Receipients";
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
	[alertName release];
	[detailData release];
	[alertEnabled release];
	[alertReset release];
	[recipients release];
	[alertID release];
    [super dealloc];
}


@end

