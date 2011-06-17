//
//  AddEstimateViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateNewClientInfoViewController.h"
// API
#import "Estimate.h"
#import "ClientInformation.h"
#import "Datastore.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "AddEstimateContactInfoViewController.h"
#import "TableFields.h"


@implementation AddEstimateNewClientInfoViewController

@synthesize nextButton;
@synthesize contactInfoViewController;
@synthesize estimate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateNewClientInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"New Client", "AddEstimateNewClientInfo Navigation Item Title");
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.navigationItem.rightBarButtonItem = nextButton;

	self.estimate = [[DataStore defaultStore] estimateStub];

	// if existing client info set, deassociate it
	if ([estimate.clientInfo.status integerValue] == StatusActive) {
		[estimate.clientInfo removeEstimatesObject:estimate];

		estimate.clientInfo = nil;
	}

	// initialize new client information if needed
	if (estimate.clientInfo == nil) {
		ClientInformation *clientInfo = [[DataStore defaultStore] createClientInformation];
		estimate.clientInfo = clientInfo;

		NSMutableSet *estimates = [clientInfo mutableSetValueForKey:@"estimates"];
		[estimates addObject:estimate];
	}

	// reload table data to match estimate object
	[self.tableView reloadData];
}

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

	cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
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

		[self.navigationController pushViewController:contactInfoViewController animated:YES];
	}
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
	NSLog(@"AddEstimateNewClientInfoViewController.viewDidUnload");
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
	NSLog(@"AddEstimateNewClientInfoViewController.dealloc");
#endif
	[estimate release];
	[nextButton release];
	[contactInfoViewController release];
    [super dealloc];
}


@end

