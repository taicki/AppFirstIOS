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
#import "AC_PolledDataDetailViewController.h"
#import "AFWidgetBaseView.h"
#import "AppDelegate_Shared.h"
#import "config.h"
#import "AppComm.h"
#import "AppStrings.h"
#import "AppHelper.h"
#import "AM_PolledDataData.h"

@implementation AC_PolledDataDetailViewController
@synthesize polledData, responseData, resourceListController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (float) createTextView: (NSString *) text nameView: (AFWidgetBaseView *) nameView paddingTop: (float) paddingTop {
    float positionTop = paddingTop;
    float width = self.view.frame.size.width - IPHONE_WIDGET_PADDING * 4;
    
    CGSize	textSize = { width, 100};		// width and height of text area
    CGSize	size = [text sizeWithFont:[UIFont systemFontOfSize:IPAD_TABLE_CELL_NORMAL_FONTSIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    UILabel* aTextView = [[UILabel alloc] init];
    aTextView.text = text;
    aTextView.numberOfLines = 0;
    aTextView.font = [UIFont systemFontOfSize:IPAD_TABLE_CELL_NORMAL_FONTSIZE];
    
    aTextView.frame = CGRectMake(IPHONE_WIDGET_PADDING, positionTop, width, size.height + 5);
    [nameView addSubview:aTextView];
    [aTextView release];
    return size.height + 5;
    
}
- (float) createNameView: (float) topPadding data: (AM_PolledDataData*) data {
    AFWidgetBaseView* nameView = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
                                                                                    IPHONE_WIDGET_PADDING, 
                                                                                    self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2, 100)];
    [nameView setWidgetNameLabelText:[polledData name]];
    topPadding += 25;
	
    NSString* uid = [NSString stringWithFormat:@"%d", [polledData server_uid]];
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSString* hostname = [[appDelegate serverIdHostNameMap] objectForKey:uid];
    NSString* text = [NSString stringWithFormat:@"Hostname: %@",  hostname];
    topPadding += [self createTextView: text nameView: nameView paddingTop:topPadding];
    text = [NSString stringWithFormat:@"Status: %@",  [data status]];
    topPadding += [self createTextView: text nameView: nameView paddingTop:topPadding];
    
    text = [NSString stringWithFormat:@"Detail: %@",  [data text]];
    topPadding += [self createTextView: text nameView: nameView paddingTop:topPadding];
    nameView.frame = CGRectMake(IPHONE_WIDGET_PADDING, IPHONE_WIDGET_PADDING, self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2, topPadding + IPHONE_WIDGET_PADDING * 2);
    
    [self.view addSubview:nameView];
	[nameView release];
    return  topPadding + IPHONE_WIDGET_PADDING * 3;
}

- (void) createResourceListView: (double) topPadding resources:(NSMutableArray*) resources data:(AM_PolledDataData*) data {
    int resourceViewContainerWidth = self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2;
    int resourceViewContainerHeight = self.view.frame.size.height - topPadding - IPHONE_WIDGET_PADDING;
    AFWidgetBaseView* resourceViewContainer = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, topPadding, 
                                                                                                 resourceViewContainerWidth,resourceViewContainerHeight 
                                                                                                 )];
    NSString *timeText = [NSString stringWithFormat:@"%d parameters at: %@", [resources count], 
                          [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:[data time]]]];
    resourceViewContainer.widgetNameLabelText = timeText;
    
    resourceListController = [[AC_PolledDataResourceListViewController alloc] initWithNibName:@"AC_PolledDataResourceListViewController" bundle:nil];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/data/?num=60", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings polledDataListUrl], 
                           [polledData uid]];
    [resourceListController setResourceUrl:urlString];
    resourceListController.view.frame = CGRectMake(IPHONE_WIDGET_PADDING, 
                                                       IPAD_WIDGET_SECTION_TITLE_HEIGHT + IPHONE_WIDGET_PADDING * 2, 
                                                       resourceViewContainerWidth - IPHONE_WIDGET_PADDING * 2, 
                                                       resourceViewContainerHeight - IPHONE_WIDGET_PADDING * 3 - IPAD_WIDGET_SECTION_TITLE_HEIGHT );
    [resourceListController setResources:resources];
    [resourceViewContainer addSubview:resourceListController.view];
    [self.view addSubview: resourceViewContainer];
        //[resourceListController release];
}



- (void)dealloc
{
    [resourceListController release];
    [polledData release];
    [responseData release];
    [super dealloc];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSMutableArray* resources = [[NSMutableArray alloc] init];
	
	@try {
        self.navigationItem.title = [NSString stringWithFormat:@"Updated at: %@", [AppHelper formatDateString:[NSDate date]]];
		NSDictionary *dictionary = [(NSMutableArray*)[jsonString JSONValue] objectAtIndex:0];
        AM_PolledDataData* data = [[AM_PolledDataData alloc] initWithJSONObject:dictionary];
        [data generateResourceArray:resources];
        float topPadding = IPHONE_WIDGET_PADDING;
        topPadding += [self createNameView:IPHONE_WIDGET_PADDING data:data];
        [self createResourceListView: topPadding + IPHONE_WIDGET_PADDING * 2 resources:resources data: data];
        [resources release];
        [jsonString release];
        [data release];
    }
	@catch (NSException * e) {
		NSLog(@"main: Caught %@: %@", [e name], [e reason]);
		return;
	}
}

- (void) getData
{
    self.navigationItem.title = @"updating...";
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/data/", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings polledDataListUrl], 
                           [polledData uid]];
	responseData = [[NSMutableData data] retain];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setHTTPMethod:@"GET"];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setTimeoutInterval:20];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[AppComm authString] forHTTPHeaderField:@"Authorization"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"Can't update server detail. " 
														message: [error localizedDescription] 
													   delegate: self 
											  cancelButtonTitle: @"Ok" 
											  otherButtonTitles: nil];
	[errorView show];
	[errorView release];
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
