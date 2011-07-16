//
//  TextFieldTableViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-06.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "TextFieldTableViewController.h"
// Cells
#import "TextFieldCell.h"


@implementation TextFieldTableViewController

@synthesize textFieldCell;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	
	// clear last edited textfield
	lastTextFieldEdited = nil;
}

#pragma mark -
#pragma mark Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TextFieldCell";

    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = textFieldCell;
		self.textFieldCell = nil;
    }

	// FIXME will work for no more than 10 rows per section
	cell.textField.tag = (10 * indexPath.section) + indexPath.row;

	[self configureCell:cell atIndexPath:indexPath];

	return cell;
}

// subclasses should override this method to perfom custom cell configuration
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	// prevent textfield cells to be selected
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	// embed Insert/Delete controls inside cells so they still take the entire screen width
	return NO;
}

#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	lastTextFieldEdited = textField;
}

- (BOOL)requiredFieldsProvided:(UITextField *)textField {
	// subclasses should override this method to perfom checks on textfield value
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	// verify at least minimum fields have been provided
	if ([self requiredFieldsProvided:textField]) {
		// hide keyboard
		[textField resignFirstResponder];
		return YES;
	}
	// TODO show an overlay view next to text field to indicate it's empty
	return NO;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	return [self textFieldShouldEndEditing:textField];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.textFieldCell = nil;
}


- (void)dealloc {
	[textFieldCell release];
    [super dealloc];
}


@end

