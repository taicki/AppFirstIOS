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

#import "AC_ApplicationDetailPad.h"
#import "AppStrings.h"
#import "config.h"


@implementation AC_ApplicationDetailPad
@synthesize detailController, processesController, application;

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
    [application release];
    [detailController release];
    [processesController release];
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
    self.navigationItem.title = @"Application detail";
    
    self.detailController = [[AC_ApplicationDetailViewController alloc]  initWithNibName:@"AC_ApplicationDetailViewController" bundle:nil];
    [detailController setApplication:application];
    self.detailController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.7);
    [self.view addSubview:self.detailController.view];
    [self.detailController viewWillAppear:YES];
    
    self.processesController = [[AC_ProcessListContainerViewController alloc]  initWithNibName:@"AC_ProcessListContainerViewController" bundle:nil];
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%d/processes/", 
                           [AppStrings appfirstServerAddress], 
                           [AppStrings applicationListUrl], 
                           [application uid]];
    [[self processesController] setResourceUrl:urlString];
    processesController.view.frame = CGRectMake(0, self.view.frame.size.height * 0.7 + 30 , self.view.frame.size.width, self.view.frame.size.height * 0.3 - 30);
    [self.view addSubview:self.processesController.view];
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
	return YES;
}

@end
