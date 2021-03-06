// 
//  LineItemSelection.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-09.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import "LineItemSelection.h"
// API
#import "DataStore.h"
#import "Estimate.h"
#import "Invoice.h"
#import "LineItem.h"

@implementation LineItemSelection

@dynamic quantity;
@dynamic unitCost;
@dynamic desc;
@dynamic estimate;
@dynamic invoice;
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
		// notify underlying Estimate & Invoice of the status change
		[self.estimate refreshStatus];
        [self.invoice refreshStatus];
	}
}

- (LineItemSelection *)copyLineItemSelectionForInvoice:(Invoice *)invoice {
	LineItemSelection *copy = [[DataStore defaultStore] createLineItemSelection];

	copy.invoice = invoice;
	copy.lineItem = self.lineItem;
	[copy.lineItem addLineItemSelectionsObject:copy];
	copy.desc = self.desc;
	copy.quantity = self.quantity;
	copy.unitCost = self.unitCost;
	copy.status = self.status;
	// direct base class attributes
	copy.index = self.index;
	// base class's base class attributes
	copy.status = self.status;
	copy.subEntityName = self.subEntityName;

    return copy;
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
