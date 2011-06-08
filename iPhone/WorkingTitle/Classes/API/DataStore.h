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
@class LineItemSelection;
@class LineItem;

@interface DataStore : NSObject {

@private
	NSString *storeName_;

	NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
	
	Estimate *estimateStub_;			// estimate being created

	NSFetchedResultsController *estimatesFetchedResultsController_;
	NSFetchedResultsController *clientInfosFetchedResultsController_;
	NSFetchedResultsController *lineItemsFetchedResultsController_;

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


@interface DataStore (EstimateAccessors)

@property (nonatomic, retain, readonly) Estimate *estimateStub;
- (NSFetchedResultsController *)estimatesFetchedResultsController;
- (Estimate *)createEstimateStub;
- (void)saveEstimateStub;
- (void)deleteEstimateStub;
- (BOOL)deleteEstimate:(Estimate *)estimate;

@end


@interface DataStore (LineItemSelectionAccessors)

- (NSFetchedResultsController *)lineItemSelectionsForEstimate:(Estimate *)estimate;
- (LineItemSelection *)createLineItemSelection;
- (BOOL)deleteLineItemSelection:(LineItemSelection *)lineItemSelection;

@end


@interface DataStore (LineItemAccessors)

- (NSFetchedResultsController *)lineItemsFetchedResultsController;
- (LineItem *)createLineItemWithPreset:(BOOL)preset;
- (BOOL)saveLineItem:(LineItem *)lineItem;
- (BOOL)deleteLineItem:(LineItem *)lineItem;

@end
