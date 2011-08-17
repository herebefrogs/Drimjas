//
//  LineItem.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "LineItem.h"
// API
#import "LineItemSelection.h"

@implementation LineItem

@dynamic defaults;
@dynamic desc;
@dynamic name;
@dynamic lineItemSelections;


- (BOOL)isValid {
	return (self.name.length > 0);
}

@end
