//
//  Estimate.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"
// Utils
#import "LineItemsMath.h"

@class ClientInfo;
@class Contract;
@class LineItemSelection;

@interface Estimate : BaseObject <LineItemsOwner>

@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) ClientInfo *clientInfo;
@property (nonatomic, strong) NSSet *lineItems;
@property (nonatomic, strong) Contract *contract;

@property (weak, nonatomic, readonly) NSString *monthYear;
@property (weak, nonatomic, readonly) NSString *orderNumber;

@end


@interface Estimate (CoreDataGeneratedAccessors)
- (void)addLineItemsObject:(LineItemSelection *)value;
- (void)removeLineItemsObject:(LineItemSelection *)value;
- (void)addLineItems:(NSSet *)value;
- (void)removeLineItems:(NSSet *)value;

@end