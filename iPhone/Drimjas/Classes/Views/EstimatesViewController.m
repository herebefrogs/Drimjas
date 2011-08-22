//
//  EstimatesViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "EstimatesViewController.h"
// API
#import "Estimate.h"
#import "ClientInfo.h"
#import "DataStore.h"
// Views
#import "AddEstimateNewOrPickClientInfoViewController.h"
#import "EstimateDetailViewController.h"


@implementation EstimatesViewController

@synthesize newOrPickClientInfoViewController;
@synthesize estimateDetailViewController;
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

NSUInteger STATUS_TAG = 42;
CGFloat DRIMJAS_GREEN_R = 0.31;			// 79 from 0-255 to 0.0-1.0 range
CGFloat DRIMJAS_GREEN_G = 0.56;			// 143 from 0-255 to 0.0-1.0 range
CGFloat DRIMJAS_GREEN_B = 0.0;
CGFloat STATUS_RIGHT_PADDING = 10.0;

- (void)_setStatusLabel:(NSNumber *)status forCell:(UITableViewCell *)cell {
	UILabel *statusLabel = (UILabel *)[cell.contentView viewWithTag:STATUS_TAG];
	if ([status intValue] == StatusReady) {
		statusLabel.text = NSLocalizedString(@"Ready","Ready status");
		// Drimjas green
		statusLabel.textColor = [UIColor colorWithRed:DRIMJAS_GREEN_R green:DRIMJAS_GREEN_G blue:DRIMJAS_GREEN_B alpha:1.0];
	} else {
		statusLabel.text = NSLocalizedString(@"Draft","Draft status");
		statusLabel.textColor = [UIColor redColor];
	}
}

- (void)_createStatusLabelForCell:(UITableViewCell *)cell {
	UILabel *statusLabel = [[[UILabel alloc] init] autorelease];
	statusLabel.tag = STATUS_TAG;

	// size & position
	CGFloat w = MAX([NSLocalizedString(@"Ready","Ready status") sizeWithFont:statusLabel.font].width,
					[NSLocalizedString(@"Draft","Draft status") sizeWithFont:statusLabel.font].width)
				+ STATUS_RIGHT_PADDING;
	CGFloat x = CGRectGetWidth(cell.contentView.bounds) - w;
	statusLabel.frame = CGRectMake(x, 0.0, w, CGRectGetHeight(cell.contentView.bounds));
	statusLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	statusLabel.textAlignment = UITextAlignmentCenter;

	[cell.contentView addSubview:statusLabel];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Estimate *estimate = [estimates objectAtIndexPath:indexPath];
    cell.textLabel.text = estimate.clientInfo.name;
	cell.detailTextLabel.text = estimate.orderNumber;
	[self _setStatusLabel:estimate.status forCell:cell];

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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		[self _createStatusLabelForCell:cell];
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
	estimateDetailViewController.estimate = [estimates objectAtIndexPath:indexPath];

	[self.navigationController pushViewController:estimateDetailViewController animated:YES];
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
	[self.navigationController pushViewController:newOrPickClientInfoViewController animated:YES];
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
	self.estimateDetailViewController = nil;
	self.newOrPickClientInfoViewController = nil;
	self.estimates = nil;
	self.navigationItem.leftBarButtonItem = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimatesViewController.dealloc");
#endif
	[estimateDetailViewController release];
	[newOrPickClientInfoViewController release];
	[estimates release];
    [super dealloc];
}


@end

