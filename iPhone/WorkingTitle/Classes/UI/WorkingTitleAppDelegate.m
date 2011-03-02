//
//  WorkingTitleAppDelegate.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingTitleAppDelegate.h"
// API
#import "Estimate.h"
// UI
#import "StartupViewController.h"
#import "EstimatesViewController.h"


@implementation WorkingTitleAppDelegate

@synthesize window, startupViewController, tabBarController, estimatesViewController;


#pragma mark -
#pragma mark Startup screen methods

- (void)selectEstimatesTab {
	// dismiss startup view
	[tabBarController dismissModalViewControllerAnimated:YES];
	// not clear how that selects the estimates tab
	// TODO verify that it works when there are multiple tabs
}

- (void)showAddEstimateView {
	[estimatesViewController add:nil];
}


#pragma mark -
#pragma mark Estimates lifecycle

- (NSMutableArray *)estimates {
	if (estimates_ == nil) {
		// Define our table/entity to use
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Estimate" inManagedObjectContext:self.managedObjectContext];

		// Setup the fetch request
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entity];

		// Define how we will sort the records
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"clientName" ascending:YES];
		NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptor release];

		// Fetch the records and handle an error
		NSError *error;
		NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error]	mutableCopy];

		if (!mutableFetchResults) {
			// TODO Handle the error.
			// This is a serious error and should advise the user to restart the application
			NSLog(@"WorkingTitleAppDelegage.fetchEstimatesFromDB: failed with error %u.%@", error.code, error.domain);
		}

		// Save our fetched data to an array
		estimates_ = [mutableFetchResults retain];
		[mutableFetchResults release];
		[request release];
	}
	return estimates_;
}

- (void)addEstimateWithClientName:(NSString *)newClientName {
	Estimate *estimate = (Estimate *)[NSEntityDescription insertNewObjectForEntityForName:@"Estimate" inManagedObjectContext:self.managedObjectContext];
	[estimate setClientName:newClientName];
	
	// save the context
	NSError *error;
	if (![self.managedObjectContext save:&error]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"WorkingTitleAppDelegate.addEstimateWithClientName: failed with error %@, %@", error, [error userInfo]);
	}

	[self.estimates addObject:estimate];
}

- (BOOL)deleteEstimateAtIndex:(NSInteger)index {
	Estimate *deletedEstimate = [estimates_ objectAtIndex:index];
	[self.managedObjectContext deleteObject:deletedEstimate];

	// save the context
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"WorkingTitleAppDelegate.deleteEstimateAtIndex: failed with error %@, %@", error, [error userInfo]);
		return NO;
	}

	[self.estimates removeObjectAtIndex:index];

	return YES;
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Add the tab bar controller's view to the window and display.
	[self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

	// load startup view on top of tab bar controller's view
	[tabBarController presentModalViewController:startupViewController animated:NO];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[self saveContext];
}


#pragma mark -
#pragma mark Core Data stack

- (void)saveContext {

    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             TODO Replace this implementation with code to handle the error appropriately.

             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {

    if (managedObjectContext_ == nil) {
		NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
		if (coordinator != nil) {
			managedObjectContext_ = [[NSManagedObjectContext alloc] init];
			[managedObjectContext_ setPersistentStoreCoordinator:coordinator];
		}
	}

    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel_ == nil) {
		NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WorkingTitle" withExtension:@"momd"];
		managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }

    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (persistentStoreCoordinator_ == nil) {
		NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WorkingTitle.sqlite"];

		NSError *error = nil;
		persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
			/*
			 TODO Replace this implementation with code to handle the error appropriately.

			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.

			 Typical reasons for an error here include:
			 * The persistent store is not accessible;
			 * The schema for the persistent store is incompatible with current managed object model.
			 Check the error message to determine what the actual problem was.


			 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

			 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
			 * Simply deleting the existing store:
			 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

			 * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
			 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

			 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
    }

    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	NSLog(@"appdelegate.applicationDidReceiveMemoryWarning");
	[managedObjectModel_ release];
	managedObjectModel_ = nil;
	[managedObjectContext_ release];
	managedObjectContext_ = nil;
	[persistentStoreCoordinator_ release];
	persistentStoreCoordinator_ = nil;
	[estimates_ release];
	estimates_ = nil;
}


- (void)dealloc {
	[managedObjectModel_ release];
	[managedObjectContext_ release];
	[persistentStoreCoordinator_ release];
	[estimates_ release];
	[estimatesViewController release];
	[startupViewController release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

