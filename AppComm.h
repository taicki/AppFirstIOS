//
//  AppComm.h
//  AppFirst
//
//  Created by appfirst on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* authString;
@interface AppComm : NSObject {
    
}

+(NSData*) makeGetRequest:(NSString*)url;
+(void) setAuthStringWith:(NSString*) username andPassword: (NSString*) password;

@end
