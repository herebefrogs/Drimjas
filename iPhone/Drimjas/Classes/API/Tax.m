//
//  Tax.m
//  WorkingTitle
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

- (void) awakeFromInsert {
	[super awakeFromInsert];

	self.subEntityName = @"Tax";

	self.index = [NSNumber numberWithInt:[[[[DataStore defaultStore] taxesAndCurrencyFetchedResultsController] sections] count]];
}

@end
