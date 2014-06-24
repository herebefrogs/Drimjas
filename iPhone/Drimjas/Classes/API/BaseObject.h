//
//  BaseObject.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-25.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <CoreData/CoreData.h>


@interface BaseObject : NSManagedObject {
	BOOL isPersistent;
}

// unfortunately, entity.name cannot be accessed to filter sub-entities in a predicate
@property (nonatomic, strong) NSString *subEntityName;

// keeps track of the state of the managed object in the application context
// (is the object ready to be used or still incomplete?)
// does not indicate if the managed object has been saved/persisted in Core Data or not
@property (nonatomic, strong) NSNumber *status;

typedef enum {
	StatusDraft = 1,	// managed object is still incomplete & missing required fields
						// StatusDraft is used at the default in the data model
	StatusReady = 2		// managed object is complete & ready to be used in high level functions
} Status;

@property (nonatomic, assign) BOOL isPersistent;
@property (nonatomic, readonly) BOOL isReady;
- (void)refreshStatus;

@end



