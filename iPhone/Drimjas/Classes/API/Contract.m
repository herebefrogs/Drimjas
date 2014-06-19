//
//  Contract.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-23.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "Contract.h"
// API
#import "Estimate.h"
#import "Invoice.h"

@implementation Contract 

@dynamic estimate;
@dynamic invoice;


- (BOOL)isReady {
	return self.estimate.isReady;
}

- (void)bindEstimate:(Estimate *)anEstimate {
	anEstimate.contract = self;
	self.estimate = anEstimate;
	[self refreshStatus];
}

- (void)unbindEstimate:(Estimate *)anEstimate {
	NSAssert(anEstimate.contract == self, @"can't unbind Estimate which isn't bound to Contract");

	anEstimate.contract = nil;
	self.estimate = nil;
	[self refreshStatus];
}

@end
