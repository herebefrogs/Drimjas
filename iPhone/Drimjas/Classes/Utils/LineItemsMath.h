//
//  LineItemsMath.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-18.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LineItemsMath : NSObject

+ (NSNumber *)subTotalForLineItems:(NSSet *)lineItems;
+ (NSNumber *)shippingAndHandlingCostForLineItems:(NSSet *)lineItems;
+ (NSNumber *)totalWithSubTotal:(NSNumber *)subTotal shippingAndHandlingCost:(NSNumber *)shippingAndHandlingCost;

@end


@protocol LineItemsOwner

@property (nonatomic, strong) NSSet *lineItems;
@property (weak, nonatomic, readonly) NSNumber *subTotal;
@property (weak, nonatomic, readonly) NSNumber *shippingAndHandlingCost;
@property (weak, nonatomic, readonly) NSNumber *total;

@end