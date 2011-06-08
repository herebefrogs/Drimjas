//
//  EstimatesViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstimatesViewController.h"
// API
#import "Estimate.h"
#import "ClientInformation.h"
#import "DataStore.h"
// Views
#import "AddEstimateNewOrPickClientInfoViewController.h"
#import "ReviewEstimateViewController.h"


@implementation EstimatesViewController

@synthesize addEstimateNavigationController;
@synthesize newOrPickClientInfoViewController;
@synthesize reviewEstimateViewController;
@synthesize estimates;

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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
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
	reviewEstimateViewController.estimate = [estimates objectAtIndexPath:indexPath];

	[self.navigationController pushViewController:reviewEstimateViewController animated:YES];
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
	[self presentModalViewController:addEstimateNavigationController animated:YES];
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.reviewEstimateViewController = nil;
	self.newOrPickClientInfoViewController = nil;
	self.addEstimateNavigationController = nil;
	self.estimates = nil;
	self.navigationItem.leftBarButtonItem = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimatesViewController.dealloc");
#endif
	[reviewEstimateViewController release];
	[newOrPickClientInfoViewController release];
	[addEstimateNavigationController release];
	[estimates release];
    [super dealloc];
}


@end

