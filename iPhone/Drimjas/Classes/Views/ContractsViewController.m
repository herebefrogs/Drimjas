//
//  ContractsViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "ContractsViewController.h"
// API
#import "ClientInfo.h"
#import "Contract.h"
#import "DataStore.h"
#import "Estimate.h"
// Cells
#import "ContractCell.h"
// Views
#import "NewContractViewController.h"
#import "ContractDetailViewController.h"

@interface ContractsViewController ()

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation ContractsViewController


@synthesize aNewContractViewController;
@synthesize contractDetailViewController;
@synthesize contractCell;
@synthesize contracts;
@synthesize deleteIndexPath;
@synthesize warningIndexPath;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ContractsViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Contracts", @"Contracts Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

	// start with toolbar hidden (no animation)
	self.navigationController.toolbarHidden = YES;

	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	self.contracts = [[DataStore defaultStore] contractsFetchedResultsController];
	contracts.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.warningIndexPath = nil;
	self.deleteIndexPath = nil;

	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [contracts.sections objectAtIndex:section];
    return [sectionInfo name];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return contracts.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [contracts.sections objectAtIndex:section];
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
		static NSString *CellIdentifier = @"ContractCell";

		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
			cell = contractCell;
			self.contractCell = nil;
		}
	}

	[self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
	if ([self.warningIndexPath isEqual:indexPath]) {
		Contract *contract = [contracts objectAtIndexPath:self.deleteIndexPath];

		if (contract.invoice != nil) {
			aCell.textLabel.text = NSLocalizedString(@"1 Invoice will be deleted", "");
		}

		aCell.textLabel.font = [UIFont systemFontOfSize:16];
		aCell.textLabel.textColor = [UIColor redColor];
		aCell.textLabel.textAlignment = UITextAlignmentCenter;

		UIColor *veryLightGray = [UIColor colorWithWhite:0.85 alpha:1.0];
		aCell.contentView.backgroundColor = veryLightGray;
		aCell.textLabel.backgroundColor = veryLightGray;
	}
	else {
		ContractCell *cell = (ContractCell *)aCell;

		Contract *contract = [contracts objectAtIndexPath:indexPath];
		cell.clientName.text = contract.estimate.clientInfo.name;
		cell.orderNumber.text = contract.estimate.orderNumber;

		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[DataStore defaultStore] deleteContract:[contracts objectAtIndexPath:indexPath] andSave:YES];
    }  
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	contractDetailViewController.contract = [contracts objectAtIndexPath:indexPath];

	[self.navigationController pushViewController:contractDetailViewController animated:YES];
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

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	// when cell is "swiped to delete"...
	[self showDeleteWarningForCell:[self.tableView cellForRowAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	// when cell is un-"swiped to delete"...
	[self hideDeleteWarningForCell:[self.tableView cellForRowAtIndexPath:indexPath]];
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
	[self.navigationController pushViewController:aNewContractViewController animated:YES];
}


#pragma mark -
#pragma mark Public implementation stack

- (void)showDeleteWarningForCell:(UITableViewCell *)cell {
	// keep track of the cell's indexPath so cellForRowAtIndexPath can lookup the contract to generate the warning message
	self.deleteIndexPath = [self.tableView indexPathForCell:cell];

	Contract *contract = [contracts objectAtIndexPath:self.deleteIndexPath];

	if (contract.invoice != nil) {
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
	NSLog(@"ContractsViewController.viewDidUnload");
#endif
    [super viewDidUnload];
	self.aNewContractViewController = nil;
	self.contractDetailViewController = nil;
	self.contractCell = nil;
	self.contracts = nil;
	self.deleteIndexPath = nil;
	self.warningIndexPath = nil;
}




@end

