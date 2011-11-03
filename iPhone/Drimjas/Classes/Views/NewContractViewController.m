//
//  NewContractViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-23.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "NewContractViewController.h"
// API
#import "ClientInfo.h"
#import "Contract.h"
#import "DataStore.h"
#import "Estimate.h"
// Views
#import "ContractDetailViewController.h"

@implementation NewContractViewController


@synthesize estimates;
@synthesize contractDetailViewController;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"NewContractViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Pick Estimate", @"NewContract Navigation Item Title");

	self.estimates = [[DataStore defaultStore] contractReadyEstimatesFetchedResultsController];
	estimates.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// allow all orientations
    return YES;
}


#pragma mark -
#pragma mark Private implementation stack

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Estimate *estimate = [estimates objectAtIndexPath:indexPath];
	cell.textLabel.text = estimate.clientInfo.name;
	cell.detailTextLabel.text = estimate.orderNumber;

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

	[self configureCell:cell atIndexPath:indexPath];

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// create a new contract based on selected estimate
	Contract *contract = [[DataStore defaultStore] createContract];
	[contract bindEstimate:[estimates objectAtIndexPath:indexPath]];
	[[DataStore defaultStore] saveContract:contract];

	contractDetailViewController.contract = contract;

	// reset navigation controller to contracts list & contract detail view controllers,
	// discarding any contract creation view controllers in between
	UIViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
	[self.navigationController setViewControllers:[NSArray arrayWithObjects:rootController,
												   contractDetailViewController,
												   nil]
										 animated:YES];
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
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"NewContractViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.contractDetailViewController = nil;
	self.estimates = nil;
}




@end

