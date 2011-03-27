//
//  DataStore.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Estimate;

@interface DataStore : NSObject {

@private
	NSString *storeName_;

	NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
	
	NSMutableArray *estimates_;
}

// data store creation and management
+ (DataStore *)defaultStore;
+ (void)setDefaultStore:(DataStore *)newDataStore;

- (id)initWithName:(NSString *)storeName;
- (void)didReceiveMemoryWarning;

// core data methods
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

// estimate methods
@property (nonatomic, retain, readonly) NSMutableArray *estimates;
- (Estimate *)createEstimate;
- (void)saveEstimate:(Estimate *)estimate;
- (BOOL)deleteEstimate:(Estimate *)estimate;
- (BOOL)deleteEstimateAtIndex:(NSInteger)index;

@end