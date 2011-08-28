//
//  Currency.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "Currency.h"
// API
#import "DataStore.h"

@implementation Currency

@dynamic isoCode;

- (void)awakeFromInsert {
	[super awakeFromInsert];

	self.subEntityName = @"Currency";

	// currency is always first row in screen
	self.index = [NSNumber numberWithInt:0];

	// initialize ISO code from current Settings > International > Region Format
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	self.isoCode = [numberFormatter currencyCode];
	[numberFormatter release];
}

- (BOOL)isReady {
	return (self.isoCode.length > 0);
}

- (void)didSave {
	// isPersistent will be set manually
}

+ (BOOL)isReadyStatus {
	// NOTE: isPersistent is used to make sure Taxes & Currency is at least presented once
	// to user (since isoCode is prefilled, isReady would always return true)
	Currency *currency = [[DataStore defaultStore] currency];
	return (currency.isPersistent && currency.isReady);
}

@end
