//
//  AddEstimateContactInfoViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-02.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateContactInfoViewController.h"
// API
#import "ClientInfo.h"
#import "ContactInformation.h"
#import "DataStore.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "AddEstimateLineItemsViewController.h"
#import "TableFields.h"


@implementation AddEstimateContactInfoViewController

@synthesize nextButton;
@synthesize lineItemsViewController;
@synthesize contactInfos;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateContactInfoViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Add Contact", "AddEstimateContactInfo Navigation Item Title");
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");

	// show add/delete widgets in front of rows
	[self.tableView setEditing:YES animated:NO];
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.navigationItem.rightBarButtonItem = nextButton;

	self.contactInfos = [[DataStore defaultStore] contactInfoStubs];

	// reload table data to match contact infos array
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

	// release estimate & contact infos now that all textfield had a chance to save their input in it
	self.contactInfos = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section per contact info, plus 1 section to add a contact info
    return 1 + self.contactInfos.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		// "add a contact info" section has only 1 row
		return 1;
	} else {
		// each contact info section has 3 rows
		return numContactInfoField;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
		static NSString *CellIdentifier = @"Cell";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		cell.textLabel.text = NSLocalizedString(@"Add a Contact", "Add Estimate Contact Information View Controller Add A Contact Row");

		return cell;
	}
	else {	
		static NSString *CellIdentifier = @"TextFieldCell";

		TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
			cell = textFieldCell;
			self.textFieldCell = nil;
		}

		// note:
		// - row is bounded to 3, so it will never spill on section which is unbounded
		// - section index decreased by 1 to account for "add a contact" section
		NSUInteger section = indexPath.section - 1;
		cell.textField.tag = 10*section + indexPath.row;

		ContactInformation *contactInfo = [contactInfos objectAtIndex:section];

		// initialize textfield value from contact info
		if (indexPath.row == ContactInfoFieldName) {
			cell.textField.placeholder = NSLocalizedString(@"Contact Name", "Contact Name Text Field Placeholder");
			cell.textField.text = contactInfo.name;
		}
		else if (indexPath.row == ContactInfoFieldPhone) {
			cell.textField.placeholder = NSLocalizedString(@"Phone", "Phone Text Field Placeholder");
			cell.textField.keyboardType = UIKeyboardTypePhonePad;
			// TODO add a phone number mask
			cell.textField.text = contactInfo.phone;
		}
		else if (indexPath.row == ContactInfoFieldEmail) {
			cell.textField.placeholder = NSLocalizedString(@"Email", "Email Text Field Placeholder");
			cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
			cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
			cell.textField.text = contactInfo.email;
		}

		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		return cell;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	// show a plus sign in front of "add a contact" row
	if (indexPath.section == 0) {
		return UITableViewCellEditingStyleInsert;
	}
	// show a minus sign in front of 1st row of a contact info section
	else if (indexPath.section != 0 && indexPath.row == 0) {
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

- (void)insertContactInfoSection {
	// add a new contact information
	[[DataStore defaultStore] createContactInformationStub];

	[self.tableView insertSections:[NSIndexSet indexSetWithIndex:contactInfos.count]
				  withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self insertContactInfoSection];
	}
	else if (editingStyle == UITableViewCellEditingStyleDelete) {
		// hide keyboard if visible
		[lastTextFieldEdited resignFirstResponder];

		// note: section index decremented to account for "add a contact" section
		[contactInfos removeObjectAtIndex:indexPath.section - 1];

		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

		// discard reference to textfield now that its section has been deleted
		lastTextFieldEdited = nil;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		// deselect cell immediately
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[cell setSelected:NO animated:YES];

		[self insertContactInfoSection];
	}
}

#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSUInteger section = textField.tag / 10;
	NSUInteger row = textField.tag - (10 * section);

	ContactInformation *contactInfo = [contactInfos objectAtIndex:section];

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
	// TODO maybe should associate contact info stubs to client info stub right away
	[self.navigationController pushViewController:lineItemsViewController animated:YES];
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
	NSLog(@"AddEstimateContactInfoViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.nextButton = nil;
	self.lineItemsViewController = nil;
	self.contactInfos = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateContactInfoViewController.dealloc");
#endif
	[nextButton release];
	[lineItemsViewController release];
	[contactInfos release];
    [super dealloc];
}


@end

