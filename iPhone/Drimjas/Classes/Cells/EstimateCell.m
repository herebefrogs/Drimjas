//
//  StatusCell.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-16.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "EstimateCell.h"
// Views
#import "EstimatesViewController.h"

@implementation EstimateCell

@synthesize clientName;
@synthesize orderNumber;
@synthesize status;
@synthesize estimatesViewController;

- (void)awakeFromNib {
	wasShowingDeleteButton = NO;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
	[super willTransitionToState:state];

	// NOTE: "swipe to delete" handled in table view controller since ShowingEditControl mask not set

	if ((state & UITableViewCellStateShowingDeleteConfirmationMask)
		&& (state & UITableViewCellStateShowingEditControlMask)
		&& !wasShowingDeleteButton) {
		// when cell is in edit mode, it will show a Delete button,
		// notify its table view controller so it can choose to show
		// a warning if appropriate for this estimate
		wasShowingDeleteButton = YES;
		[estimatesViewController showDeleteWarningForCell:self];
	}
	else if (!(state & UITableViewCellStateShowingDeleteConfirmationMask) && wasShowingDeleteButton) {
		// when cell is leaving edit mode, it will hide its Delete button,
		// notify its view controller so it can hide the warning if it had
		// been displayed for this estimate
		wasShowingDeleteButton = NO;
		[estimatesViewController hideDeleteWarningForCell:self];
	}
}

@end
