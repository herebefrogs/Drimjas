//
//  TextFieldTableViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-06.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import "TextFieldTableViewController.h"
// Cells
#import "TextFieldCell.h"


@implementation TextFieldTableViewController

@synthesize textFieldCell;
@synthesize lastTextFieldEdited;

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

	// Textfield defaults are:
	// - autocapitalization: sentences
	// - autocorrection: none
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	// embed Insert/Delete controls inside cells so they still take the entire screen width
	return NO;
}

#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.lastTextFieldEdited = textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	// hide keyboard
	BOOL hasResigned = [textField resignFirstResponder];

    if (lastTextFieldEdited == textField && hasResigned) {
        self.lastTextFieldEdited = nil;
    }

    return hasResigned;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	return [self textFieldShouldEndEditing:textField];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.textFieldCell = nil;
    self.lastTextFieldEdited = nil;
}




@end

