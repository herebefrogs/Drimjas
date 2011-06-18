//
//  Currency.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Currency.h"


@implementation Currency

@dynamic isoCode;

- (void) awakeFromInsert {
	[super awakeFromInsert];
	// initialize ISO code from current Settings > International > Region Format
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	self.isoCode = [numberFormatter currencyCode];
	[numberFormatter release];
}

@end