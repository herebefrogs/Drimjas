//
//  ClientInfosViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-29.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "ClientInfosViewController.h"
// API
#import "ClientInfo.h"
#import "DataStore.h"
// Views
#import "ClientInfoDetailViewController.h"


@implementation ClientInfosViewController

@synthesize clientInfos;
@synthesize clientInfoDetailViewController;
@synthesize optionsMode;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ClientInfosViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	if (optionsMode) {
		self.title = NSLocalizedString(@"Manage Clients", "ClientInfos Navigation Item Title (from Options)");
	} else {
		self.title = NSLocalizedString(@"Pick Client", "ClientInfos Navigation Item Title");
	}

	self.clientInfos = [[DataStore defaultStore] clientInfosFetchedResultsController];
	clientInfos.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (optionsMode) {
		// show add/delete widgets in front of rows
		[self.tableView setEditing:YES animated:NO];
		self.tableView.allowsSelectionDuringEditing = YES;
	}

	// refresh table in case user is viewing Client Infos screen from Estimate creation & Options menu screens at the same time
	[self.tableView reloadData];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark Private method stack

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClientInfo *clientInfo = [clientInfos objectAtIndexPath:indexPath];
	cell.textLabel.text = clientInfo.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Used in %u estimate(s)","Client info estimates count"),
														   [[clientInfo valueForKeyPath:@"estimates.@count"] intValue]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return clientInfos.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [clientInfos.sections objectAtIndex:section];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[DataStore defaultStore] deleteClientInfo:[clientInfos objectAtIndexPath:indexPath]
										   andSave:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	clientInfoDetailViewController.clientInfo = [clientInfos objectAtIndexPath:indexPath];
	clientInfoDetailViewController.optionsMode = optionsMode;
	[self.navigationController pushViewController:clientInfoDetailViewController animated:YES];
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
	NSLog(@"ClientInfosViewController.viewDidUnload");
#endif
    [super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	clientInfos.delegate = nil;
	self.clientInfos = nil;
	self.clientInfoDetailViewController = nil;
}




@end

