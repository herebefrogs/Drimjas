//
//  DataStore.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-06.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Estimate;
@class ClientInfo;
@class ContactInfo;
@class LineItemSelection;
@class LineItem;
@class Currency;
@class Tax;
@class MyInfo;

@interface DataStore : NSObject {

@private
	// core data
	NSString *storeName_;

	NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;

	// estimate & estimate attributes
	Estimate *estimateStub_;

	NSFetchedResultsController *estimatesFetchedResultsController_;
	NSFetchedResultsController *clientInfosFetchedResultsController_;
	NSFetchedResultsController *lineItemsFetchedResultsController_;

	// general settings
	Currency *currency_;
	NSFetchedResultsController *taxesAndCurrencyFetchedResultsController_;
	MyInfo *myInfo_;
}

@end


@interface DataStore (CoreDataAccessors)

+ (DataStore *)defaultStore;
+ (void)setDefaultStore:(DataStore *)newDataStore;
- (id)initWithName:(NSString *)storeName;
- (void)didReceiveMemoryWarning;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end


@interface DataStore (EstimateAccessors)

@property (nonatomic, retain, readonly) Estimate *estimateStub;
- (NSFetchedResultsController *)estimatesFetchedResultsController;
- (Estimate *)createEstimateStub;
- (Estimate *)saveEstimateStub;
- (void)deleteEstimateStub;
- (BOOL)deleteEstimate:(Estimate *)estimate;

@end


@interface DataStore (ClientAccessors)

- (NSFetchedResultsController *)clientInfosFetchedResultsController;
- (ClientInfo *)createClientInfo;
- (BOOL)deleteClientInfo:(ClientInfo *)clientInfo andSave:(BOOL)save;

@end


@interface DataStore (ContactAccessors)

- (NSFetchedResultsController *)contactInfosForClientInfo:(ClientInfo *)clientInfo;
- (ContactInfo *)createContactInfo;
- (BOOL)saveClientInfo:(ClientInfo *)clientInfo;
- (BOOL)deleteContactInfo:(ContactInfo *)contactInfo;

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


@interface DataStore (TaxesAndCurrencyAccessors)

@property (nonatomic, readonly) Currency *currency;
@property (nonatomic, readonly) NSArray *taxes;
@property (nonatomic, readonly) NSFetchedResultsController *taxesAndCurrencyFetchedResultsController;
- (Tax *)createTax;
- (BOOL)deleteTax:(Tax *)tax;
- (BOOL)saveTaxesAndCurrency;

@end


@interface DataStore (MyInfoAccessors)

@property (nonatomic, readonly) MyInfo *myInfo;
- (void)saveMyInfo;

@end
