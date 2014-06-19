//
//  DataStore.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-06.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "DataStore.h"
// API
#import "ClientInfo.h"
#import	"ContactInfo.h"
#import "Contract.h"
#import "Estimate.h"
#import "IndexedObject.h"
#import "Invoice.h"
#import "LineItemSelection.h"
#import "LineItem.h"
#import "Currency.h"
#import "Tax.h"
#import "MyInfo.h"


@interface DataStore ()

- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString *)entity
                                                        predicate:(NSPredicate *)predicate
                                                   sortDescriptor:(NSSortDescriptor *)sortDescriptor
                                               sectionNameKeyPath:(NSString *)keyPath;

@end


@implementation DataStore

#pragma mark -
#pragma mark Core Data stack

// shared singleton instance
static DataStore *singleton_ = nil;

+ (DataStore *)defaultStore {
	return singleton_;
}

+ (void)setDefaultStore:(DataStore *)newDataStore {
	if (newDataStore != singleton_) {
		singleton_ = newDataStore;
	}
}

- (id)initWithName:(NSString *)storeName {
	self = [super init];
	if (self) {
		storeName_ = storeName;
	}
	return self;
}

- (id)init {
	return [self initWithName:@"defaultDataStore"];
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
    if ([managedObjectContext hasChanges]) {
		// save changes
		if (![managedObjectContext save:&error]) {
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

- (void)loadSampleEstimates {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SampleEstimates" ofType:@"plist"];
	NSArray *plistItems = [NSArray arrayWithContentsOfFile:plistPath];

	if (plistItems == nil) {
		NSLog(@"DataStore.loadSampleEstimates: failed to read SamplesEstimates.plist");
	}

	for (NSDictionary *estimate_data in plistItems) {
		Estimate *estimate = [self createEstimateStub];
		estimate.date = [estimate_data valueForKey:@"date"];
		estimate.number = [estimate_data valueForKey:@"number"];

		NSDictionary *client_data = [estimate_data valueForKey:@"client"];
		ClientInfo *client = [self createClientInfo];
		client.name = [client_data valueForKey:@"name"];
		client.address1 = [client_data valueForKey:@"address1"];
		client.address2 = [client_data valueForKey:@"address2"];
		client.city = [client_data valueForKey:@"city"];
		client.state = [client_data valueForKey:@"state"];
		client.postalCode = [client_data valueForKey:@"postal_code"];
		client.country = [client_data valueForKey:@"country"];
		estimate.clientInfo = client;
		[client addEstimatesObject:estimate];

		NSInteger i = 0;
		for (NSDictionary *contact_data in [client_data valueForKey:@"contact_info"]) {
			ContactInfo *contact = [self createContactInfo];
			contact.index = [NSNumber numberWithInt:i++];
			contact.name = [contact_data valueForKey:@"name"];
			contact.email = [contact_data valueForKey:@"email"];
			contact.phone = [contact_data valueForKey:@"phone"];
			[client bindContactInfo:contact];
		}

		i = 0;
		for (NSDictionary *line_item_data in [estimate_data valueForKey:@"line_items"]) {
			BOOL (^predicate)(id, NSUInteger, BOOL*) = ^(id obj, NSUInteger idx, BOOL *stop) {
				LineItem *lineItem = (LineItem *)obj;
				if ([lineItem.name isEqualToString:[line_item_data valueForKey:@"name"]]) {
					*stop = YES;
					return YES;
				}
				return NO;
			};
			NSInteger index = [[[self lineItemsFetchedResultsController] fetchedObjects] indexOfObjectPassingTest:predicate];

			LineItemSelection *item = [self createLineItemSelection];
			if (index != NSNotFound) {
				item.lineItem = [[[self lineItemsFetchedResultsController] fetchedObjects] objectAtIndex:index];
			}
			item.index = [NSNumber numberWithInt:i++];
			item.desc = [line_item_data valueForKey:@"desc"];
			item.quantity = [line_item_data valueForKey:@"quantity"];
			item.unitCost = [line_item_data valueForKey:@"unit_cost"];
			item.estimate = estimate;
			[estimate addLineItemsObject:item];
		}

		[self saveEstimateStub];
	}

	NSError *error = nil;
	if (![estimatesFetchedResultsController_ performFetch:&error]) {
		NSLog(@"DataStore.loadSampleEstimates: fetch failed with error %@, %@", error, [error userInfo]);
	}
}

- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString *)entity
                                                        predicate:(NSPredicate *)predicate
                                                   sortDescriptor:(NSSortDescriptor *)sortDescriptor
                                               sectionNameKeyPath:(NSString *)keyPath
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:entity
									  inManagedObjectContext:self.managedObjectContext];

    fetchRequest.predicate = predicate;

	fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

	fetchRequest.fetchBatchSize = 16;

	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:self.managedObjectContext
                                                 sectionNameKeyPath:keyPath
                                                          cacheName:@"Root"];
}

- (NSFetchedResultsController *)estimatesFetchedResultsController {
	if (estimatesFetchedResultsController_ == nil) {

        // Sort estimates by date (newest estimate first, oldest estimate last)
		estimatesFetchedResultsController_ = [self fetchedResultsControllerForEntity:@"Estimate"
                                                                           predicate:nil
                                                                      sortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]
                                                                  sectionNameKeyPath:@"monthYear"];

		NSError *error = nil;
		if (![estimatesFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.estimatesFetchedResultsController: fetch failed with error %@, %@", error, [error userInfo]);
		}

#ifdef __LOAD_SAMPLE_ESTIMATES__
		if (estimatesFetchedResultsController_.fetchedObjects.count == 0) {
			[self loadSampleEstimates];
		}
#endif
	}
	return estimatesFetchedResultsController_;
}

- (NSFetchedResultsController *)contractReadyEstimatesFetchedResultsController {
	if (contractReadyEstimatesFetchedResultsController_ == nil) {

        // Sort estimates by date (newest estimate first, oldest estimate last)
		contractReadyEstimatesFetchedResultsController_ = [self fetchedResultsControllerForEntity:@"Estimate"
                                                                                        predicate:[NSPredicate predicateWithFormat:@"status = %@ AND contract = NIL", [NSNumber numberWithInt:StatusReady]]
                                                                                   sortDescriptor:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]
                                                                               sectionNameKeyPath:@"monthYear"];

		NSError *error = nil;
		if (![contractReadyEstimatesFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.contractReadyEstimatesFetchedResultsController: fetch failed with error %@, %@", error, [error userInfo]);
		}

#ifdef __LOAD_SAMPLE_ESTIMATES__
		if (contractReadyEstimatesFetchedResultsController_.fetchedObjects.count == 0) {
			// it will force that controller to load sample estimates
			[self estimatesFetchedResultsController];

			if (![contractReadyEstimatesFetchedResultsController_ performFetch:&error]) {
				NSLog(@"DataStore.contractReadyEstimatesFetchedResultsController: re-fetch failed with error %@, %@", error, [error userInfo]);
			}
		}
#endif
	}
	return contractReadyEstimatesFetchedResultsController_;
}

- (Estimate *)estimateStub {
	return estimateStub_;
}

- (Estimate *)createEstimateStub {

	estimateStub_ = (Estimate *)[NSEntityDescription insertNewObjectForEntityForName:@"Estimate"
															   inManagedObjectContext:self.managedObjectContext];

	return estimateStub_;
}

- (Estimate *)saveEstimateStub {
	if (![self saveEstimate:estimateStub_]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"DataStore.saveEstimateStub:%@ failed", estimateStub_);
	}

	// note: after the context save, stubs have permanent IDs
	Estimate *savedEstimate = estimateStub_;

	// discard estimate stub
	estimateStub_ = nil;

	return savedEstimate;
}

- (void)deleteEstimateStub {
	if (estimateStub_) {
		[self deleteEstimate:estimateStub_];
	}

	estimateStub_ = nil;
}

- (BOOL)saveEstimate:(Estimate *)estimate {
	[self saveClientInfo:estimate.clientInfo];

	for (LineItemSelection *lineItem in estimate.lineItems) {
		[lineItem refreshStatus];
	}

	[estimate refreshStatus];

	[self saveContext];

	return YES;
}

- (BOOL)deleteEstimate:(Estimate *)estimate {
	if (estimate.clientInfo) {
		// de-associate client info from estimate
		// note: this might already be done by Delete Rule: Nullify in datamodel
		ClientInfo *clientInfo = estimate.clientInfo;
		[clientInfo removeEstimatesObject:estimate];

		if ([clientInfo shouldBeDeleted]) {
			[self deleteClientInfo:clientInfo andSave:NO];
		}
	}

	for (LineItemSelection *lineItem in estimate.lineItems) {
		[self deleteLineItemSelection:lineItem];
	}

	if (estimate.contract) {
		// deleting an estimate does delete associated contract
		[self deleteContract:estimate.contract andSave:NO];
	}

	[self.managedObjectContext deleteObject:estimate];

	// save the context
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"DataStore.deleteEstimate:%@ failed with error %@, %@", estimate, error, [error userInfo]);
		return NO;
	}

	return YES;
}


# pragma mark -
# pragma mark Client information stack

- (NSFetchedResultsController *)clientInfosFetchedResultsController {
	if (clientInfosFetchedResultsController_ == nil) {
		// ClientInfo fetch request
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		fetchRequest.entity = [NSEntityDescription entityForName:@"ClientInfo"
										  inManagedObjectContext:self.managedObjectContext];

		// fetch only "ready" ClientInfo
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"status = %@ AND subEntityName = %@", 
																  [NSNumber numberWithInt:StatusReady], @"ClientInfo"]; 

		// sort ClientInfo alphabetically
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

		// buffer up to 16 ClientInfo
		fetchRequest.fetchBatchSize = 16;

		// ClientInfo fetched results controller
		clientInfosFetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																				   managedObjectContext:self.managedObjectContext
																					 sectionNameKeyPath:nil
																							  cacheName:@"Root"];


		NSError *error = nil;
		if (![clientInfosFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.clientInfosFetchedResultsController: fetch failed with error %@, %@", error, [error userInfo]);
		}
	}
	return clientInfosFetchedResultsController_;
}

- (ClientInfo *)createClientInfo {
	return (ClientInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"ClientInfo"
															  inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)saveClientInfo:(ClientInfo *)clientInfo {
	for (ContactInfo *contactInfo in clientInfo.contactInfos) {
		[contactInfo refreshStatus];
	}
	[clientInfo refreshStatus];

	[self saveContext];

	return YES;
}

- (BOOL)deleteClientInfo:(ClientInfo *)clientInfo andSave:(BOOL)save {
	// as estimates will be removed from the set, the fast enumeration
	// must work from an immutable copy to prevent raising exceptions
	NSSet *immutableCopy = [clientInfo.estimates copy];
	
	// remove client info from all estimates referencing it
	// NOTE: this is pretty disruptive for underlying estimates but user has been warned
	for (Estimate *estimate in immutableCopy) {
		estimate.clientInfo = nil;
		[estimate refreshStatus];
	}
	

	for (ContactInfo *contactInfo in clientInfo.contactInfos) {
		[self deleteContactInfo:contactInfo];
	}

	[self.managedObjectContext deleteObject:clientInfo];

	if (save) {
		[self saveContext];
	}

	return YES;
}

#pragma mark -
#pragma mark Contact information stack


- (NSFetchedResultsController *)contactInfosForClientInfo:(ClientInfo *)clientInfo {
	NSAssert(clientInfo, @"can't return ContactInfos for an empty ClientInfo");

	// ContactInfo fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:@"ContactInfo"
									  inManagedObjectContext:self.managedObjectContext];

	// fetch only ContactInfo associated to this ClientInfo
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"clientInfo = %@", clientInfo];

	// sort ContactInfo by insertion order
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

	// buffer up to 16 ContactInfo
	fetchRequest.fetchBatchSize = 16;

	// ContactInfo fetched results controller
	NSFetchedResultsController *contactInfos = [[NSFetchedResultsController alloc]
													   initWithFetchRequest:fetchRequest
													   managedObjectContext:self.managedObjectContext
													   sectionNameKeyPath:@"index"
													   cacheName:nil];


	NSError *error = nil;
	if (![contactInfos performFetch:&error]) {
		// TODO This is a serious error saying the records
		//could not be fetched. Advise the user to try
		//again or restart the application.
		NSLog(@"DataStore.contactInfosForClientInfo:%@ fetch failed with error %@, %@", clientInfo, error, [error userInfo]);
	}

	return contactInfos;
}

- (ContactInfo *)createContactInfo {
	return (ContactInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"ContactInfo"
														inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)deleteContactInfo:(ContactInfo *)contactInfo {
	[self.managedObjectContext deleteObject:contactInfo];

	// we only expect this method to be called by deleteClientInfo: or as part of
	// "contact infos" screen edition so let them save the modified context

	return YES;
}

#pragma mark -
#pragma mark Line Item stack

- (void)loadDefaultLineItems {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LineItemDefaults" ofType:@"plist"];
	NSArray *plistItems = [NSArray arrayWithContentsOfFile:plistPath];

	if (plistItems == nil) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"DataStore.loadDefaultLineItems: failed to read LineItemDefaults.plist");
	}

	for (NSString *name in plistItems) {
		LineItem *lineItem = [self createLineItemWithDefaults:YES];
		lineItem.name = NSLocalizedString(name, "");
		NSString *desc_key = [name stringByAppendingString:@" Description"];
		NSString *desc = NSLocalizedString(desc_key, "");
		// some line items have no description, so avoid setting the lookup key as one
		if (desc != desc_key) {
			lineItem.desc = desc;
		}
		[self saveLineItem:lineItem];
	}

	// save the context
	NSError *error = nil;
	if (![self.managedObjectContext save:&error]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"DataStore.loadDefaultLineItems: save failed with error %@, %@", error, [error userInfo]);
	}

	// fetch results again
	if (![lineItemsFetchedResultsController_ performFetch:&error]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"DataStore.loadDefaultLineItems: fetch failed with error %@, %@", error, [error userInfo]);
	}
}

- (LineItem *)createLineItemWithDefaults:(BOOL)newDefaults {
	LineItem *lineItem = (LineItem *)[NSEntityDescription insertNewObjectForEntityForName:@"LineItem"
													 inManagedObjectContext:self.managedObjectContext];

	lineItem.defaults = [NSNumber numberWithInt:newDefaults];

	return lineItem;
}

- (BOOL)saveLineItem:(LineItem *)lineItem {
	[lineItem refreshStatus];

	[self saveContext];

	return YES;
}

- (BOOL)deleteLineItem:(LineItem *)lineItem {
	// as line item selections will be removed from the set, the fast enumeration
	// must work from an immutable copy to prevent raising exceptions
	NSSet *immutableCopy = [lineItem.lineItemSelections copy];

	// remove line item from all line item selections referencing it
	// NOTE: this is pretty disruptive for underlying estimates but user has been warned
	for (LineItemSelection *lineItemSelection in immutableCopy) {
		lineItemSelection.lineItem = nil;
		[lineItemSelection refreshStatus];
	}
	

	[self.managedObjectContext deleteObject:lineItem];

	[self saveContext];

	return YES;
}


- (NSFetchedResultsController *)lineItemsFetchedResultsController {
	if (lineItemsFetchedResultsController_ == nil) {
		// TODO perform a seach on "Draft" LineItems (can be saved that way if application is paused
		// on "New Line Item" screen with only description filled in and application is removed from memory)
		// and delete all these unaccessible and incomplete objects from time to time

		// LineItem fetch request
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		fetchRequest.entity = [NSEntityDescription entityForName:@"LineItem"
										  inManagedObjectContext:self.managedObjectContext];

		// fetch only "ready" LineItem
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"status = %@", [NSNumber numberWithInt:StatusReady]];
		
		// sort LineItem alphabetically
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		
		// buffer up to 16 LineItem
		fetchRequest.fetchBatchSize = 16;
		
		// LineItem fetched results controller
		lineItemsFetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																				 managedObjectContext:self.managedObjectContext
																				   sectionNameKeyPath:nil
																							cacheName:@"Root"];
		
		
		NSError *error = nil;
		if (![lineItemsFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.lineItemsFetchedResultsController: fetch failed with error %@, %@", error, [error userInfo]);
		}
		
		if (lineItemsFetchedResultsController_.fetchedObjects.count == 0) {
			[self loadDefaultLineItems];
		}
	}
	return lineItemsFetchedResultsController_;
}


#pragma mark -
#pragma mark Line Item Selections stack

- (NSFetchedResultsController *)lineItemSelectionsForEstimate:(Estimate *)estimate {
	NSAssert(estimate, @"can't return LineItemSelections for an empty Estimate");

	// LineItemSelection fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:@"LineItemSelection"
									  inManagedObjectContext:self.managedObjectContext];
	
	// fetch only LineItemSelections associated to this Estimate
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"estimate = %@", estimate];
	
	// sort LineItemSelections by insertion order
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	// buffer up to 16 LineItemSelections
	fetchRequest.fetchBatchSize = 16;
	
	// LineItemSelection fetched results controller
	NSFetchedResultsController *lineItemSelections = [[NSFetchedResultsController alloc]
													  initWithFetchRequest:fetchRequest
													  managedObjectContext:self.managedObjectContext
													  sectionNameKeyPath:@"index"
													  cacheName:nil];
	
	
	NSError *error = nil;
	if (![lineItemSelections performFetch:&error]) {
		// TODO This is a serious error saying the records
		//could not be fetched. Advise the user to try
		//again or restart the application.
		NSLog(@"DataStore.lineItemSelectionsForEstimate:%@ fetch failed with error %@, %@", estimate, error, [error userInfo]);
	}

	return lineItemSelections;
}

- (NSFetchedResultsController *)lineItemSelectionsForInvoice:(Invoice *)invoice {
	NSAssert(invoice, @"can't return LineItemSelections for an empty Invoice");

	// LineItemSelection fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:@"LineItemSelection"
									  inManagedObjectContext:self.managedObjectContext];

	// fetch only LineItemSelections associated to this Invoice
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"invoice = %@", invoice];

	// sort LineItemSelections by insertion order
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

	// buffer up to 16 LineItemSelections
	fetchRequest.fetchBatchSize = 16;

	// LineItemSelection fetched results controller
	NSFetchedResultsController *lineItemSelections = [[NSFetchedResultsController alloc]
													  initWithFetchRequest:fetchRequest
													  managedObjectContext:self.managedObjectContext
													  sectionNameKeyPath:@"index"
													  cacheName:nil];


	NSError *error = nil;
	if (![lineItemSelections performFetch:&error]) {
		// TODO This is a serious error saying the records
		//could not be fetched. Advise the user to try
		//again or restart the application.
		NSLog(@"DataStore.lineItemSelectionsForInvoice:%@ fetch failed with error %@, %@", invoice, error, [error userInfo]);
	}

	return lineItemSelections;
}

- (LineItemSelection *)createLineItemSelection {
	return (LineItemSelection *)[NSEntityDescription insertNewObjectForEntityForName:@"LineItemSelection"
															  inManagedObjectContext:self.managedObjectContext];
}

// FIXME missing a save method, so when a line item is modified the estimate status isn't refreshed

- (BOOL)deleteLineItemSelection:(LineItemSelection *)lineItemSelection {
	// deassociate line item from deleted selection
	[lineItemSelection.lineItem removeLineItemSelectionsObject:lineItemSelection];

	[self.managedObjectContext deleteObject:lineItemSelection];
	
	// we only expect this method to be called by deleteEstimate:, deleteInvoice:
    // or as part of "line items" screen edition so let them save the modified context
	
	return YES;
}


#pragma mark -
#pragma mark Contract stack

- (NSFetchedResultsController *)contractsFetchedResultsController {
	if (contractsFetchedResultsController_ == nil) {
		contractsFetchedResultsController_ = [self fetchedResultsControllerForEntity:@"Contract"
                                                                           predicate:nil
                                                                      sortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"estimate.date" ascending:NO]
                                                                  sectionNameKeyPath:@"estimate.monthYear"];

		NSError *error = nil;
		if (![contractsFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.contractsFetchedResultsController_: fetch failed with error %@, %@", error, [error userInfo]);
		}
	}
	return contractsFetchedResultsController_;
}

- (NSFetchedResultsController *)invoiceReadyContractsFetchedResultsController {
	if (invoiceReadyContractsFetchedResultsController_ == nil) {

		invoiceReadyContractsFetchedResultsController_ = [self fetchedResultsControllerForEntity:@"Contract"
                                                                                       predicate:[NSPredicate predicateWithFormat:@"status = %@ AND invoice = NIL", [NSNumber numberWithInt:StatusReady]]
                                                                                  sortDescriptor:[[NSSortDescriptor alloc] initWithKey:@"estimate.date" ascending:NO]
                                                                              sectionNameKeyPath:@"estimate.monthYear"];

		NSError *error = nil;
		if (![invoiceReadyContractsFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.invoiceReadyContractsFetchedResultsController: fetch failed with error %@, %@", error, [error userInfo]);
		}
	}
	return invoiceReadyContractsFetchedResultsController_;
}

- (Contract *)createContract {
	return (Contract *)[NSEntityDescription insertNewObjectForEntityForName:@"Contract"
													 inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)saveContract:(Contract *)contract {
	[contract refreshStatus];

	[self saveContext];

	return YES;
}

- (BOOL)deleteContract:(Contract *)contract andSave:(BOOL)save {
	// deleting a contract does not delete underlying estimate
	[contract unbindEstimate:contract.estimate];

    if (contract.invoice) {
        // deleting a contract does delete associated invoice
        [self deleteInvoice:contract.invoice andSave:save];
    }

	[self.managedObjectContext deleteObject:contract];

	if (save) {
		[self saveContext];
	}

	return YES;
}


#pragma mark -
#pragma mark Invoice stack

- (NSFetchedResultsController *)invoicesFetchedResultsController {
	if (invoicesFetchedResultsController_ == nil) {
		// Invoice fetch request
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		fetchRequest.entity = [NSEntityDescription entityForName:@"Invoice"
										  inManagedObjectContext:self.managedObjectContext];

		// Sort invoices by date (newest invoice first, oldest invoice last)
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contract.estimate.date" ascending:NO];
		fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

		// buffer up to 16 Invoices
		fetchRequest.fetchBatchSize = 16;

		invoicesFetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																				 managedObjectContext:self.managedObjectContext
																				   sectionNameKeyPath:@"contract.estimate.monthYear"
																							cacheName:@"Root"];

		NSError *error = nil;
		if (![invoicesFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.invoicesFetchedResultsController_: fetch failed with error %@, %@", error, [error userInfo]);
		}
	}
	return invoicesFetchedResultsController_;
}

- (Invoice *)createInvoice;
{
	return (Invoice *)[NSEntityDescription insertNewObjectForEntityForName:@"Invoice"
													 inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)saveInvoice:(Invoice *)invoice
{
    [invoice refreshStatus];

	[self saveContext];

	return YES;
}

- (BOOL)deleteInvoice:(Invoice *)invoice andSave:(BOOL)save {
	// deleting an invoice does not delete underlying contract
	[invoice unbindContract:invoice.contract];

    for (LineItemSelection *lineItem in invoice.lineItems) {
		[self deleteLineItemSelection:lineItem];
	}

	[self.managedObjectContext deleteObject:invoice];

	if (save) {
		[self saveContext];
	}

	return YES;
}

#pragma mark -
#pragma mark Currency stack

- (Currency *)currency {
	if (currency_ == nil) {
        NSPredicate *currencyOnlyPredicate = [NSPredicate predicateWithFormat:@"subEntityName = %@", @"Currency"];
        NSArray *currencies = [self.taxesAndCurrencyFetchedResultsController.fetchedObjects filteredArrayUsingPredicate:currencyOnlyPredicate];

        NSAssert(currencies.count > 0, @"No currency created");
        NSAssert(currencies.count < 2, @"More than 1 currency created");

        currency_ = [currencies objectAtIndex:0];
	}

	return currency_;
}

- (NSArray *)taxes {
	NSPredicate *taxesOnlyPredicate = [NSPredicate predicateWithFormat:@"subEntityName = %@", @"Tax"];
	return [self.taxesAndCurrencyFetchedResultsController.fetchedObjects filteredArrayUsingPredicate:taxesOnlyPredicate];
}

- (NSFetchedResultsController *)taxesAndCurrencyFetchedResultsController {
	if (!taxesAndCurrencyFetchedResultsController_) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

		fetchRequest.entity = [NSEntityDescription entityForName:@"IndexedObject"
										  inManagedObjectContext:self.managedObjectContext];

		// fetch only Currency and Tax objects
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"subEntityName IN %@", [NSArray arrayWithObjects:@"Currency", @"Tax", nil]];

		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
		fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		
		fetchRequest.fetchBatchSize = 16;
		
		taxesAndCurrencyFetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																			 managedObjectContext:self.managedObjectContext
																			   sectionNameKeyPath:@"index"
																						cacheName:@"Root"];
		
		
		NSError *error = nil;
		if (![taxesAndCurrencyFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.taxesAndCurrencyFetchedResultsController: fetch failed with error %@, %@", error, [error userInfo]);
		}
		
		if (taxesAndCurrencyFetchedResultsController_.fetchedObjects.count == 0) {
			// force the creation of Currency object
            [NSEntityDescription insertNewObjectForEntityForName:@"Currency"
                                          inManagedObjectContext:self.managedObjectContext];

			if (![taxesAndCurrencyFetchedResultsController_ performFetch:&error]) {
				// TODO This is a serious error saying the records
				//could not be fetched. Advise the user to try
				//again or restart the application.
				NSLog(@"DataStore.taxesAndCurrencyFetchedResultsController: refetch failed with error %@, %@", error, [error userInfo]);
			}
		}
	}
	return taxesAndCurrencyFetchedResultsController_;
}

- (Tax *)createTax {
	return (Tax *)[NSEntityDescription insertNewObjectForEntityForName:@"Tax"
												inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)deleteTax:(Tax *)tax {
	[self.managedObjectContext deleteObject:tax];

	[self saveContext];

	return YES;
}

- (BOOL)saveTaxesAndCurrency {
	if (taxesAndCurrencyFetchedResultsController_) {
		for (IndexedObject *taxOrCurrency in taxesAndCurrencyFetchedResultsController_.fetchedObjects) {
			[taxOrCurrency refreshStatus];
		}
		currency_.isPersistent = YES;

		[self saveContext];
	}

	return YES;
}


#pragma mark -
#pragma mark My Information stack

- (MyInfo *)myInfo {
	if (myInfo_ == nil) {
		// load my information from data store
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		fetchRequest.entity = [NSEntityDescription entityForName:@"MyInfo"
										  inManagedObjectContext:self.managedObjectContext];

		NSError *error;
		NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

		if (!fetchedObjects) {
			// TODO Handle the error
			// This is a serious error blablabla
			NSLog(@"DataStore.myInfo: fetch failed with error %@, %@", error, [error userInfo]);
		}

		NSAssert(fetchedObjects.count <= 1, @"More than 1 my information created");

		if (fetchedObjects.count > 0) {
			myInfo_ = (MyInfo *)[fetchedObjects objectAtIndex:0];
			myInfo_.isPersistent = YES;
		} else {
			myInfo_ = (MyInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"MyInfo"
																  inManagedObjectContext:self.managedObjectContext];

			// add exactly 1 ContactInfo to MyInfo
			ContactInfo *contactInfo = [self createContactInfo];
			[myInfo_ bindContactInfo:contactInfo];
			contactInfo.index = 0;
		}

	}

	return myInfo_;
}

- (void)saveMyInfo {
	if (myInfo_) {
		[myInfo_ refreshStatus];

		[self saveContext];
	}
}

#pragma mark -
#pragma mark Globals stack

+ (BOOL)areGlobalsReadyForEstimate {
    return [Currency isReadyStatus] && [Tax isReadyStatus] && [MyInfo isReadyForEstimate];
}

+ (BOOL)areGlobalsReadyForContract {
    return [Currency isReadyStatus] && [Tax isReadyStatus] && [MyInfo isReadyForContract];
}



#pragma mark -
#pragma mark Memory management stack

- (void)didReceiveMemoryWarning {
}



@end
