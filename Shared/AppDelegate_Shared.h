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

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    UIWindow *window;
	UITabBarController *tabcontroller;
	AFAlert *alertController;
	AFDashboard *dashboardController;
	
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabcontroller;

@property (nonatomic, retain) IBOutlet AFAlert *alertController;
@property (nonatomic, retain) IBOutlet AFDashboard *dashboardController;

- (NSString *)applicationDocumentsDirectory;

@end

