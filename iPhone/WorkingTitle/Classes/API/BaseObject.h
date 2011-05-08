//
//  BaseObject.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface BaseObject : NSManagedObject {
}

// we make a distinction between "saved" in the Core Data sense (meaning object has been persisted
// in the data store) and "saved" in the application sense (meaning object has completed the creation
// process and is now a first-class citizen)
// the status property tracks the latter
@property (nonatomic, retain) NSNumber *status;

typedef enum {
	StatusCreated = 1,	// managed object being filled during creation process
	StatusActive = 2	// managed object has completed creation process and is a first-class citizen
} Status;

@end



