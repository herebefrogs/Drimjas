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
@class Invoice;

@interface Contract : BaseObject {
}

@property (nonatomic, strong) Estimate *estimate;
@property (nonatomic, strong) Invoice *invoice;

- (void)bindEstimate:(Estimate *)anEstimate;
- (void)unbindEstimate:(Estimate *)anEstimate;

@end



