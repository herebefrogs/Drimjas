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

@property (nonatomic, retain) NSNumber *quantity;
@property (nonatomic, retain) NSNumber *unitCost;
@property (nonatomic, retain) NSString *desc;		// cannot be named "description" as it collides with NSObject no-argument message
@property (nonatomic, retain) Estimate *estimate;
@property (nonatomic, retain) LineItem *lineItem;

- (void)copyLineItem:(LineItem *)newLineItem;
@property (nonatomic, readonly) NSNumber *cost; // quantity x unitCost
@property (nonatomic, readonly) NSNumber *nonNilUnitCost;
@property (nonatomic, readonly) NSNumber *nonNilQuantity;

@end