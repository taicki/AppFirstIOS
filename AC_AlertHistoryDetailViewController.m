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

#import "AC_AlertHistoryDetailViewController.h"
#import "AFWidgetBaseView.h"
#import "AppComm.h"
#import "AppStrings.h"
#import "config.h"

@implementation AC_AlertHistoryDetailViewController
@synthesize alert_history, responseData, scrollView, myData;

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
    [responseData release];
    [scrollView release];
    [myData release];
    [alert_history release];
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
    
    aTextView.frame = CGRectMake(IPHONE_WIDGET_PADDING, positionTop, width, size.height + 5);
    [nameView addSubview:aTextView];
    [aTextView release];
    return size.height + 5;
    
}
- (float) createNameView: (float) topPadding  {
    AFWidgetBaseView* nameView = [[AFWidgetBaseView alloc] initWithFrame:CGRectMake(IPHONE_WIDGET_PADDING, 
                                                                                    IPHONE_WIDGET_PADDING, 
                                                                                    self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2, 10000)];
    topPadding += IPHONE_WIDGET_PADDING * 2;
    NSString* text = [myData text];
    topPadding += [self createTextView: text nameView: nameView paddingTop:topPadding];
    nameView.frame = CGRectMake(IPHONE_WIDGET_PADDING, IPHONE_WIDGET_PADDING, self.view.frame.size.width - IPHONE_WIDGET_PADDING * 2, topPadding + IPHONE_WIDGET_PADDING * 3);
    [self.scrollView addSubview:nameView];
	[nameView release];
    return  topPadding;
}

- (void) renderView{
    float topPadding = IPHONE_WIDGET_PADDING;
    topPadding = [self createNameView: topPadding];
    [[self scrollView] setContentSize:CGSizeMake(self.view.frame.size.width, topPadding + 40)];
}
- (void) finishLoading:(NSString*)theJobToDo {
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[connection release];
	
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	@try {
		NSDictionary *dictionary = (NSDictionary*)[jsonString JSONValue];
        myData = [[AM_AlertHistoryData alloc] initWithJSONObject:dictionary];
        [jsonString release];
        [self renderView];
        [self.view addSubview:self.scrollView];
        self.navigationItem.title = @"message detail";
    }
	@catch (NSException * e) {
		NSLog(@"main: Caught %@: %@", [e name], [e reason]);
		return;
	}
}

- (void) getData
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/message/", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings alertHistoryUrl], 
                           [alert_history uid]];
    NSLog(@"%@", urlString);
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
      
    self.navigationItem.title = @"Updating...";
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
