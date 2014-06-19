//
//  EstimatesViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "EstimatesViewController.h"
// API
#import "Contract.h"
#import "ClientInfo.h"
#import "DataStore.h"
#import "Estimate.h"
// Cells
#import "EstimateCell.h"
// Views
#import "NewOrPickClientInfoViewController.h"
#import "EstimateDetailViewController.h"


@interface EstimatesViewController ()

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation EstimatesViewController

@synthesize aNewOrPickClientInfoViewController;
@synthesize estimateDetailViewController;
@synthesize estimates;
@synthesize estimateCell;
@synthesize deleteIndexPath;
@synthesize warningIndexPath;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimatesViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Estimates", @"Estimates Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

	// start with toolbar hidden (no animation)
	self.navigationController.toolbarHidden = YES;

	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	self.estimates = [[DataStore defaultStore] estimatesFetchedResultsController];
	estimates.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.warningIndexPath = nil;
	self.deleteIndexPath = nil;

	[self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	if (!editing) {
		// must remove warning row, if it exists, before exiting editing mode
		[self hideDeleteWarningForCell:[self.tableView cellForRowAtIndexPath:self.deleteIndexPath]];
	}
	[super setEditing:editing animated:animated];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [estimates.sections objectAtIndex:section];
    return [sectionInfo name];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return estimates.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [estimates.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects]
			+ ((self.warningIndexPath && self.warningIndexPath.section == section) ? 1 : 0);
	// NOTE: as section can be 0, it's vital to check if warningIndexPath is set before
	// sending it the section message (if not set, an message returning an int sent to nil
	// would return 0 and the condition would be true)
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;

	if ([self.warningIndexPath isEqual:indexPath]) {
		static NSString *CellIdentifier = @"WarningCell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}		
	}
	else {
		static NSString *CellIdentifier = @"EstimateCell";

		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
			cell = (UITableViewCell *)estimateCell;
			self.estimateCell = nil;
		}
	}

	[self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
	if ([self.warningIndexPath isEqual:indexPath]) {
		Estimate *estimate = [estimates objectAtIndexPath:self.deleteIndexPath];

		if (estimate.contract.invoice != nil) {
			aCell.textLabel.text = NSLocalizedString(@"1 Contract & 1 Invoice will be deleted", "");
		}
		else if (estimate.contract != nil) {
			aCell.textLabel.text = NSLocalizedString(@"1 Contract will be deleted", "");
		}

		aCell.textLabel.font = [UIFont systemFontOfSize:16];
		aCell.textLabel.textColor = [UIColor redColor];
		aCell.textLabel.textAlignment = UITextAlignmentCenter;

		UIColor *veryLightGray = [UIColor colorWithWhite:0.85 alpha:1.0];
		aCell.contentView.backgroundColor = veryLightGray;
		aCell.textLabel.backgroundColor = veryLightGray;
	}
	else {
		EstimateCell *cell = (EstimateCell *)aCell;

		static CGFloat DRIMJAS_GREEN_R = 0.31;			// 79 from 0-255 to 0.0-1.0 range
		static CGFloat DRIMJAS_GREEN_G = 0.56;			// 143 from 0-255 to 0.0-1.0 range
		static CGFloat DRIMJAS_GREEN_B = 0.0;

		Estimate *estimate = [estimates objectAtIndexPath:indexPath];

		cell.clientName.text = estimate.clientInfo.name;
		cell.orderNumber.text = estimate.orderNumber;
		if (estimate.isReady) {
			cell.status.text = NSLocalizedString(@"Ready","Ready status");
			// Drimjas green
			cell.status.textColor = [UIColor colorWithRed:DRIMJAS_GREEN_R green:DRIMJAS_GREEN_G blue:DRIMJAS_GREEN_B alpha:1.0];
		} else {
			cell.status.text = NSLocalizedString(@"Draft","Draft status");
			cell.status.textColor = [UIColor redColor];
		}

		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[DataStore defaultStore] deleteEstimate:[estimates objectAtIndexPath:indexPath]];
    }  
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	estimateDetailViewController.estimate = [estimates objectAtIndexPath:indexPath];

	[self.navigationController pushViewController:estimateDetailViewController animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	// no minus sign in front of warning cell
	if ([self.warningIndexPath isEqual:indexPath]) {
		return UITableViewCellEditingStyleNone;
	}
	return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	// don't indent warning row when tableview in edit mode
	return ![self.warningIndexPath isEqual:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
	// don't indent warning row when tableview swiped
	return [self.warningIndexPath isEqual:indexPath] ? 0 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.warningIndexPath isEqual:indexPath]) {
		return 30.0;
	}
	return UITableViewAutomaticDimension;
}

// when cell is "swiped to delete"
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	[self showDeleteWarningForCell:[self.tableView cellForRowAtIndexPath:indexPath]];
	// toggle Edit button to Done
	self.editing = YES;
}

// when cell is un-"swiped to delete"
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	// toggle Done button back to Edit
	// (this will trigger our overriden setEditing:animated:
	// which will remove the warning row if necessary)
	self.editing = NO;
}


#pragma mark -
#pragma mark FetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

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


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


#pragma mark -
#pragma mark Button delegate

- (IBAction)add:(id)sender {
	[self.navigationController pushViewController:aNewOrPickClientInfoViewController animated:YES];
}


#pragma mark -
#pragma mark Public implementation stack

- (void)showDeleteWarningForCell:(UITableViewCell *)cell {
	// keep track of the cell's indexPath so cellForRowAtIndexPath can lookup the estimate to generate the warning message
	self.deleteIndexPath = [self.tableView indexPathForCell:cell];

	Estimate *estimate = [estimates objectAtIndexPath:self.deleteIndexPath];

	if (estimate.contract != nil) {
		// keep track of the warning's indexPath so numberOfRowForSection can return a proper number of row
		self.warningIndexPath = [NSIndexPath indexPathForRow:(self.deleteIndexPath.row + 1)
												   inSection:self.deleteIndexPath.section];
		[self.tableView beginUpdates];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:self.warningIndexPath]
							  withRowAnimation:UITableViewRowAnimationAutomatic];
		[self.tableView endUpdates];
	}
}

- (void)hideDeleteWarningForCell:(UITableViewCell *)cell {
	if (self.warningIndexPath) {
		NSIndexPath *indexPath = self.warningIndexPath;
		self.warningIndexPath = nil;
		self.deleteIndexPath = nil;

		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							  withRowAnimation:UITableViewRowAnimationAutomatic];
		[self.tableView	endUpdates];
	}
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
	NSLog(@"EstimatesViewController.viewDidUnload");
#endif
    [super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.estimateDetailViewController = nil;
	self.aNewOrPickClientInfoViewController = nil;
	self.estimates = nil;
	self.navigationItem.leftBarButtonItem = nil;
	self.estimateCell = nil;
	self.deleteIndexPath = nil;
	self.warningIndexPath = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
}




@end

