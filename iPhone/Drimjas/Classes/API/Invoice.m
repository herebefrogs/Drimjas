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
#import "Estimate.h"
#import "LineItemSelection.h"


@implementation Invoice

@dynamic contract;
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

@end
