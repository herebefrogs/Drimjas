//
//  Estimate.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-03-27.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"

@class ClientInfo;
@class Contract;
@class LineItemSelection;

@interface Estimate : BaseObject {
}

@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) ClientInfo *clientInfo;
@property (nonatomic, strong) NSSet *lineItems;
@property (nonatomic, strong) Contract *contract;

@property (weak, nonatomic, readonly) NSString *monthYear;
@property (weak, nonatomic, readonly) NSString *orderNumber;

@property (weak, nonatomic, readonly) NSNumber *subTotal;
@property (weak, nonatomic, readonly) NSNumber *total;
@property (weak, nonatomic, readonly) NSNumber *shippingAndHandlingCost;

@end


@interface Estimate (CoreDataGeneratedAccessors)
- (void)addLineItemsObject:(LineItemSelection *)value;
- (void)removeLineItemsObject:(LineItemSelection *)value;
- (void)addLineItems:(NSSet *)value;
- (void)removeLineItems:(NSSet *)value;

@end