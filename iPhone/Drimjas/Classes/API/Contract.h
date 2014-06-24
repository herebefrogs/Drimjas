//
//  Contract.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-23.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
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



