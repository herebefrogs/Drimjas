//
//  WorkingTitleAppDelegate.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartupViewController;
@class EstimatesViewController;

@interface WorkingTitleAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	IBOutlet StartupViewController *startupViewController;
	IBOutlet EstimatesViewController *estimatesViewController;
	
	NSMutableArray *estimates;

@private
	NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, readonly) NSMutableArray *estimates;

// estimates methods
- (void)fetchEstimatesFromDB;
- (void)addEstimateWithClientName:(NSString *)newClientName;
- (BOOL)deleteEstimateAtIndex:(NSInteger)index;

// startup screen methods
- (void)selectEstimatesTab;
- (void)showAddEstimateView;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;


@end
