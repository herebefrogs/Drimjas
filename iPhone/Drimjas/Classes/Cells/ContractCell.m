//
//  ContractCell.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-15.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "ContractCell.h"
// Views
#import "ContractsViewController.h"

@implementation ContractCell

@synthesize clientName;
@synthesize orderNumber;
@synthesize contractsViewController;

- (void)awakeFromNib {
	wasShowingDeleteButton = NO;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
	[super willTransitionToState:state];

	// NOTE: "swipe to delete" handled in table view controller since ShowingEditControl mask not set

	if ((state & UITableViewCellStateShowingDeleteConfirmationMask)
		&& (state & UITableViewCellStateShowingEditControlMask)
		&& !wasShowingDeleteButton) {
		// when cell in edit mode, it will show a Delete button,
		// notify its view controller so it can choose to show a warning
		// if appropriate for this contract
		wasShowingDeleteButton = YES;
		[contractsViewController showDeleteWarningForCell:self];
	}
	else if (!(state & UITableViewCellStateShowingDeleteConfirmationMask) && wasShowingDeleteButton) {
		// when cell is in edit mode, it will hide its Delete button,
		// notify its view controller so it can hide the warning
		// if it had been shown for this contract
		wasShowingDeleteButton = NO;
		[contractsViewController hideDeleteWarningForCell:self];
	}
}

@end
