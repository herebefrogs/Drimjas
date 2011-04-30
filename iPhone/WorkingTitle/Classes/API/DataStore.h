//
//  DataStore.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Estimate;
@class ClientInformation;
@class ContactInformation;

@interface DataStore : NSObject {

@private
	NSString *storeName_;

	NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
	
	NSMutableArray *estimates_;
	Estimate *estimateStub_;			// estimate being created

	NSFetchedResultsController *clientInfosFetchedResultsController_;

	NSMutableArray *contactInfoStubs_;	// ordered contact infos being created
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
@property (nonatomic, retain, readonly) Estimate *estimateStub;
- (Estimate *)createEstimateStub;
- (void)saveEstimateStub;
- (void)deleteEstimateStub;
- (BOOL)deleteEstimate:(Estimate *)estimate;
- (BOOL)deleteEstimateAtIndex:(NSInteger)index;

// client informatio methods
- (NSFetchedResultsController *)clientInfosFetchedResultsController;
- (ClientInformation *)createClientInformation;
- (BOOL)deleteClientInformation:(ClientInformation *)clientInformation; // do not call from outside of DataStore

// contact information methods
@property (nonatomic, retain, readonly) NSMutableArray *contactInfoStubs;
- (ContactInformation *)createContactInformationStub;
- (BOOL)deleteContactInformation:(ContactInformation *)contactInformation; // do not call from outside of DataStore
//- (BOOL)deleteContactInformation:(ContactInformation *)contactInformation fromClientInformation:(ClientInformation *)clientInformation;

@end
