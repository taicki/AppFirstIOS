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

#import "S7GraphView.h"


@interface AFGraphViewController : UIViewController <S7GraphViewDataSource> {
	S7GraphView *graphView;
	NSString* queryString;
	NSDictionary* allData;
	NSMutableData* responseData;
	NSMutableArray* xValues;
	NSMutableArray* yValues;
	NSArray* labels;
	NSString* graphTitle;
}
	
@property (nonatomic, retain) S7GraphView *graphView;
@property (nonatomic, retain) NSString* queryString;
@property (nonatomic, retain) NSDictionary* allData;
@property (nonatomic, retain) NSMutableData* responseData;

@property (nonatomic, retain) NSMutableArray* xValues;
@property (nonatomic, retain) NSMutableArray* yValues;
@property (nonatomic, retain) NSArray* labels;

@property (nonatomic, retain) NSString* graphTitle;

- (void) dismissView;
- (void) asyncGetServerData;
@end
