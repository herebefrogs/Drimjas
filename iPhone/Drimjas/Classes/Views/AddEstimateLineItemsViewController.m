//
//  AddEstimateLineItemsViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "AddEstimateLineItemsViewController.h"
// API
#import "DataStore.h"
#import "Estimate.h"
#import "LineItemSelection.h"
#import "LineItem.h"
#import	"Currency.h"
#import "MyInfo.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "TableFields.h"
#import "LineItemsViewController.h"
#import "EstimateDetailViewController.h"
#import "TaxesAndCurrencyViewController.h"
#import "MyInfoViewController.h"

@implementation AddEstimateLineItemsViewController

@synthesize nextButton;
@synthesize saveButton;
@synthesize lineItemsViewController;
@synthesize estimateDetailViewController;
@synthesize	taxesAndCurrencyViewController;
@synthesize myInfoViewController;
@synthesize lineItemSelections;
@synthesize estimate;
@synthesize editMode;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateLineItemsViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Add Line Item", "AddEstimateLineItems Navigation Item Title");
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");

	// show add/delete widgets in front of rows
	[self.tableView setEditing:YES animated:NO];
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (!editMode) {
		self.estimate = [[DataStore defaultStore] estimateStub];
	}
	self.lineItemSelections = [[DataStore defaultStore] lineItemSelectionsForEstimate:estimate];
	lineItemSelections.delegate = self;

	// show Next button if taxes & currency or my info aren't set yet
	// show Save button if they are or if editing the line item selections from estimate detail screen
	self.navigationItem.rightBarButtonItem = ([Currency isCurrencySet] && [MyInfo isMyInfoSet]) || editMode ? saveButton : nextButton;

	[self.tableView reloadData];
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

- (BOOL)_lineItem:(LineItemSelection *)lineItem isHandlingAndShippingQuantityAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row == LineItemSelectionFieldQuantity 
			&& [lineItem.lineItem.name isEqualToString:NSLocalizedString(@"Handling & Shipping", "")];
}

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == [self _addLineItemSection]) {
		cell.textLabel.text = NSLocalizedString(@"Add a Line Item", "AddEstimateLineItem Add A Line Item Row");
	} else {
		LineItemSelection *lineItem = [lineItemSelections.fetchedObjects objectAtIndex:indexPath.section];

		if (indexPath.row == LineItemSelectionFieldName) {
			cell.textLabel.text = lineItem.lineItem.name;
			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else if ([self _lineItem:lineItem isHandlingAndShippingQuantityAtIndexPath:indexPath]) {
			cell.textLabel.text = [lineItem.quantity stringValue];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		else {
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			TextFieldCell *tfCell = (TextFieldCell *)cell;

			if (indexPath.row == LineItemSelectionFieldDescription) {
				tfCell.textField.text = lineItem.desc;
				tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
				tfCell.textField.placeholder = NSLocalizedString(@"Description", "AddEstimateLineItemsViewController Description Textfield placeholder");
			}
			else if (indexPath.row == LineItemSelectionFieldQuantity) {
				if ([lineItem.quantity intValue]) {
					tfCell.textField.text = [lineItem.quantity stringValue];
				}
				tfCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				tfCell.textField.placeholder = NSLocalizedString(@"Quantity", "AddEstimateLineItemsViewController Quantity Textfield placeholder");
			}
			else if (indexPath.row == LineItemSelectionFieldUnitCost) {
				if ([lineItem.unitCost intValue]) {
					tfCell.textField.text = [lineItem.unitCost stringValue];
				}
				tfCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				tfCell.textField.placeholder = NSLocalizedString(@"Unit Cost", "AddEstimateLineItemsViewController Unit Cost Textfield placeholder");
			}
		}
	}
}

- (void)_showLineItemsListWithLineItemSelection:(LineItemSelection *)lineItemSelection {
	lineItemsViewController.optionsMode = NO;
	lineItemsViewController.lineItemSelection = lineItemSelection;

	[self.navigationController pushViewController:lineItemsViewController animated:YES];
}

BOOL _insertLineItem = NO;

- (void)_insertLineItemSelectionForIndexPath:(NSIndexPath *)indexPath {
	LineItemSelection *lineItemSelection = [[DataStore defaultStore] createLineItemSelection];

	_insertLineItem = YES;

	lineItemSelection.index = [NSNumber numberWithInteger:lineItemSelections.sections.count];
	lineItemSelection.estimate = estimate;
	[estimate addLineItemsObject:lineItemSelection];

	[self _showLineItemsListWithLineItemSelection:lineItemSelection];
}

- (void)_deleteLineItemSelectionForIndexPath:(NSIndexPath *)indexPath {
	// NOTE: force textfield input to be processed while its tag is still valid
	// (aka before sections get reordered as a result of the deletion)
	[lastTextFieldEdited resignFirstResponder];
	lastTextFieldEdited = nil;
	
	LineItemSelection *deleted = [lineItemSelections.fetchedObjects objectAtIndex:indexPath.section];

	// shift all indexes down by 1 for line item selections after the one being deleted
	NSRange afterDeleted;
	afterDeleted.location = indexPath.section;
	afterDeleted.length = lineItemSelections.sections.count - indexPath.section;
	for (LineItemSelection *lineItem in [lineItemSelections.fetchedObjects subarrayWithRange:afterDeleted]) {
		if ([lineItem.index intValue] > indexPath.section) {
			lineItem.index = [NSNumber numberWithInt:[lineItem.index intValue] - 1];
		}
	}

	// deassociate line item selection from estimate
	[estimate removeLineItemsObject:deleted];
	// delete line item selection
	[[DataStore defaultStore] deleteLineItemSelection:deleted];
}

- (NSNumber *)_numberWithString:(NSString *)string {
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

	NSNumber *number = [numberFormatter numberFromString:string];

	[numberFormatter release];

	return number;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section per line item selection, plus 1 section to add a line item
    return 1 + lineItemSelections.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == [self _addLineItemSection]) {
		// "add a line item" section has only 1 row
		return 1;
	} else {
		// TODO special case: Handling & Shipping doesn't need a quantity row
		return numLineItemSelectionField;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;

    if (indexPath.section == [self _addLineItemSection]
		|| indexPath.row == LineItemSelectionFieldName
		|| [self _lineItem:[lineItemSelections.fetchedObjects objectAtIndex:indexPath.section] isHandlingAndShippingQuantityAtIndexPath:indexPath]) {

		static NSString *CellIdentifier = @"Cell";

		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
	} else {
		static NSString *CellIdentifier = @"TextFieldCell";
		
		cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
			cell = textFieldCell;
			self.textFieldCell = nil;
		}

		((TextFieldCell *) cell).textField.tag = (10 * indexPath.section) + indexPath.row;
	}

	[self _configureCell:cell atIndexPath:indexPath];

	return cell;
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self _insertLineItemSelectionForIndexPath:indexPath];
    }
	else if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self _deleteLineItemSelectionForIndexPath:indexPath];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == [self _addLineItemSection]) {
		[self _insertLineItemSelectionForIndexPath:indexPath];
	}
	else if (indexPath.row == LineItemSelectionFieldName) {
		[self _showLineItemsListWithLineItemSelection:[lineItemSelections objectAtIndexPath:indexPath]];
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

    switch(type) {
        case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self _configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

	if (_insertLineItem) {
		_insertLineItem = NO;

		// scroll to keep "Add a Line Item" row always visible at the bottom of the screen
		NSIndexPath *addLineItemIndexPath = [NSIndexPath indexPathForRow:0 inSection:[self _addLineItemSection]];
		[self.tableView scrollToRowAtIndexPath:addLineItemIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}


#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSUInteger section = textField.tag / 10;
	NSUInteger row = textField.tag - (10 * section);

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
	LineItemSelection *lineItem = [lineItemSelections objectAtIndexPath:indexPath];

	// TODO hide overlay view if any
	// save textfield value into line item selection
	if (row == LineItemSelectionFieldDescription) {
		lineItem.desc = textField.text;
	}
	else if (row == LineItemSelectionFieldQuantity) {
		lineItem.quantity = [self _numberWithString:textField.text];
		// TODO show an overlay if nil
	}
	else if (row == LineItemSelectionFieldUnitCost) {
		lineItem.unitCost = [self _numberWithString:textField.text];
		// TODO show an overlay if nil
	}
}


#pragma mark -
#pragma mark Button delegate

- (IBAction)next:(id)sender {
	if (![Currency isCurrencySet]) {
		[self.navigationController pushViewController:taxesAndCurrencyViewController animated:YES];
	}
	else if (![MyInfo isMyInfoSet]) {
		myInfoViewController.optionsMode = NO;
		[self.navigationController pushViewController:myInfoViewController animated:YES];
	}
	else {
		// maybe user went into Options screens and set both Currency/Taxes & My Information
		// while this screen was open; therefore Estimate is now ready to be saved
		[self save:sender];
	}
}

- (IBAction)save:(id)sender {
	// save estimate into estimates list
	estimateDetailViewController.estimate = [[DataStore defaultStore] saveEstimateStub];

	if (editMode) {
		// go back to estimate detail view controller (just before in the stack)
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
		// reset navigation controller to estimates list & estimate detail view controllers,
		// discarding any estimate creation view controllers in between
		UIViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
		[self.navigationController setViewControllers:[NSArray arrayWithObjects:rootController,
																				estimateDetailViewController,
																				nil]
											 animated:YES];
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
	NSLog(@"AddEstimateLineItemsViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.nextButton = nil;
    self.saveButton = nil;
	self.lineItemsViewController = nil;
	self.estimateDetailViewController = nil;
	self.taxesAndCurrencyViewController = nil;
	self.myInfoViewController = nil;
	lineItemSelections.delegate = nil;
	self.lineItemSelections = nil;
	self.estimate = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateLineItemsViewController.dealloc");
#endif
	[nextButton release];
	[saveButton release];
	[lineItemsViewController release];
	[estimateDetailViewController release];
	[taxesAndCurrencyViewController release];
	[myInfoViewController release];
	[lineItemSelections release];
	[estimate release];
    [super dealloc];
}


@end

