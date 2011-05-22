//
//  AddEstimateLineItemsViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateLineItemsViewController.h"
// API
#import "DataStore.h"
#import "Estimate.h"
#import "LineItemSelection.h"
#import "LineItem.h"
// Views
#import "TableFields.h"

@implementation AddEstimateLineItemsViewController

@synthesize nextButton;
@synthesize lineItemSelections;
@synthesize estimate;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateLineItemsViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Add Line Item", "AddEstimateLineItems Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

    self.navigationItem.rightBarButtonItem = nextButton;

	// show add/delete widgets in front of rows
	[self.tableView setEditing:YES animated:NO];
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	// it might be problematic later to always fetch a stub, maybe previous view controller should set it
	self.estimate = [[DataStore defaultStore] estimateStub];
	self.lineItemSelections = [[DataStore defaultStore] lineItemSelectionsForEstimate:estimate];
	lineItemSelections.delegate = self;

	[self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

	// it might be problematic for next controller to pass value back that estimate is cleared
	self.estimate = nil;
	lineItemSelections.delegate = nil;
	self.lineItemSelections = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Private stack

- (NSInteger)_addLineItemSection {
	// "add line item" section is always last
	return lineItemSelections.sections.count;
}

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *listIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
	LineItemSelection *lineItem = [lineItemSelections objectAtIndexPath:listIndexPath];

	if (indexPath.row == LineItemSelectionFieldName) {
		cell.textLabel.text = lineItem.lineItem.name;
	} else if (indexPath.row == LineItemSelectionFieldDetails) {
		cell.textLabel.text = lineItem.details;
	} else if (indexPath.row == LineItemSelectionFieldQuantity) {
		cell.textLabel.text = [lineItem.quantity stringValue];
	} else if (indexPath.row == LineItemSelectionFieldUnitCost) {
		cell.textLabel.text = [lineItem.unitCost stringValue];
	}
}

- (void)_insertLineItemSelectionForIndexPath:(NSIndexPath *)indexPath {
	LineItemSelection *lineItemSelection = [[DataStore defaultStore] createLineItemSelection];

	lineItemSelection.index = [NSNumber numberWithInteger:lineItemSelections.sections.count];
	lineItemSelection.estimate = estimate;
	[estimate addLineItemsObject:lineItemSelection];

	NSLog(@"click! estimate has %u line item selection(s), fetched controller %u", estimate.lineItems.count, lineItemSelections.sections.count);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog(@"number of section in table %u", lineItemSelections.sections.count);
    // 1 section per line item selection, plus 1 section to add a line item
    return 1 + lineItemSelections.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == [self _addLineItemSection]) {
		// "add a line item" section has only 1 row
		return 1;
	} else {
		return numLineItemSelectionField;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [self _addLineItemSection]) {
		static NSString *CellIdentifier = @"AddLineItemSelectionCell";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		cell.textLabel.text = NSLocalizedString(@"Add a Line Item", "AddEstimateLineItem Add A Line Item Row");

		return cell;
	} else {
		static NSString *CellIdentifier = @"TextFieldCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		[self _configureCell:cell atIndexPath:indexPath];
		return cell;
	}

	return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	// show a plus sign in front of "add a line item" row
	if (indexPath.section == [self _addLineItemSection]) {
		return UITableViewCellEditingStyleInsert;
	}
	// show a minus sign in front of 1st row of a contact info section
	else if (indexPath.section != [self _addLineItemSection] && indexPath.row == 0) {
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self _insertLineItemSelectionForIndexPath:indexPath];
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == [self _addLineItemSection]) {
		// deselect cell immediately
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[cell setSelected:NO animated:YES];

		[self _insertLineItemSelectionForIndexPath:indexPath];
	}
}


#pragma mark -
#pragma mark FetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	NSLog(@"controllerWillChangeContent");
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	NSLog(@"didChangeObject");

    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
		// TODO these 2 are probably not needed
        case NSFetchedResultsChangeUpdate:
			NSLog(@"didChangeObject update");
            [self _configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
			NSLog(@"didChangeObject move");
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	NSLog(@"didChangeSection");

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	NSLog(@"controllerDidChangeContent");
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)next:(id)sender {
	// save estimate into estimates list
	[[DataStore defaultStore] saveEstimateStub];

	// hide client info view
	[self dismissModalViewControllerAnimated:YES];

	// reset navigation controller to first view
	[self.navigationController popToRootViewControllerAnimated:YES];
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
	NSLog(@"AddEstimateLineItemsViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.nextButton = nil;
	lineItemSelections.delegate = nil;
	self.lineItemSelections = nil;
	self.estimate = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateLineItemsViewController.dealloc");
#endif
	[nextButton release];
	[lineItemSelections release];
	[estimate release];
    [super dealloc];
}


@end

