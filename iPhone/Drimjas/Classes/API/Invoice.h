//
//  Invoice.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-27.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
// API
#import "BaseObject.h"
// Utils
#import "LineItemsMath.h"

@class Contract;
@class LineItemSelection;

@interface Invoice : BaseObject <LineItemsOwner>

@property (nonatomic, retain) Contract *contract;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSSet *lineItems;
@property (nonatomic, retain) NSNumber *paid;

- (void)bindContract:(Contract *)aContract;
- (void)unbindContract:(Contract *)aContract;
- (void)issued;

@end


@interface Invoice (CoreDataGeneratedAccessors)
- (void)addLineItemsObject:(LineItemSelection *)value;
- (void)removeLineItemsObject:(LineItemSelection *)value;
- (void)addLineItems:(NSSet *)value;
- (void)removeLineItems:(NSSet *)value;

@end