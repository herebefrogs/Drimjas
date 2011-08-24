//
//  Contract.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"

@class Estimate;

@interface Contract : BaseObject {
}

@property (nonatomic, retain) Estimate *estimate;

@end



