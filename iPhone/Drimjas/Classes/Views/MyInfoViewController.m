//
//  MyInfoViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-26.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "MyInfoViewController.h"
// API
#import "ContactInfo.h"
#import "DataStore.h"
#import "MyInfo.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "EstimateDetailViewController.h"
#import "ProfessionsViewController.h"
#import "TableFields.h"


@implementation MyInfoViewController


@synthesize saveButton;
@synthesize estimateDetailViewController;
@synthesize professionsViewController;
@synthesize myInfo;
@synthesize optionsMode;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	// refresh table in case user is viewing MyInfo screen from 1st Estimate creation & Options menu screens at the same time
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return !optionsMode && section == MyInfoSectionProfession
		? NSLocalizedString(@"This can later be changed from the Options tab", "MyInfoViewController Table Header")
		: nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numMyInfoSection;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == MyInfoSectionProfession ? 1 : numMyInfoField;
}


#pragma mark -
#pragma mark Table view delegate

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
	[super configureCell:aCell atIndexPath:indexPath];

    if (indexPath.section == MyInfoSectionProfession) {
        if (myInfo.profession) {
            aCell.textLabel.text = NSLocalizedString(myInfo.profession, "Localized Profession");
            aCell.textLabel.textColor = [UIColor blackColor];
        }
        else {
            aCell.textLabel.text = NSLocalizedString(@"Profession", "Profession Placeholder");
            aCell.textLabel.textColor = [UIColor lightGrayColor];
        }
        aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        TextFieldCell *tfCell = (TextFieldCell *)aCell;

        // don't bother keeping track of sections since there is only one
        tfCell.textField.tag = indexPath.row;

        // initialize textfield value from estimate
        if (indexPath.row == MyInfoFieldName) {
            tfCell.textField.placeholder = NSLocalizedString(@"My Company Name", "My Company Name Text Field Placeholder");
            tfCell.textField.text = myInfo.name;
            tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
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
            tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        }
        else if (indexPath.row == MyInfoFieldCountry) {
            tfCell.textField.placeholder = NSLocalizedString(@"Country", "Country Text Field Placeholder");
            tfCell.textField.text = myInfo.country;
        }
        else if (indexPath.row == MyInfoFieldPhone) {
            tfCell.textField.placeholder = NSLocalizedString(@"Phone", "Phone Text Field Placeholder");
            tfCell.textField.text = myInfo.contactInfo.phone;
            tfCell.textField.keyboardType = UIKeyboardTypePhonePad;
            tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        else if (indexPath.row == MyInfoFieldFax) {
            tfCell.textField.placeholder = NSLocalizedString(@"Fax", "Fax Text Field Placeholder");
            tfCell.textField.text = myInfo.fax;
            tfCell.textField.keyboardType = UIKeyboardTypePhonePad;
            tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        else if (indexPath.row == MyInfoFieldEmail) {
            tfCell.textField.placeholder = NSLocalizedString(@"Email", "Email Text Field Placeholder");
            tfCell.textField.text = myInfo.contactInfo.email;
            tfCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        else if (indexPath.row == MyInfoFieldWebsite) {
            tfCell.textField.placeholder = NSLocalizedString(@"Website", "Website Text Field Placeholder");
            tfCell.textField.text = myInfo.website;
            tfCell.textField.keyboardType = UIKeyboardTypeURL;
            tfCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == MyInfoSectionProfession) {

		static NSString *CellIdentifier = @"Cell";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}

		[self configureCell:cell atIndexPath:indexPath];

		return cell;
	}
	else {
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.professionsViewController.myInfo = self.myInfo;
    [self.navigationController pushViewController:self.professionsViewController animated:YES];
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
	NSLog(@"MyInfoViewController.viewDidUnload");
#endif
    [super viewDidUnload];
	self.saveButton = nil;
	self.estimateDetailViewController = nil;
    self.professionsViewController = nil;
	self.myInfo = nil;
}




@end

