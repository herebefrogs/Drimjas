//
//  LineItemsMath.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-18.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "LineItemsMath.h"
// API
#import "DataStore.h"
#import "LineItem.h"
#import "LineItemSelection.h"
#import "Tax.h"


@implementation LineItemsMath

+ (NSNumber *)subTotalForLineItems:(NSSet *)lineItems
{
	CGFloat subTotal = 0;

	for (LineItemSelection *lineItem in lineItems) {
		// S & H is handled in total
		if ([lineItem.lineItem.name isEqualToString:NSLocalizedString(@"Shipping & Handling","")]) {
			continue;
		}
		subTotal += [lineItem.cost floatValue];
	}

	return [NSNumber numberWithFloat:subTotal];
}

+ (NSNumber *)shippingAndHandlingCostForLineItems:(NSSet *)lineItems
{
	for (LineItemSelection *lineItem in lineItems) {
		if ([lineItem.lineItem.name isEqualToString:NSLocalizedString(@"Shipping & Handling", "")]) {
			return lineItem.cost;
		}
	}
	return [NSNumber numberWithInt:0];

}

+ (NSNumber *)totalWithSubTotal:(NSNumber *)subTotal shippingAndHandlingCost:(NSNumber *)shippingAndHandlingCost
{
	CGFloat total = 0;
	for (Tax *tax in [[DataStore defaultStore] taxes]) {
		total += [[tax costForSubTotal:subTotal] floatValue];
	}

	total += [shippingAndHandlingCost floatValue];

	total += [subTotal floatValue];

	return [NSNumber numberWithFloat:total];
}

@end
