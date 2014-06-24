//
//  AddEstimateViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import "NewClientInfoViewController.h"
// API
#import "Estimate.h"
#import "ClientInfo.h"
#import "Datastore.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "ContactInfosViewController.h"
#import "TableFields.h"


@implementation NewClientInfoViewController

@synthesize nextButton;
@synthesize saveButton;
@synthesize contactInfosViewController;
@synthesize estimate;
@synthesize editMode;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"NewClientInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	if (editMode) {
		self.title = NSLocalizedString(@"Edit Client", "NewClientInfo Navigation Item Title (Edit)");
	} else {
		self.title = NSLocalizedString(@"New Client", "NewClientInfo Navigation Item Title");
	}
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.navigationItem.rightBarButtonItem = editMode ? saveButton : nextButton;

	if (!editMode) {
		self.estimate = [[DataStore defaultStore] estimateStub];

		// if existing client info set, deassociate it
		if (![estimate.clientInfo shouldBeDeleted]) {
			[estimate.clientInfo removeEstimatesObject:estimate];

			estimate.clientInfo = nil;
		}
	}

	// initialize new client information if needed
	if (estimate.clientInfo == nil) {
		ClientInfo *clientInfo = [[DataStore defaultStore] createClientInfo];
		estimate.clientInfo = clientInfo;
		[clientInfo addEstimatesObject:estimate];
	}

	// reload table data to match estimate object
	[self.tableView reloadData];
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


#pragma mark -
#pragma mark Table view delegate

- (void)configureCell:(TextFieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	[super configureCell:cell atIndexPath:indexPath];

	// initialize textfield value from estimate
	if (indexPath.row == ClientInfoFieldName) {
		cell.textField.placeholder = NSLocalizedString(@"Client Name", "Client Name Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.name;
		cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
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
		cell.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
	}
	else if (indexPath.row == ClientInfoFieldCountry) {
		cell.textField.placeholder = NSLocalizedString(@"Country", "Country Text Field Placeholder");
		cell.textField.text = estimate.clientInfo.country;
	}
}

#pragma mark -
#pragma mark Button & Textfield delegate

- (IBAction)next:(id)sender {
	contactInfosViewController.editMode = NO;
	[self.navigationController pushViewController:contactInfosViewController animated:YES];
}

- (IBAction)save:(id)sender {
	[self.lastTextFieldEdited resignFirstResponder];

	[[DataStore defaultStore] saveClientInfo:estimate.clientInfo];

	[self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSUInteger section = textField.tag / 10;
	NSUInteger row = textField.tag - (10 * section);

	// TODO hide overlay view if any
	// save textfield value into estimate
	if (row == ClientInfoFieldName) {
		estimate.clientInfo.name = textField.text;
	}
	else if (row == ClientInfoFieldAddress1) {
		estimate.clientInfo.address1 = textField.text;
	}
	else if (row == ClientInfoFieldAddress2) {
		estimate.clientInfo.address2 = textField.text;
	}
	else if (row == ClientInfoFieldCity) {
		estimate.clientInfo.city = textField.text;
	}
	else if (row == ClientInfoFieldState) {
		estimate.clientInfo.state = textField.text;
	}
	else if (row == ClientInfoFieldPostalCode) {
		estimate.clientInfo.postalCode = textField.text;
	}
	else if (row == ClientInfoFieldCountry) {
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
	NSLog(@"NewClientInfoViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.nextButton = nil;
	self.saveButton = nil;
	self.contactInfosViewController = nil;
	self.estimate = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
	[super viewDidUnload];
}




@end

