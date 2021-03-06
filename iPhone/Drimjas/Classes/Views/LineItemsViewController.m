//
//  LineItemsViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import "LineItemsViewController.h"
// API
#import "DataStore.h"
#import "LineItem.h"
#import "LineItemSelection.h"
// Views
#import "NewLineItemViewController.h"


@implementation LineItemsViewController

@synthesize aNewLineItemViewController;
@synthesize lineItems;
@synthesize lineItemSelection;
@synthesize optionsMode;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"LineItemsViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	if (optionsMode) {
		self.title = NSLocalizedString(@"Manage Line Items", "LineItemsViewController Navigation Item Title (from Options)");
	} else {
		self.title = NSLocalizedString(@"Pick Line Item", "LineItemsViewController Navigation Item Title");
	}

	self.lineItems = [[DataStore defaultStore] lineItemsFetchedResultsController];
	lineItems.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (optionsMode) {
		// show add/delete widgets in front of rows
		[self.tableView setEditing:YES animated:NO];
		self.tableView.allowsSelectionDuringEditing = YES;
	}

	// refresh table in case user is viewing Line Items screen from Estimate creation & Options menu screens at the same time
	[self.tableView reloadData];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Private method stack

- (void)_showNewLineItem {
	aNewLineItemViewController.optionsMode = optionsMode;
	if (!optionsMode) {
		aNewLineItemViewController.lineItemSelection = lineItemSelection;
	}

	[self.navigationController pushViewController:aNewLineItemViewController animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		cell.textLabel.text = NSLocalizedString(@"New Line Item", "LineItemsViewController New Line Item Row");
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		// NOTE: reduce index path by 1 to account for extra "new line item" row not in line items list
		indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];

		LineItem *lineItem = [lineItems objectAtIndexPath:indexPath];
		cell.textLabel.text = NSLocalizedString(lineItem.name, "");
		if (optionsMode) {
			NSSet *lineItemsWithEstimates = [lineItem.lineItemSelections filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"estimate != nil"]];
			NSSet *uniqueEstimates = [lineItemsWithEstimates valueForKeyPath:@"@distinctUnionOfObjects.estimate"];

			NSSet *lineItemsWithInvoices = [lineItem.lineItemSelections filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"invoice != nil"]];
			NSSet *uniqueInvoices = [lineItemsWithInvoices valueForKeyPath:@"@distinctUnionOfObjects.invoice"];

			cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Used in %u estimate(s) and %u invoice(s)", "Line item estimates count"), uniqueEstimates.count, uniqueInvoices.count];
		} else {
			cell.detailTextLabel.text = NSLocalizedString(lineItem.desc, "");
		}

		if (optionsMode) {
			// prevent line item cells from being selected
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [lineItems.sections objectAtIndex:section];
    return 1 + [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;

	if (indexPath.row == 0) {
		static NSString *CellIdentifier = @"NewLineItemCell";

		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
	} else {
		static NSString *CellIdentifier = @"LineItemCell";

		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
	}

	[self configureCell:cell atIndexPath:indexPath];

	return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return UITableViewCellEditingStyleInsert;
	}
	else if (optionsMode) {
		return UITableViewCellEditingStyleDelete;
	}
	else {
		return UITableViewCellEditingStyleNone;
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// NOTE: reduce index path by 1 to account for extra "new line item" row not in line items list
		indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];

		[[DataStore defaultStore] deleteLineItem:[lineItems objectAtIndexPath:indexPath]];
    }
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self _showNewLineItem];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[self _showNewLineItem];
	}
	else if (!optionsMode) {
		// NOTE: reduce index path by 1 to account for extra "new line item" row not in line items list
		indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];

		[lineItemSelection copyLineItem:[lineItems objectAtIndexPath:indexPath]];

		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark FetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

	// NOTE: increase index path by 1 to account for extra "new line item" row not in line items list
	indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];

    switch(type) {
        case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"LineItemsViewController.viewDidUnload");
#endif
    [super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    lineItems.delegate = nil;
	self.lineItems = nil;
	self.lineItemSelection = nil;
	self.aNewLineItemViewController = nil;
}




@end

