//
//  Tax.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-19.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "Tax.h"
// API
#import "DataStore.h"


@implementation Tax

@dynamic name;
@dynamic percent;
@dynamic taxNumber;

- (void)awakeFromInsert {
	[super awakeFromInsert];

	self.subEntityName = @"Tax";

	self.index = [NSNumber numberWithInt:[[[[DataStore defaultStore] taxesAndCurrencyFetchedResultsController] sections] count]];
}

- (BOOL)isReady {
	return (self.name.length > 0) && (self.percent) && (self.taxNumber.length > 0);
}

+ (BOOL)isReadyStatus {
    BOOL isReady = YES;
    for (Tax* tax in [[DataStore defaultStore] taxes]) {
        isReady = isReady && [tax isReady];
    }
    return isReady;
}

- (NSNumber *)costForSubTotal:(NSNumber *)subTotal {
	CGFloat cost = [subTotal floatValue] * (self.percent != nil ? [self.percent floatValue] : 0.0) / 100.0;

	return [NSNumber numberWithFloat:cost];
}

@end
