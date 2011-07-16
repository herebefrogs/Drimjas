//
//  ContactInfosViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "ContactInfosViewController.h"
// API
#import "ClientInfo.h"
#import "ContactInfo.h"
#import "DataStore.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "AddEstimateLineItemsViewController.h"
#import "TableFields.h"


@implementation ContactInfosViewController

@synthesize nextButton;
@synthesize saveButton;
@synthesize lineItemsSelectionViewController;
@synthesize contactInfos;
@synthesize clientInfo;
@synthesize editMode;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ContactInfosViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Add Contact", "ContactInfos Navigation Item Title");
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");

	// show add/delete widgets in front of rows
	[self.tableView setEditing:YES animated:NO];
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (!editMode) {
		self.clientInfo = [[[DataStore defaultStore] estimateStub] clientInfo];
	}
	self.contactInfos = [[DataStore defaultStore] contactInfosForClientInfo:clientInfo];
	contactInfos.delegate = self;

	self.navigationItem.rightBarButtonItem = editMode ? saveButton : nextButton;

	// reload table data to match contact infos array
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	// when pressing Back button, give a chance to textfield currently edited
	// to save its text before previous view controller's viewWillAppear triggers
	[lastTextFieldEdited resignFirstResponder];

	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

	self.clientInfo = nil;
	self.contactInfos = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Private stack

- (NSInteger)_addContactInfoSection {
	// "add contact info" section is always last
	return contactInfos.sections.count;
}

BOOL _contactInfoInserted = NO;

- (void)_insertContactInfoAtSection:(NSUInteger)section {
	ContactInfo *contactInfo = [[DataStore defaultStore] createContactInfo];
	[clientInfo bindContactInfo:contactInfo];

	_contactInfoInserted = YES;

	contactInfo.index = [NSNumber numberWithInt:section];
}

- (void) _deleteContactInfoAtSection:(NSUInteger)section {
	// NOTE: force textfield input to be processed while its tag is still valid
	// (aka before sections get reordered as a result of the deletion)
	[lastTextFieldEdited resignFirstResponder];
	lastTextFieldEdited = nil;

	ContactInfo *deleted = [contactInfos.fetchedObjects objectAtIndex:section];

	// shift all indexes down by 1 for line item selections after the one being deleted
	NSRange afterDeleted;
	afterDeleted.location = section;
	afterDeleted.length = contactInfos.sections.count - section;
	for (ContactInfo *contactInfo in [contactInfos.fetchedObjects subarrayWithRange:afterDeleted]) {
		contactInfo.index = [NSNumber numberWithInt:[contactInfo.index intValue] - 1];
	}

	[clientInfo unbindContactInfo:deleted];
	[[DataStore defaultStore] deleteContactInfo:deleted];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [self _addContactInfoSection]) {
		cell.textLabel.text = NSLocalizedString(@"Add a Contact", "ContactInfos Add A Contact Row");
	}
	else {
		[super configureCell:cell atIndexPath:indexPath];
		TextFieldCell *tfCell = (TextFieldCell *)cell;

		ContactInfo *contactInfo = [contactInfos.fetchedObjects objectAtIndex:indexPath.section];

		// initialize textfield value from contact info
		if (indexPath.row == ContactInfoFieldName) {
			tfCell.textField.placeholder = NSLocalizedString(@"Contact Name", "Contact Name Text Field Placeholder");
			tfCell.textField.text = contactInfo.name;
		}
		else if (indexPath.row == ContactInfoFieldPhone) {
			tfCell.textField.placeholder = NSLocalizedString(@"Phone", "Phone Text Field Placeholder");
			tfCell.textField.keyboardType = UIKeyboardTypePhonePad;
			// TODO add a phone number mask
			tfCell.textField.text = contactInfo.phone;
		}
		else if (indexPath.row == ContactInfoFieldEmail) {
			tfCell.textField.placeholder = NSLocalizedString(@"Email", "Email Text Field Placeholder");
			tfCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
			tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			tfCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			tfCell.textField.text = contactInfo.email;
		}
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section per contact info, plus 1 section to add a contact info
    return 1 + contactInfos.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == [self _addContactInfoSection]) {
		// "add a contact info" section has only 1 row
		return 1;
	} else {
		// each contact info section has 3 rows
		return numContactInfoField;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == [self _addContactInfoSection]) {
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
	// show a plus sign in front of "add a contact" row
	if (indexPath.section == [self _addContactInfoSection]) {
		return UITableViewCellEditingStyleInsert;
	}
	else {
		// show a minus sign in front of 1st row of a contact info section
		if (indexPath.row == ContactInfoFieldName) {
			return UITableViewCellEditingStyleDelete;
		}
		else {
			return UITableViewCellEditingStyleNone;
		}
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self _insertContactInfoAtSection:indexPath.section];
	}
	else if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self _deleteContactInfoAtSection:indexPath.section];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == [self _addContactInfoSection]) {
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		[cell setSelected:NO animated:YES];

		[self _insertContactInfoAtSection:indexPath.section];
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

	if (_contactInfoInserted) {
		_contactInfoInserted = NO;

		// scroll to keep "Add a Contact Info" row always visible at the bottom of the screen
		NSIndexPath *addContactInfoIndexPath = [NSIndexPath indexPathForRow:0 inSection:[self _addContactInfoSection]];
		[self.tableView scrollToRowAtIndexPath:addContactInfoIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSUInteger section = textField.tag / 10;
	NSUInteger row = textField.tag - (10 * section);

	ContactInfo *contactInfo = [contactInfos.fetchedObjects objectAtIndex:section];

	// TODO hide overlay view if any
	// save textfield value into estimate
	if (row == ContactInfoFieldName) {
		contactInfo.name = textField.text;
	}
	else if (row == ContactInfoFieldPhone) {
		contactInfo.phone = textField.text;
	}
	else if (row == ContactInfoFieldEmail) {
		contactInfo.email = textField.text;
	}
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)next:(id)sender {
	lineItemsSelectionViewController.editMode = NO;
	[self.navigationController pushViewController:lineItemsSelectionViewController animated:YES];
}

- (IBAction)save:(id)sender {
	[lastTextFieldEdited resignFirstResponder];

	[[DataStore defaultStore] saveClientInfo:clientInfo];

	[self.navigationController popViewControllerAnimated:YES];
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
	NSLog(@"ContactInfosViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.nextButton = nil;
	self.saveButton = nil;
	self.lineItemsSelectionViewController = nil;
	self.contactInfos = nil;
	self.clientInfo = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ContactInfosViewController.dealloc");
#endif
	[nextButton release];
	[saveButton release];
	[lineItemsSelectionViewController release];
	[contactInfos release];
	[clientInfo release];
    [super dealloc];
}


@end

