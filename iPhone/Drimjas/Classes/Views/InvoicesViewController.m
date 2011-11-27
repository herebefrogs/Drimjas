//
//  InvoicesViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-27.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "InvoicesViewController.h"
// API
#import "ClientInfo.h"
#import "Contract.h"
#import "DataStore.h"
#import "Estimate.h"
#import "Invoice.h"
// Cell
#import "InvoiceCell.h"


@interface InvoicesViewController ()

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation InvoicesViewController

@synthesize invoiceCell;
@synthesize invoices;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"InvoicesViewController.viewDidLoad");
#endif
    [super viewDidLoad];

	self.title = NSLocalizedString(@"Invoices", @"Invoices Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

	// start with toolbar hidden (no animation)
	self.navigationController.toolbarHidden = YES;

	self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.invoices = [[DataStore defaultStore] invoicesFetchedResultsController];
    invoices.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.invoiceCell = nil;
    self.invoices = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // TODO try without [self.tableView reloadData] supposed to be done by super
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> sectionInfo = [invoices.sections objectAtIndex:section];
    return [sectionInfo name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return invoices.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	id<NSFetchedResultsSectionInfo> sectionInfo = [invoices.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InvoiceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (UITableViewCell *)invoiceCell;
		self.invoiceCell = nil;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
    InvoiceCell *cell = (InvoiceCell *)aCell;

    static CGFloat DRIMJAS_GREEN_R = 0.31;			// 79 from 0-255 to 0.0-1.0 range
    static CGFloat DRIMJAS_GREEN_G = 0.56;			// 143 from 0-255 to 0.0-1.0 range
    static CGFloat DRIMJAS_GREEN_B = 0.0;

    Invoice *invoice = [invoices objectAtIndexPath:indexPath];
    cell.clientName.text = invoice.contract.estimate.clientInfo.name;
    cell.orderNumber.text = invoice.contract.estimate.orderNumber;
    if ([invoice.paid boolValue]) {
        cell.paid.text = NSLocalizedString(@"Paid", "Paid status");
        cell.paid.textColor = [UIColor colorWithRed:DRIMJAS_GREEN_R green:DRIMJAS_GREEN_G blue:DRIMJAS_GREEN_B alpha:1.0];
    } else {
        cell.paid.text = NSLocalizedString(@"Unpaid", "Unpaid status");
        cell.paid.textColor = [UIColor redColor];
    }

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Open InvoiceDetailViewController");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[DataStore defaultStore] deleteInvoice:[invoices objectAtIndexPath:indexPath] andSave:YES];
    }
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)add:(id)sender {
	NSLog(@"Open NewInvoiceViewController");
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

@end
