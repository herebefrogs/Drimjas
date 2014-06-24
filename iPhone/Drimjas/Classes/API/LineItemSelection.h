//
//  LineItemSelection.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-09.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <CoreData/CoreData.h>
// API
#import "IndexedObject.h"

@class Estimate;
@class Invoice;
@class LineItem;

@interface LineItemSelection : IndexedObject {
}

@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *unitCost;
@property (nonatomic, strong) NSString *desc;		// cannot be named "description" as it collides with NSObject no-argument message
@property (nonatomic, strong) Estimate *estimate;
@property (nonatomic, strong) Invoice *invoice;
@property (nonatomic, strong) LineItem *lineItem;

- (LineItemSelection *)copyLineItemSelectionForInvoice:(Invoice *)invoice;
- (void)copyLineItem:(LineItem *)newLineItem;
@property (weak, nonatomic, readonly) NSNumber *cost; // quantity x unitCost
@property (weak, nonatomic, readonly) NSNumber *nonNilUnitCost;
@property (weak, nonatomic, readonly) NSNumber *nonNilQuantity;

@end