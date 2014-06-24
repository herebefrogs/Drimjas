//
//  LineItem.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import "LineItem.h"
// API
#import "LineItemSelection.h"

@implementation LineItem

@dynamic defaults;
@dynamic desc;
@dynamic name;
@dynamic lineItemSelections;


- (BOOL)isReady {
	return (self.name.length > 0);
}

- (void)refreshStatus {
	NSNumber *oldStatus = self.status;

	[super refreshStatus];

	if (![oldStatus isEqualToNumber:self.status]) {
		// notify all underlying LineItemSelection of the status change
		for (LineItemSelection *lineItemSelection in self.lineItemSelections) {
			[lineItemSelection refreshStatus];
		}
	}

}

@end
