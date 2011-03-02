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
	
	EstimatesViewController *estimatesViewController;
	NSMutableArray *estimates_;

	StartupViewController *startupViewController;

@private
	NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

// estimates methods
@property (nonatomic, retain) IBOutlet EstimatesViewController *estimatesViewController;
@property (nonatomic, retain, readonly) NSMutableArray *estimates;

- (void)addEstimateWithClientName:(NSString *)newClientName;
- (BOOL)deleteEstimateAtIndex:(NSInteger)index;

// startup screen methods
@property (nonatomic, retain) IBOutlet StartupViewController *startupViewController;

- (void)selectEstimatesTab;
- (void)showAddEstimateView;

// core data methods
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;


@end
