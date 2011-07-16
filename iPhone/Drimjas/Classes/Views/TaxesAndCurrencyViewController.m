//
//  TaxesAndCurrencyViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "TaxesAndCurrencyViewController.h"
// API
#import "Currency.h"
#import "DataStore.h"
#import "MyInfo.h"
#import "Tax.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "MyInfoViewController.h"
#import "EstimateDetailViewController.h"
#import "TableFields.h"


@implementation TaxesAndCurrencyViewController


@synthesize nextButton;
@synthesize saveButton;
@synthesize myInfoViewController;
@synthesize estimateDetailViewController;
@synthesize taxesAndCurrency;
@synthesize optionsMode;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"TaxesAndCurrencyViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Taxes & Currency", "TaxesAndCurrencyView Navigation Item Title");
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");

	self.taxesAndCurrency = [[DataStore defaultStore] taxesAndCurrencyFetchedResultsController];
	taxesAndCurrency.delegate = self;
		
	// show add/delete widgets in front of rows
	[self.tableView setEditing:YES animated:NO];
	self.tableView.allowsSelectionDuringEditing = YES;
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.navigationItem.rightBarButtonItem = optionsMode || [MyInfo isMyInfoSet] ? saveButton : nextButton;

	// refresh table in case user is viewing Taxes & Currency screen from 1st Estimate creation & Options menu screens at the same time
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Private methods stack

- (NSUInteger)_addTaxSection {
	// "add tax" section is always last
	return taxesAndCurrency.sections.count;
}

BOOL _insertTax = NO;

- (void)_insertTaxAtIndexPath:(NSIndexPath *)indexPath {
	_insertTax = YES;

	[[DataStore defaultStore] createTax];
}

- (void)_deleteTaxAtIndexPath:(NSIndexPath *)indexPath {
	// NOTE: force textfield input to be processed while its tag is still valid
	// (aka before sections get reordered as a result of the deletion)
	[lastTextFieldEdited resignFirstResponder];
	lastTextFieldEdited = nil;

	NSAssert(indexPath.section != 0, @"Cannot delete Currency");

	Tax *deleted = [taxesAndCurrency.fetchedObjects objectAtIndex:indexPath.section];
	
	// shift all indexes down by 1 for taxes after the one being deleted
	NSRange afterDeleted;
	afterDeleted.location = indexPath.section;
	afterDeleted.length = taxesAndCurrency.sections.count - indexPath.section;
	for (Tax *tax in [taxesAndCurrency.fetchedObjects subarrayWithRange:afterDeleted]) {
		if ([tax.index intValue] > indexPath.section) {
			tax.index = [NSNumber numberWithInt:[tax.index intValue] - 1];
		}
	}
	
	[[DataStore defaultStore] deleteTax:deleted];
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return !optionsMode && section == TaxesAndCurrencySectionCurrency
		? NSLocalizedString(@"This can later be changed from the Options tab", "TaxesAndCurrencyViewController Table Header")
		: nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section per tax or currency, plus 1 section to add a tax
    return taxesAndCurrency.sections.count + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == [self _addTaxSection] || section == TaxesAndCurrencySectionCurrency) {
		return 1;
	}
	else {
		return numTaxesField;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == [self _addTaxSection]) {

		static NSString *CellIdentifier = @"Cell";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		[self configureCell:cell atIndexPath:indexPath];

		return cell;
	}
	else {
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	// show a plus sign in front of "add a tax" row
	if (indexPath.section == [self _addTaxSection]) {
		return UITableViewCellEditingStyleInsert;
	}
	// show a minus sign in front of 1st row of a tax section
	else if (indexPath.section != TaxesAndCurrencySectionCurrency && indexPath.row == 0) {
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self _insertTaxAtIndexPath:indexPath];
    }   
    else if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self _deleteTaxAtIndexPath:indexPath];
    }  
}

#pragma mark -
#pragma mark Table view delegate

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == [self _addTaxSection]) {
		aCell.textLabel.text = NSLocalizedString(@"Add a Tax", "TaxesAndCurrency Add A Tax Row");
	} else {
		[super configureCell:aCell atIndexPath:indexPath];

		TextFieldCell *tfCell = (TextFieldCell *)aCell;

		if (indexPath.section == TaxesAndCurrencySectionCurrency) {
			Currency *currency = [taxesAndCurrency.fetchedObjects objectAtIndex:indexPath.section];

			tfCell.textField.text = currency.isoCode;
			tfCell.textField.placeholder = NSLocalizedString(@"Currency Code", "TaxesAndCurrency Currency Code Placeholder");
			tfCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
		} else {
			Tax *tax = [taxesAndCurrency.fetchedObjects objectAtIndex:indexPath.section];
			
			if (indexPath.row == TaxesFieldName) {
				tfCell.textField.text = tax.name;
				tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
				tfCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
				tfCell.textField.placeholder = NSLocalizedString(@"Tax Name", "TaxesAndCurrency Tax Name Textfield placeholder");
			}
			else if (indexPath.row == TaxesFieldPercent) {
				if ([tax.percent floatValue]) {
					tfCell.textField.text = [tax.percent stringValue];
				}
				tfCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
				tfCell.textField.placeholder = NSLocalizedString(@"Percent", "TaxesAndCurrency Percent Textfield placeholder");
			}
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == [self _addTaxSection]) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		[cell setSelected:NO animated:YES];
		
		[self _insertTaxAtIndexPath:indexPath];
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

	if (_insertTax) {
		_insertTax = NO;
		
		// scroll to keep "add a tax" section always visible at the bottom of the screen
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[self _addTaxSection]];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}


#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSUInteger section = textField.tag / 10;
	NSUInteger row = textField.tag - (10 * section);

	if (section == TaxesAndCurrencySectionCurrency) {
		Currency *currency = [taxesAndCurrency.fetchedObjects objectAtIndex:section];
		currency.isoCode = textField.text;
	}
	else {
		Tax *tax = [taxesAndCurrency.fetchedObjects objectAtIndex:section];

		// TODO hide overlay view if any
		// save textfield value into tax
		if (row == TaxesFieldName) {
			tax.name = textField.text;
		}
		else if (row == TaxesFieldPercent) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			tax.percent = [numberFormatter numberFromString:textField.text];
			[numberFormatter release];
			// TODO show an overlay if nil
		}
	}
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)next:(id)sender {
	if (![MyInfo isMyInfoSet]) {
		[[DataStore defaultStore] saveTaxesAndCurrency];

		myInfoViewController.optionsMode = NO;
		[self.navigationController pushViewController:myInfoViewController animated:YES];
	}
	else {
		// maybe user went into Options screens and set My Information while
		// this screen was open; therefore Estimate is now ready to be saved
		[self save:sender];
	}
}

- (IBAction)save:(id)sender {
	[[DataStore defaultStore] saveTaxesAndCurrency];

	if (optionsMode) {
		// go back to Options screen
		[self.navigationController popViewControllerAnimated:YES];
	}
	else {
		// save estimate into estimates list
		estimateDetailViewController.estimate = [[DataStore defaultStore] saveEstimateStub];

		// reset navigation controller to review estimate view controller
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
	NSLog(@"TaxesAndCurrencyViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.nextButton = nil;
    self.saveButton = nil;
	self.myInfoViewController = nil;
	self.estimateDetailViewController = nil;
	self.taxesAndCurrency = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"TaxesAndCurrencyViewController.dealloc");
#endif
	[nextButton release];
	[saveButton release];
	[myInfoViewController release];
	[estimateDetailViewController release];
	[taxesAndCurrency release];
    [super dealloc];
}


@end

