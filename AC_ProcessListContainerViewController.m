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

#import "AC_ProcessListContainerViewController.h"
#import "config.h"
#import "AFWidgetBaseView.h"
#import "AM_Process.h"
#import "AM_ResourceCell.h"
#import "AV_GenericTableCell.h"
#import "AFCpuDetailView.h"
#import "AppComm.h"
#import "AppHelper.h"
#import "JSON.h"
#import "AC_GraphViewController.h"
#import "AC_ProcessListViewController.h"
#import "AppDelegate_Shared.h"


@implementation AC_ProcessListContainerViewController
@synthesize resourceUrl, processes, responseData, processListController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void) createSubView {
  AFWidgetBaseView* background = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
                                                                                      IPHONE_WIDGET_PADDING, 
                                                                                      self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2, self.view.frame.size.height - IPHONE_WIDGET_PADDING * 2)];
    background.widgetNameLabelText = [NSString stringWithFormat:@"Processes: %d", [processes count]];
    
    
    processListController = [[AC_ProcessListViewController alloc]  initWithNibName:@"AC_ProcessListViewController" bundle:nil];
    
    processListController.view.frame = CGRectMake(IPHONE_WIDGET_PADDING , IPHONE_WIDGET_PADDING + 25, self.view.frame.size.width-IPHONE_WIDGET_PADDING * 4, self.view.frame.size.height - IPHONE_WIDGET_PADDING * 2 - 40);
    [processListController setProcesses:processes];
    [background addSubview:processListController.view];
    [self.view addSubview:background];
    
    [background release];

}
- (void) parseProcesses: (NSString *) jsonString  {
  @try {
        NSMutableArray* newDataArray = (NSMutableArray*)[jsonString JSONValue];
        processes = [[NSMutableArray alloc] init];
        NSString* sortKey = @"name";
        [AppHelper sortArrayByKey: sortKey dictionary: newDataArray];
        
        for (int cnt = 0; cnt < [newDataArray count]; cnt ++) {
            AM_Process* process = [[AM_Process alloc] initWithJSONObject:[newDataArray objectAtIndex:cnt]];
            [processes addObject:process];
        }
    }
	@catch (NSException * e) {
		NSLog(@"main: Caught %@: %@", [e name], [e reason]);
		return;
	}
	
	[jsonString release];

}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[self parseProcesses: jsonString];
    [self createSubView];
}

// this function is responsible for getting data of last hour. 
- (void) getData
{
	responseData = [[NSMutableData data] retain];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:resourceUrl]];
	[request setTimeoutInterval:20];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppComm authString] forHTTPHeaderField:@"Authorization"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)dealloc
{
    [responseData release];
    [processes release];
    [resourceUrl release];
    [processListController release];
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
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
