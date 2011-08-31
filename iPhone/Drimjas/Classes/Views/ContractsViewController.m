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
// Views
#import "NewContractViewController.h"
#import "ContractDetailViewController.h"

@implementation ContractsViewController


@synthesize newContractViewController;
@synthesize contractDetailViewController;
@synthesize contracts;


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

	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Private implementation stack

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Contract *contract = [contracts objectAtIndexPath:indexPath];
	cell.textLabel.text = contract.estimate.clientInfo.name;
	cell.detailTextLabel.text = contract.estimate.orderNumber;

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    return [sectionInfo numberOfObjects];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

	[self configureCell:cell atIndexPath:indexPath];

    return cell;
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
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationBottom];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
	[self.navigationController pushViewController:newContractViewController animated:YES];
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
	self.newContractViewController = nil;
	self.contractDetailViewController = nil;
	self.contracts = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ContractsViewController.dealloc");
#endif
	[newContractViewController release];
	[contractDetailViewController release];
	[contracts release];
    [super dealloc];
}


@end

