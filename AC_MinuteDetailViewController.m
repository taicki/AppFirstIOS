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

#import "AC_MinuteDetailViewController.h"
#import "AppComm.h"
#import "AM_SocketData.h"
#import "AM_ThreadData.h"
#import "AM_LogData.h"
#import "AM_FileData.h"
#import "AppDelegate_Shared.h"
#import "AM_RegistryData.h"

@implementation AC_MinuteDetailViewController
@synthesize myTitle, tabController, resourceUrl, responseData, mytabs;
@synthesize threadController, socketController, fileController, incidentController, registryController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)dealloc
{
    [mytabs release];
    [tabController release];
    [myTitle release];
    [resourceUrl release];
    [responseData release];
    [threadController release];
    [socketController release];
    [fileController release];
    [incidentController release];
    [registryController release];
    [super dealloc];
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

- (void) createSocketTab: (NSMutableDictionary *) newData  {
    NSMutableArray* sockets = [newData objectForKey:@"sockets"];
    NSMutableArray* socketList = [[NSMutableArray alloc] init];
    if ([sockets count] > 0) {
        [mytabs addObject:[[tabController viewControllers] objectAtIndex:0]];
    }
    for (int cnt = 0; cnt < [sockets count]; cnt ++) {
        [socketList addObject:[[AM_SocketData alloc] initWithJSONObject:[sockets objectAtIndex:cnt]]]; 
    }
    [self.socketController setArray:socketList];
    [self.socketController.navigationItem setTitle:[NSString stringWithFormat:@"%d sockets", [sockets count]]];
    [socketList release];
    [self.socketController.tableView reloadData];
}


- (void) createThreadTab: (NSMutableDictionary *) newData  {
    NSMutableArray* objects = [newData objectForKey:@"threads"];
    NSMutableArray* objectList = [[NSMutableArray alloc] init];
    if ([objects count] > 0) {
        [mytabs addObject:[[tabController viewControllers] objectAtIndex:1]];
    }
    for (int cnt = 0; cnt < [objects count]; cnt ++) {
        [objectList addObject:[[AM_ThreadData alloc] initWithJSONObject:[objects objectAtIndex:cnt]]]; 
    }
    [self.threadController setArray:objectList];
    [self.threadController.navigationItem setTitle:[NSString stringWithFormat:@"%d threads", [objects count]]];
    [objectList release];
    [self.threadController.tableView reloadData];
}

- (void) createFileTab: (NSMutableDictionary *) newData  {
    NSMutableArray* objects = [newData objectForKey:@"files"];
    NSMutableArray* objectList = [[NSMutableArray alloc] init];
    if ([objects count] > 0) {
        [mytabs addObject:[[tabController viewControllers] objectAtIndex:2]];
    }
    for (int cnt = 0; cnt < [objects count]; cnt ++) {
        [objectList addObject:[[AM_FileData alloc] initWithJSONObject:[objects objectAtIndex:cnt]]]; 
    }
    [self.fileController setArray:objectList];
    [self.fileController.navigationItem setTitle:[NSString stringWithFormat:@"%d files", [objects count]]];
    [objectList release];
    [self.fileController.tableView reloadData];
}

- (void) createRegistryTab: (NSMutableDictionary *) newData  {
    NSMutableArray* objects = [newData objectForKey:@"registries"];
    NSMutableArray* objectList = [[NSMutableArray alloc] init];
    if ([objects count] > 0) {
        [mytabs addObject:[[tabController viewControllers] objectAtIndex:4]];
    }
    for (int cnt = 0; cnt < [objects count]; cnt ++) {
        [objectList addObject:[[AM_RegistryData alloc] initWithJSONObject:[objects objectAtIndex:cnt]]]; 
    }
    [self.registryController setArray:objectList];
    [self.registryController.navigationItem setTitle:[NSString stringWithFormat:@"%d registries", [objects count]]];
    [objectList release];
    [self.registryController.tableView reloadData];
}

- (void) createLogTab: (NSMutableDictionary *) newData  {
    NSMutableArray* objects = [newData objectForKey:@"logs"];
    NSMutableArray* objectList = [[NSMutableArray alloc] init];
    if ([objects count] > 0) {
        [mytabs addObject:[[tabController viewControllers] objectAtIndex:3]];
    }
    for (int cnt = 0; cnt < [objects count]; cnt ++) {
        [objectList addObject:[[AM_LogData alloc] initWithJSONObject:[objects objectAtIndex:cnt]]]; 
    }
    [self.incidentController setArray:objectList];
    [self.incidentController.navigationItem setTitle:[NSString stringWithFormat:@"%d incidents", [objects count]]];
    [objectList release];
    [self.incidentController.tableView reloadData];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[connection release];
	
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	
	@try {
        NSMutableDictionary* newData = (NSMutableDictionary*)[jsonString JSONValue];
        mytabs = [[NSMutableArray alloc] init];
        [self createSocketTab: newData];
        [self createThreadTab: newData];
        [self createLogTab: newData];
        [self createFileTab: newData];
        [self createRegistryTab: newData];
        [self.view addSubview:self.tabController.view];
        AppDelegate_Shared* appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window makeKeyAndVisible];
        
        [tabController setViewControllers:mytabs];
    }
	@catch (NSException * e) {
		NSLog(@"main: Caught %@: %@", [e name], [e reason]);
		return;
	}
	
	[jsonString release];
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
    
    
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self
                                               action:@selector(dismissView)] autorelease];
    self.navigationItem.title = [self title];
    self.tabController.view.frame = self.view.frame;
    [self getData];
}

- (void) dismissView
{
	[self dismissModalViewControllerAnimated:YES];
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
