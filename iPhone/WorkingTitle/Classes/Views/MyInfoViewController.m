//
//  MyInfoViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyInfoViewController.h"
// API
#import "ContactInformation.h"
#import "DataStore.h"
#import "MyInfo.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "ReviewEstimateViewController.h"
#import "TableFields.h"


@implementation MyInfoViewController


@synthesize saveButton;
@synthesize reviewEstimateViewController;
@synthesize myInfo;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"MyInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"My Information", "MyInfoViewController Navigation Item Title");

	self.navigationItem.rightBarButtonItem = saveButton;

	self.myInfo = [[DataStore defaultStore] myInfo];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
    return numMyInfoField;
}


#pragma mark -
#pragma mark Table view delegate

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
	[super configureCell:aCell atIndexPath:indexPath];

	TextFieldCell *tfCell = (TextFieldCell *)aCell;

	// don't bother keeping track of sections since there is only one
	tfCell.textField.tag = indexPath.row;

	// initialize textfield value from estimate
	if (indexPath.row == MyInfoFieldName) {
		tfCell.textField.placeholder = NSLocalizedString(@"My Company Name", "My Company Name Text Field Placeholder");
		tfCell.textField.text = myInfo.name;
	}
	else if (indexPath.row == MyInfoFieldAddress1) {
		tfCell.textField.placeholder = NSLocalizedString(@"Address 1", "Address 1 Text Field Placeholder");
		tfCell.textField.text = myInfo.address1;
	}
	else if (indexPath.row == MyInfoFieldAddress2) {
		tfCell.textField.placeholder = NSLocalizedString(@"Address 2", "Address 2 Text Field Placeholder");
		tfCell.textField.text = myInfo.address2;
	}
	else if (indexPath.row == MyInfoFieldCity) {
		tfCell.textField.placeholder = NSLocalizedString(@"City", "City Text Field Placeholder");
		tfCell.textField.text = myInfo.city;
	}
	else if (indexPath.row == MyInfoFieldState) {
		tfCell.textField.placeholder = NSLocalizedString(@"State", "State Text Field Placeholder");
		tfCell.textField.text = myInfo.state;
	}
	else if (indexPath.row == MyInfoFieldPostalCode) {
		tfCell.textField.placeholder = NSLocalizedString(@"Postal Code", "Postal Code Text Field Placeholder");
		tfCell.textField.text = myInfo.postalCode;
	}
	else if (indexPath.row == MyInfoFieldCountry) {
		tfCell.textField.placeholder = NSLocalizedString(@"Country", "Country Text Field Placeholder");
		tfCell.textField.text = myInfo.country;
	}
	else if (indexPath.row == MyInfoFieldBusinessNumber) {
		tfCell.textField.placeholder = NSLocalizedString(@"Business Number", "Business Number Field Placeholder");
		tfCell.textField.text = myInfo.businessNumber;
	}
	else if (indexPath.row == MyInfoFieldPhone) {
		tfCell.textField.placeholder = NSLocalizedString(@"Phone", "Phone Text Field Placeholder");
		tfCell.textField.text = myInfo.contactInfo.phone;
		tfCell.textField.keyboardType = UIKeyboardTypePhonePad;
	}
	else if (indexPath.row == MyInfoFieldFax) {
		tfCell.textField.placeholder = NSLocalizedString(@"Fax", "Fax Text Field Placeholder");
		tfCell.textField.text = myInfo.fax;
		tfCell.textField.keyboardType = UIKeyboardTypePhonePad;
	}
	else if (indexPath.row == MyInfoFieldEmail) {
		tfCell.textField.placeholder = NSLocalizedString(@"Email", "Email Text Field Placeholder");
		tfCell.textField.text = myInfo.contactInfo.email;
		tfCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
		tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		tfCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	}
	else if (indexPath.row == MyInfoFieldWebsite) {
		tfCell.textField.placeholder = NSLocalizedString(@"Website", "Website Text Field Placeholder");
		tfCell.textField.text = myInfo.website;
		tfCell.textField.keyboardType = UIKeyboardTypeURL;
		tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	}
}

#pragma mark -
#pragma mark TextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	// TODO hide overlay view if any
	// save textfield value into estimate
	if (textField.tag == MyInfoFieldName) {
		myInfo.name = textField.text;
	}
	else if (textField.tag == MyInfoFieldAddress1) {
		myInfo.address1 = textField.text;
	}
	else if (textField.tag == MyInfoFieldAddress2) {
		myInfo.address2 = textField.text;
	}
	else if (textField.tag == MyInfoFieldCity) {
		myInfo.city = textField.text;
	}
	else if (textField.tag == MyInfoFieldState) {
		myInfo.state = textField.text;
	}
	else if (textField.tag == MyInfoFieldPostalCode) {
		myInfo.postalCode = textField.text;
	}
	else if (textField.tag == MyInfoFieldCountry) {
		myInfo.country = textField.text;
	}
	else if (textField.tag == MyInfoFieldBusinessNumber) {
		myInfo.businessNumber = textField.text;
	}
	else if (textField.tag == MyInfoFieldPhone) {
		myInfo.contactInfo.phone = textField.text;
	}
	else if (textField.tag == MyInfoFieldFax) {
		myInfo.fax = textField.text;
	}
	else if (textField.tag == MyInfoFieldEmail) {
		myInfo.contactInfo.email = textField.text;
	}
	else if (textField.tag == MyInfoFieldWebsite) {
		myInfo.website = textField.text;
	}
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)save:(id)sender {
	[[DataStore defaultStore] saveMyInfo];

	// save estimate into estimates list
	reviewEstimateViewController.estimate = [[DataStore defaultStore] saveEstimateStub];

	// reset navigation controller to review estimate view controller
	UIViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
	[self.navigationController setViewControllers:[NSArray arrayWithObjects:rootController,
												   reviewEstimateViewController,
												   nil]
										 animated:YES];
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
	NSLog(@"MyInfoViewController.viewDidUnload");
#endif

	self.saveButton = nil;
	self.reviewEstimateViewController = nil;
	self.myInfo = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"MyInfoViewController.dealloc");
#endif
	[saveButton release];
	[reviewEstimateViewController release];
	[myInfo release];
    [super dealloc];
}


@end

