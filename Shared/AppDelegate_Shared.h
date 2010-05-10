//
//  AppDelegate_Shared.h
//  AppFirst
//
//  Created by appfirst on 5/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AFAlert.h"
#import "AFDashboard.h"
#import "LoginViewController.h"

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    UIWindow *window;
	UITabBarController *tabcontroller;
	LoginViewController *loginController;
	AFAlert *alertController;
	AFDashboard *dashboardController;
	
	NSArray *availableCookies;
	
	NSString *urlBase;
	NSString *loginUrl;
	NSString *serverListUrl;
	
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabcontroller;
@property (nonatomic, retain) IBOutlet LoginViewController *loginController;

@property (nonatomic, retain) IBOutlet AFAlert *alertController;
@property (nonatomic, retain) IBOutlet AFDashboard *dashboardController;

@property (nonatomic, retain) NSArray* availableCookies;

@property (nonatomic, retain) NSString* urlBase;
@property (nonatomic, retain) NSString* loginUrl;
@property (nonatomic, retain) NSString* serverListUrl;

- (NSString *)applicationDocumentsDirectory;

@end

