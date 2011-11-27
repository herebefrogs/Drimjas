//
//  Invoice.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-27.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseObject.h"

@class Contract;
@class LineItemSelection;

@interface Invoice : BaseObject

@property (nonatomic, retain) Contract *contract;
@property (nonatomic, strong) NSSet *lineItems;
@property (nonatomic, retain) NSNumber *paid;

- (void)unbindContract:(Contract *)aContract;

@end


@interface Invoice (CoreDataGeneratedAccessors)
- (void)addLineItemsObject:(LineItemSelection *)value;
- (void)removeLineItemsObject:(LineItemSelection *)value;
- (void)addLineItems:(NSSet *)value;
- (void)removeLineItems:(NSSet *)value;

@end