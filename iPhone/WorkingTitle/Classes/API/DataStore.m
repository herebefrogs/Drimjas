//
//  DataStore.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataStore.h"
#import "Estimate.h"


@implementation DataStore

#pragma mark -
#pragma mark Class stack

// shared singleton instance
static DataStore *singleton_ = nil;

+ (DataStore *)defaultStore {
	return singleton_;
}

+ (void)setDefaultStore:(DataStore *)newDataStore {
	if (newDataStore != singleton_) {
		[singleton_ release];
		singleton_ = [newDataStore retain];
	}
}


#pragma mark -
#pragma mark Ctor stack

- (id)initWithName:(NSString *)storeName {
	self = [super init];
	if (self) {
		storeName_ = [storeName retain];
	}
	return self;
}

- (id)init {
	return [self initWithName:@"defaultDataStore"];
}


#pragma mark -
#pragma mark Core Data stack

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
		NSURL *modelURL = [[NSBundle mainBundle] URLForResource:storeName_ withExtension:@"momd"];
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
		NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", storeName_]];
		
		NSError *error = nil;
		persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		
		// enable lightweight data model migration
		NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
								 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
								 nil];
		
		if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
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

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark Estimate stack

- (NSMutableArray *)estimates {
	if (estimates_ == nil) {
		// Define our table/entity to use
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Estimate" inManagedObjectContext:self.managedObjectContext];
		
		// Setup the fetch request
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entity];
		
		// Define how we will sort the records
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
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

- (Estimate *)createEstimate {
	return (Estimate *)[NSEntityDescription insertNewObjectForEntityForName:@"Estimate" inManagedObjectContext:self.managedObjectContext];
}

- (void)saveEstimate:(Estimate *)estimate {
	// save the context
	NSError *error;
	if (![self.managedObjectContext save:&error]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"WorkingTitleAppDelegate.addEstimateWithClientName: failed with error %@, %@", error, [error userInfo]);
	}

	[self.estimates addObject:estimate];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	[self.estimates sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	[sortDescriptor release];
}

- (BOOL)deleteEstimate:(Estimate *)estimate {
	[self.managedObjectContext deleteObject:estimate];

	// save the context
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"WorkingTitleAppDelegate.deleteEstimateAtIndex: failed with error %@, %@", error, [error userInfo]);
		return NO;
	}

	// TODO
	[self.estimates removeObject:estimate];

	return YES;
}

- (BOOL)deleteEstimateAtIndex:(NSInteger)index {
	Estimate *estimate = [estimates_ objectAtIndex:index];

	return [self deleteEstimate:estimate];
}


#pragma mark -
#pragma mark Memory management stack

- (void)didReceiveMemoryWarning {
	[managedObjectModel_ release];
	[managedObjectContext_ release];
	[persistentStoreCoordinator_ release];
	managedObjectModel_ = nil;
	managedObjectContext_ = nil;
	persistentStoreCoordinator_ = nil;
	[estimates_ release];
	estimates_ = nil;
}

- (void)dealloc {
	[managedObjectModel_ release];
	[managedObjectContext_ release];
	[persistentStoreCoordinator_ release];
	[estimates_ release];
	[storeName_ release];
	[super dealloc];
}


@end
