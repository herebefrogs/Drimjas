//
//  LineItemSelection.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-09.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "IndexedObject.h"

@class Estimate;
@class LineItem;

@interface LineItemSelection : IndexedObject {
}

@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSNumber *unitCost;
@property (nonatomic, strong) NSString *desc;		// cannot be named "description" as it collides with NSObject no-argument message
@property (nonatomic, strong) Estimate *estimate;
@property (nonatomic, strong) LineItem *lineItem;

- (void)copyLineItem:(LineItem *)newLineItem;
@property (weak, nonatomic, readonly) NSNumber *cost; // quantity x unitCost
@property (weak, nonatomic, readonly) NSNumber *nonNilUnitCost;
@property (weak, nonatomic, readonly) NSNumber *nonNilQuantity;

@end