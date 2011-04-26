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

@property (nonatomic, retain) NSNumber *status;

typedef enum {
	Created = 0,
	Active = 1
} Status;

@end



