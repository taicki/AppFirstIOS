//
//  AL_Client.h
//  AppFirst
//
//  Created by Bin Liu on 4/19/11.
//  Copyright 2011 AppFirst. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AL_Client : NSObject {
    NSString* authString; // the encoded string to access the data
}

+(void) loadServerObject:(int)id;
+(void) loadAlertObject:(int)id;
+(void) loadProcessObject:(int)id;
+(void) loadApplicationObject:(int)id;
+(void) loadPolledDataObject:(int)id;

+(void) loadServerList;
+(void) loadAlertList;
+(void) loadProcessList;
+(void) loadApplicationList;
+(void) loadPolledDataList;
+(void) loadAlertHistoryList;

+(void) loadServerData:(int)count;
+(void) loadServerData:(int)count notAfter:(int)end notBefore:(int)start;
+(void) loadProcessData:(int)count;
+(void) loadProcessData:(int)count notAfter:(int)end notBefore:(int)start;
+(void) loadAlertData:(int)count;
+(void) loadAlertData:(int)count notAfter:(int)end notBefore:(int)start;
+(void) loadApplicationData:(int)count;
+(void) loadApplicationData:(int)count notAfter:(int)end notBefore:(int)start;
+(void) loadPolledDataData:(int)count;
+(void) loadPolledDataData:(int)count notAfter:(int)end notBefore:(int)start;
+(void) loadAlertHistoryData;
+(void) loadDetailData;

+(void) saveDeviceInfo:(NSString*)uid;
+(void) updateDeviceBadge;
+(void) updateAlertStatus:(Boolean)status alertId:(int)id;


@end