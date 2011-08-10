//
//  LineItemSelection.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-09.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"

@class Estimate;
@class LineItem;

@interface LineItemSelection : BaseObject {
}

@property (nonatomic, retain) NSNumber *quantity;
@property (nonatomic, retain) NSNumber *unitCost;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSNumber *index;
@property (nonatomic, retain) Estimate *estimate;
@property (nonatomic, retain) LineItem *lineItem;

- (void)copyLineItem:(LineItem *)newLineItem;
@property (nonatomic, readonly) NSNumber *cost; // quantity x unitCost

@end