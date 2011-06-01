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

#import "AC_ProcessDetailViewController.h"
#import "AFWidgetBaseView.h"
#import "AC_MinuteDetailViewController.h"
#import "AppDelegate_Shared.h"
#import "AM_ProcessData.h"
#import "config.h"
#import "AppComm.h"
#import "AppHelper.h"
#import "AppStrings.h"

@implementation AC_ProcessDetailViewController
@synthesize process, responseData, dataTime;
@synthesize scrollView, detailButton, resourceListViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [resourceListViewController release];
    [scrollView release];
    [process release];
    [responseData release];
    [activityIndicator release];
    [super dealloc];
}

- (float) createTextView: (NSString *) text nameView: (AFWidgetBaseView *) nameView paddingTop: (float) paddingTop {
    float positionTop = paddingTop;
    float width = self.view.frame.size.width - IPHONE_WIDGET_PADDING * 4;
    
    CGSize	textSize = { width, 10000};		// width and height of text area
    CGSize	size = [text sizeWithFont:[UIFont systemFontOfSize:IPAD_TABLE_CELL_NORMAL_FONTSIZE] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    UILabel* aTextView = [[UILabel alloc] init];
    aTextView.text = text;
    aTextView.numberOfLines = 0;
    aTextView.font = [UIFont systemFontOfSize:IPAD_TABLE_CELL_NORMAL_FONTSIZE];
    
    aTextView.frame = CGRectMake(IPHONE_WIDGET_PADDING, positionTop, width, size.height + IPHONE_WIDGET_PADDING);
    [nameView addSubview:aTextView];
    [aTextView release];
    return size.height + IPHONE_WIDGET_PADDING;

}
- (float) createNameView: (float) topPadding  {
    AFWidgetBaseView* nameView = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
                                                                                    IPHONE_WIDGET_PADDING, 
                                                                                    self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2, 100)];
    NSString* aTitle = [NSString stringWithFormat:@"%@ (pid: %d)", [process name], [process pid]];
    [nameView setWidgetNameLabelText:aTitle];
    topPadding += 25;
	
    NSString* uid = [NSString stringWithFormat:@"%d", [process server_id]];
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
    NSString* hostname = [[appDelegate serverIdHostNameMap] objectForKey:uid];
    NSString* text = [NSString stringWithFormat:@"Hostname: %@",  hostname];
    topPadding += [self createTextView: text nameView: nameView paddingTop:topPadding];
    text = [NSString stringWithFormat:@"Command line: %@", [process args]];
    topPadding += [self createTextView: text  nameView: nameView paddingTop: topPadding];
    topPadding += IPHONE_WIDGET_PADDING * 2;
    nameView.frame = CGRectMake(IPHONE_WIDGET_PADDING, IPHONE_WIDGET_PADDING, self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2, topPadding);
    [self.scrollView addSubview:nameView];
	[nameView release];
    
    return  topPadding;
}

- (void) createInfoButton: (UIView*) container {
    [self setDetailButton: [[UIButton buttonWithType:UIButtonTypeInfoDark] autorelease]];
    self.detailButton.frame = CGRectMake(self.view.frame.size.width - 30, 2, 20, 20);
    [self.detailButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:self.detailButton];
}

- (void) showDetailView: (id) sender {
    AC_MinuteDetailViewController* detailController = [[AC_MinuteDetailViewController alloc] init];
    AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
	
	NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/detail/?time=%lld", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings processListUrl], 
                           [process uid],
                           [self dataTime]];
    NSString* title = [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:[self dataTime]]];
    [detailController setResourceUrl:urlString];
    [detailController setMyTitle:title];
    [[appDelegate navigationController] presentModalViewController:detailController animated:NO];
    [detailController release];
}


- (void) createResourceListView: (double) topPadding resources:(NSMutableArray*) resources data:(AM_ProcessData*) data {
    int resourceViewContainerWidth = self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2;
    int resourceViewContainerHeight = self.view.frame.size.height;// + 500 - topPadding - IPHONE_WIDGET_PADDING;
    if ([AppHelper isIPad]) {
        resourceViewContainerHeight =  self.view.frame.size.height - topPadding ;
    }
    AFWidgetBaseView* resourceViewContainer = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, topPadding, 
                                                                                                 resourceViewContainerWidth,resourceViewContainerHeight 
                                                                                                 )];
    [self createInfoButton:resourceViewContainer];
    NSString *timeText = [NSString stringWithFormat:@"Resource usage at: %@", 
                          [AppHelper formatDateString:[NSDate dateWithTimeIntervalSince1970:[data time]]]];
    [self setDataTime:[data time]];
    resourceViewContainer.widgetNameLabelText = timeText;
    
    resourceListViewController = [[AC_ProcessResourceListViewController alloc] initWithNibName:@"AC_ProcessResourceListViewController" bundle:nil];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/data/?num=60", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings processListUrl], 
                           [process uid]];
    [resourceListViewController setResourceUrl:urlString];
    resourceListViewController.view.frame = CGRectMake(IPHONE_WIDGET_PADDING, 
                                                       IPAD_WIDGET_SECTION_TITLE_HEIGHT + IPHONE_WIDGET_PADDING * 2, 
                                                       resourceViewContainerWidth - IPHONE_WIDGET_PADDING * 2, 
                                                       resourceViewContainerHeight - IPHONE_WIDGET_PADDING * 3 - IPAD_WIDGET_SECTION_TITLE_HEIGHT );
    [resourceListViewController setResources:resources];
    [resourceViewContainer addSubview:resourceListViewController.view];
    [self.scrollView addSubview: resourceViewContainer];
        //[resourceViewContainer release];
}

- (void) renderView: (NSMutableArray*) resources data:(AM_ProcessData*) data{
    float topPadding = IPHONE_WIDGET_PADDING;
    topPadding = [self createNameView: topPadding];
    [self createResourceListView: topPadding + IPHONE_WIDGET_PADDING * 2 resources:resources data: data];
    [[self scrollView] setContentSize:CGSizeMake(self.view.frame.size.width, topPadding + resourceListViewController.view.frame.size.height + 30)];
}
- (void) finishLoading:(NSString*)theJobToDo {
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[connection release];
    [activityIndicator stopAnimating];
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSMutableArray* resources = [[NSMutableArray alloc] init];
	
	@try {
        self.navigationItem.title = [NSString stringWithFormat:@"Updated at: %@", [AppHelper formatShortDateString:[NSDate date]]];
		NSDictionary *dictionary = [(NSMutableArray*)[jsonString JSONValue] objectAtIndex:0];
        AM_ProcessData* data = [[AM_ProcessData alloc] initWithJSONObject:dictionary];
        [data generateResourceArray:resources];
        [jsonString release];
        [self renderView:resources data:data];
        [self.view addSubview:self.scrollView];
        [resources release];
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
                           [AppStrings processListUrl], 
                           [process uid]];
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
    [activityIndicator stopAnimating];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     activityIndicator.center = self.view.center;
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
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    activityIndicator.center = self.view.center;
	[self.view addSubview: activityIndicator];
    
    
    
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
