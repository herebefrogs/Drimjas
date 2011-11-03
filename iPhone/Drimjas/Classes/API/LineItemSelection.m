// 
//  LineItemSelection.m
//  Drimjas
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
@dynamic desc;
@dynamic estimate;
@dynamic lineItem;


- (void)awakeFromInsert {
	[super awakeFromInsert];

	self.subEntityName = @"LineItemSelection";
}

- (BOOL)isReady {
	return (self.lineItem.isReady);
}

- (void)refreshStatus {
	NSNumber *oldStatus = self.status;

	[super refreshStatus];

	if (![oldStatus isEqualToNumber:self.status]) {
		// notify underlying Estimate of the status change
		[self.estimate refreshStatus];
	}

}


- (void)copyLineItem:(LineItem *)newLineItem {
	// deassociate current line item
	[self.lineItem removeLineItemSelectionsObject:self];

	// associate new line item
	self.lineItem = newLineItem;
	self.desc = newLineItem.desc;
	if ([newLineItem.name isEqualToString:NSLocalizedString(@"Shipping & Handling", "")]) {
		self.quantity = [NSNumber numberWithInt:1];
	}
	[newLineItem addLineItemSelectionsObject:self];
	[self refreshStatus];
}

- (NSNumber *)cost {
	return [NSNumber numberWithFloat:([self.nonNilQuantity floatValue] * [self.nonNilUnitCost floatValue])];
}

- (NSNumber *)nonNilQuantity {
	return (self.quantity != nil) ? self.quantity : [NSNumber numberWithFloat:0.0];
}

- (NSNumber *)nonNilUnitCost {
	return (self.unitCost != nil) ? self.unitCost : [NSNumber numberWithFloat:0.0];
}

@end
