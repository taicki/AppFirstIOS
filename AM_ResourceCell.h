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

#import <Foundation/Foundation.h>

typedef enum {
    AF_NormalCell,
    AF_GraphCell,
    AF_ExtendedGraphCell
    
} AM_ResourceCellOption;

typedef enum {
    AF_Bar, 
    AF_Pie
} AM_ResourceGraphOption;


@interface AM_ResourceCell : NSObject {
    NSString* resourceName;
    NSString* resourceType;
    NSString* resourceUrl;
    NSString* resourceDetail;
    NSNumber* resourceValue;
    NSNumber* time;
    AM_ResourceCellOption renderOption;
    NSDictionary* extra;
    
}

@property (nonatomic, retain) NSString *resourceName;
@property (nonatomic, retain) NSString *resourceType;
@property (nonatomic, retain) NSString *resourceUrl;
@property (nonatomic, retain) NSString *resourceDetail;
@property (nonatomic, retain) NSNumber *resourceValue;
@property (nonatomic, retain) NSNumber *time;
@property (nonatomic, retain) NSDictionary* extra;

@property (nonatomic, assign) AM_ResourceCellOption renderOption;
@property (nonatomic, assign) AM_ResourceGraphOption graphOption;

@end
