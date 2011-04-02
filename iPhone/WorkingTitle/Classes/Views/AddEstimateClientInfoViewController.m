//
//  AddEstimateViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateClientInfoViewController.h"
// API
#import "Estimate.h"
#import "ClientInformation.h"
#import "Datastore.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "AddEstimateContactInfoViewController.h"
#import "TableFields.h"


@implementation AddEstimateClientInfoViewController

@synthesize nextButton;
@synthesize contactInfoViewController;
@synthesize estimate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateClientInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Add Client", "AddEstimateClientInfo Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;
	nextButton.title = NSLocalizedString(@"Next", "AddEstimateClientInfo Next Button Title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.navigationItem.rightBarButtonItem = nextButton;

	self.estimate = [[DataStore defaultStore] estimateStub];

	// initialize client information if needed
	if (estimate.clientInfo == nil) {
		ClientInformation *clientInfo = [[DataStore defaultStore] createClientInformation];
		estimate.clientInfo = clientInfo;

		NSMutableSet *estimates = [clientInfo mutableSetValueForKey:@"estimates"];
		[estimates addObject:estimate];
	}

	// reload table data to match estimate object
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

	// release estimate now that all textfield had a chance to save their input in it
	self.estimate = nil;
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return numClientInfoField;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"TextFieldCell";

    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = textFieldCell;
		self.textFieldCell = nil;
    }

	cell.textField.tag = indexPath.row;

	// initialize textfield value from estimate
	if (indexPath.row == ClientInfoFieldName) {
		cell.textField.placeholder = NSLocalizedString(@"Client Name", "Client Name Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.name;
	}
	else if (indexPath.row == ClientInfoFieldAddress1) {
		cell.textField.placeholder = NSLocalizedString(@"Address 1", "Address 1 Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.address1;
	}
	else if (indexPath.row == ClientInfoFieldAddress2) {
		cell.textField.placeholder = NSLocalizedString(@"Address 2", "Address 2 Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.address2;
	}
	else if (indexPath.row == ClientInfoFieldCity) {
		cell.textField.placeholder = NSLocalizedString(@"City", "City Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.city;
	}
	else if (indexPath.row == ClientInfoFieldState) {
		cell.textField.placeholder = NSLocalizedString(@"State", "State Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.state;
	}
	else if (indexPath.row == ClientInfoFieldPostalCode) {
		cell.textField.placeholder = NSLocalizedString(@"Postal Code", "Postal Code Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.postalCode;
	}
	else if (indexPath.row == ClientInfoFieldCountry) {
		cell.textField.placeholder = NSLocalizedString(@"Country", "Country Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.country;
	}

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


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
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

#pragma mark -
#pragma mark Button & Textfield delegate

- (IBAction)next:(id)sender {
	// retrieve client name cell if visible
	TextFieldCell *cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:ClientInfoFieldName inSection:0]];

	// verify client name was provided before saving
	if ((cell != nil && [ClientInformation isNameValid:cell.textField.text])
		|| [ClientInformation isNameValid:estimate.clientInfo.name]) {

		// hide keyboard
		[lastTextFieldEdited resignFirstResponder];

		// hide client info view
		[self.navigationController pushViewController:contactInfoViewController animated:YES];
	}
}

- (IBAction)cancel:(id)sender {
	// discard new estimate
	[[DataStore defaultStore] deleteEstimateStub];

	// release estimate
	self.estimate = nil;

	// hide client info view
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)requiredFieldsProvided:(UITextField *)textField {
	return (textField.tag != ClientInfoFieldName || [ClientInformation isNameValid:textField.text]);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	// TODO hide overlay view if any
	// save textfield value into estimate
	if (textField.tag == ClientInfoFieldName) {
		estimate.clientInfo.name = textField.text;
	}
	else if (textField.tag == ClientInfoFieldAddress1) {
		estimate.clientInfo.address1 = textField.text;
	}
	else if (textField.tag == ClientInfoFieldAddress2) {
		estimate.clientInfo.address2 = textField.text;
	}
	else if (textField.tag == ClientInfoFieldCity) {
		estimate.clientInfo.city = textField.text;
	}
	else if (textField.tag == ClientInfoFieldState) {
		estimate.clientInfo.state = textField.text;
	}
	else if (textField.tag == ClientInfoFieldPostalCode) {
		estimate.clientInfo.postalCode = textField.text;
	}
	else if (textField.tag == ClientInfoFieldCountry) {
		estimate.clientInfo.country = textField.text;
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
	NSLog(@"AddEstimateClientInfoViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.contactInfoViewController = nil;
	self.nextButton = nil;
	self.estimate = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
	[super viewDidUnload];
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateClientInfoViewController.dealloc");
#endif
	[estimate release];
	[nextButton release];
	[contactInfoViewController release];
    [super dealloc];
}


@end

