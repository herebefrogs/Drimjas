//
//  Invoice.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-27.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "Invoice.h"
// API
#import "ClientInfo.h"
#import "Contract.h"
#import "DataStore.h"
#import "Estimate.h"
#import "LineItemSelection.h"


@implementation Invoice

@dynamic contract;
@dynamic date;
@dynamic lineItems;
@dynamic paid;

- (BOOL)isReady {
	if (self.contract.estimate.clientInfo.isReady) {
		for (LineItemSelection *lineItem in self.lineItems) {
			if (lineItem.isReady) {
				return YES;
			}
		}
	}
	return NO;
}

- (void)bindContract:(Contract *)aContract {
    for (LineItemSelection *lineItem in aContract.estimate.lineItems) {
        [self addLineItemsObject:[lineItem copyLineItemSelectionForInvoice:self]];
    }

	aContract.invoice = self;
	self.contract = aContract;

    [self refreshStatus];
}

- (void)unbindContract:(Contract *)aContract {
	NSAssert(aContract.invoice == self, @"can't unbind Contract which isn't bound to Invoice");

	aContract.invoice = nil;
	self.contract = nil;
	[self refreshStatus];
}

- (void)issued {
	// set date at which invoice is first issued (here by email) if not already set
	if (self.date == nil) {
		self.date = [NSDate date];
		[[DataStore defaultStore] saveInvoice:self];
	}
}



#pragma mark - LineItemOwner stack

- (NSNumber *)subTotal {
	return [LineItemsMath subTotalForLineItems:self.lineItems];
}

- (NSNumber *)total {
	return [LineItemsMath totalWithSubTotal:self.subTotal
					shippingAndHandlingCost:self.shippingAndHandlingCost];
}

- (NSNumber *)shippingAndHandlingCost {
	return [LineItemsMath shippingAndHandlingCostForLineItems:self.lineItems];
}

@end
