//
//  LineItem.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LineItem.h"
// API
#import "LineItemSelection.h"

@implementation LineItem

@dynamic preset;
@dynamic details;
@dynamic name;
@dynamic lineItemSelections;


- (BOOL)isValid {
	return (self.name != nil && self.name.length > 0);
}

@end
