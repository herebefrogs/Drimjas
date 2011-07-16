// 
//  LineItemSelection.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-09.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "LineItemSelection.h"
// API
#import "Estimate.h"
#import "LineItem.h"

@implementation LineItemSelection

@dynamic quantity;
@dynamic unitCost;
@dynamic details;
@dynamic index;
@dynamic estimate;
@dynamic lineItem;

- (void)copyLineItem:(LineItem *)newLineItem {
	// deassociate current line item
	[self.lineItem removeLineItemSelectionsObject:self];

	// associate new line item
	self.lineItem = newLineItem;
	self.details = newLineItem.details;
	if ([newLineItem.name isEqualToString:NSLocalizedString(@"Handling & Shipping", "")]) {
		self.quantity = [NSNumber numberWithInt:1];
	}
	[newLineItem addLineItemSelectionsObject:self];
}

@end
