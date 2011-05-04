//
//  AppDelegate_Shared.h
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright AppFirst Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AFAlert.h"
#import "AFDashboard.h"
#import "LoginViewController.h"
#import "AFAlertHistoryViewController.h"
#import "AV_NavigatorRootController.h"

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    UIWindow *window;
	UITabBarController *tabcontroller;
	LoginViewController *loginController;
	AFAlert *alertController;
	AFDashboard *dashboardController;
	AFAlertHistoryViewController* notificationController;
	NSString* UUID;
	
	NSArray *availableCookies;
	
    
	NSString *urlBase;
	NSString *loginUrl;
	NSString *serverListUrl;
	NSString *alertListUrl;
	
	NSMutableArray *usernames;
    
    
    // new code
    NSMutableArray *serverList;
    NSMutableArray *alertList;
    NSMutableArray *polledDataList;
    NSMutableArray *applicationList;
    NSMutableArray *alertHistoryList;
    
    UINavigationController* navigationViewController;
    AV_NavigatorRootController* homeViewController;
}


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabcontroller;
@property (nonatomic, retain) IBOutlet LoginViewController *loginController;

@property (nonatomic, retain) IBOutlet AFAlert *alertController;
@property (nonatomic, retain) IBOutlet AFDashboard *dashboardController;
@property (nonatomic, retain) IBOutlet AFAlertHistoryViewController* notificationController;

@property (nonatomic, retain) NSArray* availableCookies;
@property (nonatomic, retain) NSString* UUID;

@property (nonatomic, retain) NSString* urlBase;
@property (nonatomic, retain) NSString* loginUrl;
@property (nonatomic, retain) NSString* serverListUrl;
@property (nonatomic, retain) NSString* alertListUrl;
@property (nonatomic, retain) NSMutableArray* usernames;

- (NSString *)applicationDocumentsDirectory;


@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet AV_NavigatorRootController* homeViewController;

- (void) setServerList:(NSMutableArray*) newData;
- (void) setAlertList:(NSMutableArray*) newData;
- (void) setApplicaitonList:(NSMutableArray*) newData;
- (void) setPolledDataList:(NSMutableArray*) newData;
- (void) setAlertHistoryList: (NSMutableArray*) newData;

- (NSMutableArray*) serverList;
- (NSMutableArray*) alertList;
- (NSMutableArray*) applicationList;
- (NSMutableArray*) polledDataList;
- (NSMutableArray*) alertHistoryList;

- (void) loadApplicationList;
- (void) loadAlertList;
- (void) loadServerList;
- (void) loadAlertHistoryList;
- (void) loadPolledDataList;

- (void) addRootViewData:(NSMutableArray*)items WithName:(NSString*) name withCount:(int) count;
- (void) presentAppFirstRootView;

- (void) trySignIn:(id)theJobToDo;
- (void) finishLoading:(id)theJobToDo;
- (void) loginFailed:(NSString*)message;
- (void) trySignOut;
- (void) trySubmitUUID;

@end

