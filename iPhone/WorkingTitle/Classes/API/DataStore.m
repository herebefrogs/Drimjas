//
//  DataStore.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-03-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataStore.h"
// API
#import "ClientInformation.h"
#import	"ContactInformation.h"
#import "Estimate.h"
#import "IndexedObject.h"
#import "LineItemSelection.h"
#import "LineItem.h"
#import "Currency.h"
#import "Tax.h"
#import "MyInfo.h"


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
		[singleton_ release];
		singleton_ = [newDataStore retain];
	}
}

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
		// delete empty estimate stub to avoid blank line in Estimates view
		if ([estimateStub_ isEmpty]) {
			[self deleteEstimateStub];
		}
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
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];

	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSArray *plistItems = (NSArray *)[NSPropertyListSerialization
									  propertyListFromData:plistXML
									  mutabilityOption:NSPropertyListImmutable
									  format:&format
									  errorDescription:&errorDesc];

	if (plistItems == nil) {
		NSLog(@"DataStore.loadSampleEstimates: read failed with error %@", errorDesc);
	}

	for (NSDictionary *estimate_data in plistItems) {
		Estimate *estimate = [self createEstimateStub];
		estimate.date = [estimate_data valueForKey:@"date"];
		estimate.number = [estimate_data valueForKey:@"number"];

		NSDictionary *client_data = [estimate_data valueForKey:@"client"];
		ClientInformation *client = [self createClientInformation];
		client.name = [client_data valueForKey:@"name"];
		client.address1 = [client_data valueForKey:@"address1"];
		client.address2 = [client_data valueForKey:@"address2"];
		client.city = [client_data valueForKey:@"city"];
		client.state = [client_data valueForKey:@"state"];
		client.postalCode = [client_data valueForKey:@"postal_code"];
		client.country = [client_data valueForKey:@"country"];
		estimate.clientInfo = client;
		[client addEstimatesObject:estimate];

		for (NSDictionary *contact_data in [client_data valueForKey:@"contact_info"]) {
			ContactInformation *contact = [self createContactInformationStub];
			contact.name = [contact_data valueForKey:@"name"];
			contact.email = [contact_data valueForKey:@"email"];
			contact.phone = [contact_data valueForKey:@"phone"];
			contact.clientInfo = client;
			[client addContactInfosObject:contact];
		}

		NSInteger i = 0;
		for (NSDictionary *line_item_data in [estimate_data valueForKey:@"line_items"]) {
			BOOL (^predicate)(id, NSUInteger, BOOL*) = ^(id obj, NSUInteger idx, BOOL *stop) {
				LineItem *lineItem = (LineItem *)obj;
				if ([lineItem.name isEqualToString:[line_item_data valueForKey:@"name"]]) {
					stop = (BOOL *)YES;
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
			item.details = [line_item_data valueForKey:@"details"];
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

- (NSFetchedResultsController *)estimatesFetchedResultsController {
	if (estimatesFetchedResultsController_ == nil) {
		// Estimate fetch request
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		fetchRequest.entity = [NSEntityDescription entityForName:@"Estimate"
										  inManagedObjectContext:self.managedObjectContext];

		// TODO fetch only active ones?

		// Sort estimates by date (newest estimate first, oldest estimate last)
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
		fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[sortDescriptor release];

		// buffer up to 16 Estimate
		fetchRequest.fetchBatchSize = 16;

		estimatesFetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																				managedObjectContext:self.managedObjectContext
																				   sectionNameKeyPath:@"monthYear"
																						cacheName:@"Root"];

		[fetchRequest release];

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

- (Estimate *)estimateStub {
	return estimateStub_;
}

- (Estimate *)createEstimateStub {
	[estimateStub_ release];

	estimateStub_ = [(Estimate *)[NSEntityDescription insertNewObjectForEntityForName:@"Estimate"
															   inManagedObjectContext:self.managedObjectContext]
					 retain];

	return estimateStub_;
}

- (Estimate *)saveEstimateStub {
	NSNumber *active = [NSNumber numberWithInt:StatusActive];

	if ([estimateStub_.clientInfo.status integerValue] == StatusCreated) {
		// associate contact infos to client info
		[estimateStub_.clientInfo addContactInfos:[NSSet setWithArray:contactInfoStubs_]];

		// associate each contact info with client info
		for (ContactInformation *contactInfo in contactInfoStubs_) {
			contactInfo.clientInfo = estimateStub_.clientInfo;
			contactInfo.status = active;
		}

		estimateStub_.clientInfo.status	= active;
	}
	else if ([estimateStub_.clientInfo.status integerValue] == StatusActive
			 && [contactInfoStubs_ count] > 0) {
		// delete contact infos stubs that may have been created
		for (ContactInformation *contactInfo in contactInfoStubs_) {
			[[DataStore defaultStore] deleteContactInformation:contactInfo];
		}
	}

	// flag each stub as "active"
	estimateStub_.status = active;
	for (LineItemSelection *lineItem in estimateStub_.lineItems) {
		lineItem.status = active;
	}
	[active release];

	// save the context
	NSError *error;
	if (![self.managedObjectContext save:&error]) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"DataStore.saveEstimate:%@ failed with error %@, %@", estimateStub_, error, [error userInfo]);
	}

	// note: after the context save, stubs have permanent IDs
	Estimate *savedEstimate = [estimateStub_ autorelease];

	// discard estimate & contact info stubs
	[contactInfoStubs_ release];
	contactInfoStubs_ = nil;
	[estimateStub_ release];
	estimateStub_ = nil;

	return savedEstimate;
}

- (void)deleteEstimateStub {
	if (estimateStub_) {
		[self deleteEstimate:estimateStub_];
	}

	[contactInfoStubs_ release];
	contactInfoStubs_ = nil;
	[estimateStub_ release];
	estimateStub_ = nil;
}

- (BOOL)deleteEstimate:(Estimate *)estimate {
	if (estimate.clientInfo) {
		// de-associate client info from estimate
		// note: this might already be done by Delete Rule: Nullify in datamodel
		ClientInformation *clientInfo = estimate.clientInfo;
		[clientInfo removeEstimatesObject:estimate];

		if ([clientInfo.status integerValue] == StatusCreated) {
			[self deleteClientInformation:clientInfo];
		}
	}

	for (LineItemSelection *lineItem in estimate.lineItems) {
		[self deleteLineItemSelection:lineItem];
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
		fetchRequest.entity = [NSEntityDescription entityForName:@"ClientInformation"
										  inManagedObjectContext:self.managedObjectContext];

		// fetch only "active" ClientInfo
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"status = %@ AND subEntityName = %@", 
																  [NSNumber numberWithInt:StatusActive], @"ClientInfo"]; 

		// sort ClientInfo alphabetically
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[sortDescriptor release];

		// buffer up to 16 ClientInfo
		fetchRequest.fetchBatchSize = 16;

		// ClientInfo fetched results controller
		clientInfosFetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																				   managedObjectContext:self.managedObjectContext
																					 sectionNameKeyPath:nil
																							  cacheName:@"Root"];

		[fetchRequest release];

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

- (ClientInformation *)createClientInformation {
	return (ClientInformation *)[NSEntityDescription insertNewObjectForEntityForName:@"ClientInformation"
															  inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)deleteClientInformation:(ClientInformation *)clientInformation {
	NSArray *contactInfos = [clientInformation.status integerValue] == StatusCreated ? contactInfoStubs_ : [clientInformation.contactInfos allObjects];

	for (ContactInformation *contactInfo in contactInfos) {
		[self deleteContactInformation:contactInfo];
	}

	[self.managedObjectContext deleteObject:clientInformation];

	// NOTE: assume this will be validated by either deleteEstimate[Stub]: or saveEstimateStub:
	// TODO: won't be true when deleting ClientInfo from Options screen

	return YES;
}

#pragma mark -
#pragma mark Contact information stack

- (NSMutableArray *)contactInfoStubs {
	if (contactInfoStubs_ == nil) {
		contactInfoStubs_ = [[NSMutableArray alloc] init];
	}
	return contactInfoStubs_;
}

- (ContactInformation *)createContactInformationStub {
	ContactInformation *contactInfo = (ContactInformation *)[NSEntityDescription insertNewObjectForEntityForName:@"ContactInformation"
																						  inManagedObjectContext:self.managedObjectContext];

	[self.contactInfoStubs addObject:contactInfo];

	return contactInfo;
}

- (ContactInformation *)addContactInfoToClientInfo:(ClientInformation *)clientInfo {
	ContactInformation *contactInfo = (ContactInformation *)[NSEntityDescription insertNewObjectForEntityForName:@"ContactInformation"
																						  inManagedObjectContext:self.managedObjectContext];

	[clientInfo addContactInfosObject:contactInfo];
	contactInfo.clientInfo = clientInfo;

	return contactInfo;
}

- (BOOL)deleteContactInformation:(ContactInformation *)contactInformation {
	[self.managedObjectContext deleteObject:contactInformation];

	// we only expect this method to be called by deleteClientInformation:
	// as a result of a call to deleteEstimate: so let it save the modified context

	return YES;
}

#pragma mark -
#pragma mark Line Item stack

- (void)loadDefaultLineItems {
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LineItemDefaults" ofType:@"plist"];
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];

	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSArray *plistItems = (NSArray *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListImmutable
										  format:&format
										  errorDescription:&errorDesc];

	if (plistItems == nil) {
		// TODO This is a serious error saying the record
		//could not be saved. Advise the user to
		//try again or restart the application.
		NSLog(@"DataStore.loadDefaultLineItems: read failed with error %@", errorDesc);
	}

	for (NSString *name in plistItems) {
		LineItem *lineItem = [self createLineItemWithPreset:YES];
		lineItem.name = NSLocalizedString(name, "");
		NSString *details_key = [name stringByAppendingString:@" Description"];
		NSString *details = NSLocalizedString(details_key, "");
		// some line items have no description, so avoid setting the lookup key as one
		if (details != details_key) {
			lineItem.details = details;
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

- (LineItem *)createLineItemWithPreset:(BOOL)preset {
	LineItem *lineItem = (LineItem *)[NSEntityDescription insertNewObjectForEntityForName:@"LineItem"
													 inManagedObjectContext:self.managedObjectContext];

	lineItem.preset = [NSNumber numberWithInt:preset];

	return lineItem;
}

- (BOOL)saveLineItem:(LineItem *)lineItem {
	lineItem.status = [NSNumber numberWithInt:StatusActive];

	[self saveContext];

	return YES;
}

- (BOOL)deleteLineItem:(LineItem *)lineItem {
	[self.managedObjectContext deleteObject:lineItem];

	[self saveContext];

	return YES;
}


- (NSFetchedResultsController *)lineItemsFetchedResultsController {
	if (lineItemsFetchedResultsController_ == nil) {
		// LineItem fetch request
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		fetchRequest.entity = [NSEntityDescription entityForName:@"LineItem"
										  inManagedObjectContext:self.managedObjectContext];
		
		// fetch only "active " LineItem
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"status = %@", [NSNumber numberWithInt:StatusActive]];
		
		// sort LineItem alphabetically
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
		fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[sortDescriptor release];
		
		// buffer up to 16 LineItem
		fetchRequest.fetchBatchSize = 16;
		
		// LineItem fetched results controller
		lineItemsFetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																				 managedObjectContext:self.managedObjectContext
																				   sectionNameKeyPath:nil
																							cacheName:@"Root"];
		
		[fetchRequest release];
		
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
	// LineItemSelection fetch request
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:@"LineItemSelection"
									  inManagedObjectContext:self.managedObjectContext];
	
	// fetch only LineItemSelections associated to this Estimate
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"estimate = %@", estimate];
	
	// sort LineItemSelections by insertion order
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[sortDescriptor release];
	
	// buffer up to 16 LineItemSelections
	fetchRequest.fetchBatchSize = 16;
	
	// LineItemSelection fetched results controller
	NSFetchedResultsController *lineItemSelections = [[[NSFetchedResultsController alloc]
													  initWithFetchRequest:fetchRequest
													  managedObjectContext:self.managedObjectContext
													  sectionNameKeyPath:@"index"
													  cacheName:@"Root"]
													 autorelease];
	
	[fetchRequest release];
	
	NSError *error = nil;
	if (![lineItemSelections performFetch:&error]) {
		// TODO This is a serious error saying the records
		//could not be fetched. Advise the user to try
		//again or restart the application.
		NSLog(@"DataStore.lineItemSelectionsForEstimate:%@ fetch failed with error %@, %@", estimate, error, [error userInfo]);
	}

	return lineItemSelections;
}

- (LineItemSelection *)createLineItemSelection {
	return (LineItemSelection *)[NSEntityDescription insertNewObjectForEntityForName:@"LineItemSelection"
															  inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)deleteLineItemSelection:(LineItemSelection *)lineItemSelection {
	// deassociate line item from deleted selection
	[lineItemSelection.lineItem removeLineItemSelectionsObject:lineItemSelection];

	[self.managedObjectContext deleteObject:lineItemSelection];
	
	// we only expect this method to be called by deleteEstimate: or as part of
	// "line items" screen edition so let them save the modified context
	
	return YES;
}


#pragma mark -
#pragma mark Currency stack

- (Currency *)currency {
	if (currency_ == nil) {
		// load currency from data store
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		fetchRequest.entity = [NSEntityDescription entityForName:@"Currency"
										  inManagedObjectContext:self.managedObjectContext];

		NSError *error;
		NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

		if (!fetchedObjects) {
			// TODO Handle the error
			// This is a serious error blablabla
			NSLog(@"DataStore.currency: fetch failed with error %@, %@", error, [error userInfo]);
		}
		
		NSAssert(fetchedObjects.count <= 1, @"More than 1 currency created");

		if (fetchedObjects.count > 0) {
			currency_ = (Currency *)[fetchedObjects objectAtIndex:0];
		} else {
			currency_ = (Currency *)[NSEntityDescription insertNewObjectForEntityForName:@"Currency"
																  inManagedObjectContext:self.managedObjectContext];
		}
		[currency_ retain];

		[fetchRequest release];
	}

	return currency_;
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
		[sortDescriptor release];
		
		fetchRequest.fetchBatchSize = 16;
		
		taxesAndCurrencyFetchedResultsController_ = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																			 managedObjectContext:self.managedObjectContext
																			   sectionNameKeyPath:@"index"
																						cacheName:@"Root"];
		
		[fetchRequest release];
		
		NSError *error = nil;
		if (![taxesAndCurrencyFetchedResultsController_ performFetch:&error]) {
			// TODO This is a serious error saying the records
			//could not be fetched. Advise the user to try
			//again or restart the application.
			NSLog(@"DataStore.taxesAndCurrencyFetchedResultsController: fetch failed with error %@, %@", error, [error userInfo]);
		}
		
		if (taxesAndCurrencyFetchedResultsController_.fetchedObjects.count == 0) {
			// TODO call currency instead
			[NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:self.managedObjectContext];
			// TODO fetched once more instead? is savecontext any use (given its not done in currency)
			[self saveContext];
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
		NSNumber *active = [NSNumber numberWithInt:StatusActive];
		for (IndexedObject *taxOrCurrency in taxesAndCurrencyFetchedResultsController_.fetchedObjects) {
			if ([taxOrCurrency.status intValue] == StatusCreated) {
				taxOrCurrency.status = active;
			}
		}
		[active release];

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
		} else {
			myInfo_ = (MyInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"MyInfo"
																  inManagedObjectContext:self.managedObjectContext];

			[self addContactInfoToClientInfo:myInfo_];
		}
		[myInfo_ retain];

		[fetchRequest release];
	}

	return myInfo_;
}

- (void)saveMyInfo {
	if (myInfo_) {
		// TODO also validate myInfo? what are the required fields
		if ([myInfo_.status intValue] == StatusCreated) {
			myInfo_.status = [NSNumber numberWithInt:StatusActive];
		}

		[self saveContext];
	}
}


#pragma mark -
#pragma mark Memory management stack

- (void)didReceiveMemoryWarning {
}

- (void)dealloc {
	[managedObjectModel_ release];
	[managedObjectContext_ release];
	[persistentStoreCoordinator_ release];
	[contactInfoStubs_ release];
	[estimatesFetchedResultsController_ release];
	[clientInfosFetchedResultsController_ release];
	[lineItemsFetchedResultsController_ release];
	[taxesAndCurrencyFetchedResultsController_ release];
	[currency_ release];
	[myInfo_ release];
	[estimateStub_ release];
	[storeName_ release];
	[super dealloc];
}


@end
