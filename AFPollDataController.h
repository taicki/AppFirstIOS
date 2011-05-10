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

#import <UIKit/UIKit.h>
#import "AFPollDataTableViewController.h"

@interface AFPollDataController : UIViewController {
	AFPollDataTableViewController* tableController;
	NSMutableData* responseData;
	NSString* queryUrl;
	NSString* serverPK;
	NSDictionary* detailData;
	UILabel* titleLabel;
	
	
}
- (void) asyncGetServerData;
- (id) initWithPk:(NSString*) pk;

@property (nonatomic, retain) AFPollDataTableViewController* tableController;
@property (nonatomic, retain) NSMutableData* responseData;
@property (nonatomic, retain) NSString* queryUrl;
@property (nonatomic, retain) NSString* serverPK;
@property (nonatomic, retain) NSDictionary* detailData;
@property (nonatomic, retain) UILabel* titleLabel;
@end
