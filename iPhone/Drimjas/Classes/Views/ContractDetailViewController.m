//
//  ContractDetailViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-24.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "ContractDetailViewController.h"
// API
#import "ClientInfo.h"
#import "ContactInfo.h"
#import "Contract.h"
#import "Currency.h"
#import "DataStore.h"
#import "Estimate.h"
#import "KeyValue.h"
#import "LineItem.h"
#import "LineItemSelection.h"
#import "MyInfo.h"
// Utils
#import "EmailManager.h"
#import "PDFManager.h"
#import "PrintManager.h"
// Views
#import "PDFViewController.h"
#import "TableFields.h"


@implementation ContractDetailViewController


#pragma mark -
#pragma mark Private methods stack

- (void)reloadIndexes {
	indexFirstLineItem = ContractDetailSectionContactInfo + contract.estimate.clientInfo.contactInfos.count;
	indexLastSection = indexFirstLineItem +contract.estimate.lineItems.count;

	// TODO move this into Estimate, cached in a local transient array refreshed when (un)binding Line Item Selections
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	lineItemSelections = [contract.estimate.lineItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}


#pragma mark -
#pragma mark Properties stack

@synthesize contract;

- (void)setContract:(Contract *)newContract {

	contract = newContract;
	if (contract) {
		[self reloadIndexes];
	}
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ContractDetailViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Contract Detail", "ContractDetail Navigation Item Title");

	// note: navigation controller not set yet
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	// let user email & print only when estimate & global settings are ready
	emailButton.enabled = contract.isReady && [DataStore areGlobalsReadyForContract];
	printButton.enabled = emailButton.enabled;

	[self reloadIndexes];
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// allow all orientations
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ContractDetailSectionContactInfo
			+ contract.estimate.clientInfo.contactInfos.count
			+ contract.estimate.lineItems.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case ContractDetailSectionClientInfo:
			return NSLocalizedString(@"Client Information", "Contract Detail Client Info section title");
		case ContractDetailSectionContactInfo:
			return NSLocalizedString(@"Contact Information", "Contract Detail Contact Info section title");
		default:
			if (section == indexFirstLineItem) {
				return NSLocalizedString(@"Line Items", "Contract Detail Line Item section title");
			}
			return nil;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == ContractDetailSectionOrderNumber) {
		// order number
		return 1;
	}
	else if (section == ContractDetailSectionClientInfo) {
		return [contract.estimate.clientInfo countNonEmptyProperties];
	}
	else if (section >= ContractDetailSectionContactInfo && section < indexFirstLineItem) {
		ContactInfo *contactInfo = [contract.estimate.clientInfo contactInfoAtIndex:section - ContractDetailSectionContactInfo];

		return [contactInfo countNonEmptyProperties];
	}
	else {
		LineItemSelection *lineItem = (LineItemSelection *)[lineItemSelections objectAtIndex:(section - indexFirstLineItem)];

		// collapse Quantity & Unit Cost rows together, and skip Description row if empty
		return numLineItemSelectionField - (lineItem.desc.length > 0 ? 1 : 2);
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }

	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	if (indexPath.section == ContractDetailSectionOrderNumber) {
		cell.textLabel.text = NSLocalizedString(@"Order #", "Estimate Detail Order Number section title");
        cell.detailTextLabel.text = [contract.estimate orderNumber];
	}
	else if (indexPath.section == ContractDetailSectionClientInfo) {
        KeyValue *keyVal = [[contract.estimate.clientInfo nonEmptyProperties] objectAtIndex:indexPath.row];

        cell.textLabel.text = NSLocalizedString(keyVal.key, "Name of ClientInfo property");
        cell.detailTextLabel.text = keyVal.value;
	}
	else if (indexPath.section >= ContractDetailSectionContactInfo && indexPath.section < indexFirstLineItem) {
		ContactInfo *contactInfo = [contract.estimate.clientInfo contactInfoAtIndex:indexPath.section - ContractDetailSectionContactInfo];

        KeyValue *keyVal = [[contactInfo nonEmptyProperties] objectAtIndex:indexPath.row];

        cell.textLabel.text = NSLocalizedString(keyVal.key, "Name of ClientInfo property");
        cell.detailTextLabel.text = keyVal.value;
	}
	else if (indexPath.section >= indexFirstLineItem && indexPath.section < indexLastSection) {
		LineItemSelection *lineItem = (LineItemSelection *)[lineItemSelections objectAtIndex:(indexPath.section - indexFirstLineItem)];

		if (indexPath.row == LineItemSelectionFieldName) {
			cell.textLabel.text = NSLocalizedString(@"Name", "Estimate Detail Line item name");
            cell.detailTextLabel.text = lineItem.lineItem.name;
 		}
		else if (indexPath.row == LineItemSelectionFieldDescription && lineItem.desc.length > 0) {
			cell.textLabel.text = NSLocalizedString(@"Description", "Estimate Detail Line item description");
            cell.detailTextLabel.text = lineItem.desc;
		}
		else if (indexPath.row == LineItemSelectionFieldQuantity
				 || (indexPath.row == LineItemSelectionFieldDescription && lineItem.desc.length == 0)) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

			[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			NSString *quantity = [numberFormatter stringFromNumber:lineItem.nonNilQuantity];

			[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			[numberFormatter setCurrencyCode:[[[DataStore defaultStore] currency] isoCode]];
			NSString *unitCost = [numberFormatter stringFromNumber:lineItem.nonNilUnitCost];

			cell.textLabel.text = NSLocalizedString(@"Cost", "Estimate Detail Line item quantity & unit cost");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x %@", quantity, unitCost];
		}
	}

    return cell;
}


#pragma mark -
#pragma mark Button delegate

- (IBAction)email:(id)sender {
    self.mailComposeViewController = [EmailManager mailComposeViewControllerWithDelegate:self forContract:contract];
    
    [self.navigationController presentModalViewController:mailComposeViewController animated:YES];
}

- (IBAction)print:(id)sender {
	[PrintManager printContract:contract withDelegate:self];
}

- (IBAction)view:(id)sender {
    self.pdfViewController.pdfData = [PDFManager pdfDataForContract:self.contract];
    [self.navigationController pushViewController:self.pdfViewController animated:YES];
}

#pragma mark -
#pragma mark Mail compose delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error {
	// hide mail compose view
	[self.navigationController dismissModalViewControllerAnimated:YES];

    if (result == MFMailComposeResultFailed) {
		// TODO handle error
		NSLog(@"ContractDetailViewController.mailComposeController:didFinishWithResult:error failed to email contract %@ with error %@, %@", contract.estimate.clientInfo.name, error, [error userInfo]);
	}

    self.mailComposeViewController = nil;
}


#pragma mark -
#pragma mark Print completed delegate

- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error {
	if (error) {
		NSLog(@"ContractDetailViewController.printJobCompleted: failed to print contract %@ with error %@, %@", contract.estimate.clientInfo.name, error, [error userInfo]);
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
	NSLog(@"ContractDetailViewController.viewDidUnload");
#endif
    [super viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.contract = nil;
	lineItemSelections = nil;
}




@end

