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
@class LineItemSelection;

@interface Estimate : BaseObject {
}

@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) ClientInfo *clientInfo;
@property (nonatomic, retain) NSSet *lineItems;

@property (nonatomic, readonly) NSString *monthYear;
@property (nonatomic, readonly) NSString *orderNumber;
@property (nonatomic, readonly) BOOL isEmpty;

@property (nonatomic, readonly) NSNumber *subTotal;
@property (nonatomic, readonly) NSNumber *total;
@property (nonatomic, readonly) NSNumber *handlingAndShippingCost;

@end


@interface Estimate (CoreDataGeneratedAccessors)
- (void)addLineItemsObject:(LineItemSelection *)value;
- (void)removeLineItemsObject:(LineItemSelection *)value;
- (void)addLineItems:(NSSet *)value;
- (void)removeLineItems:(NSSet *)value;

@end