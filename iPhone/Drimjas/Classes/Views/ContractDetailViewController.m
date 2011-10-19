//
//  ContractDetailViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-24.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "ContractDetailViewController.h"
// API
#import "ClientInfo.h"
#import "ContactInfo.h"
#import "Contract.h"
#import "Currency.h"
#import "DataStore.h"
#import "Estimate.h"
#import "LineItem.h"
#import "LineItemSelection.h"
#import "MyInfo.h"
// Utils
#import "EmailManager.h"
#import "PrintManager.h"
// Views
#import "TableFields.h"

@implementation ContractDetailViewController


#pragma mark -
#pragma mark Private methods stack

- (void)reloadIndexes {
	indexFirstLineItem = ContractDetailSectionContactInfo + contract.estimate.clientInfo.contactInfos.count;
	indexLastSection = indexFirstLineItem +contract.estimate.lineItems.count;

	// TODO move this into Estimate, cached in a local transient array refreshed when (un)binding Line Item Selections
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	[lineItemSelections release];
	lineItemSelections = [[contract.estimate.lineItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] retain];
	[sortDescriptor release];
}


#pragma mark -
#pragma mark Properties stack

@synthesize emailButton;
@synthesize printButton;
@synthesize spacerButton;
@synthesize contract;

- (void)setContract:(Contract *)newContract {
	[contract release];

	contract = [newContract retain];
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

	NSMutableArray *items = [NSMutableArray arrayWithObject: spacerButton];
	if ([EmailManager isMailAvailable]) {
		// add Email button only if mail is available on iPhone
		[items addObject:emailButton];
	}
	if ([PrintManager isPrintingAvailable]) {
		// add Print button only if printing is available on iPhone
		[items addObject:printButton];
	}
	[items addObject:spacerButton];
	self.toolbarItems = items;

	// note: navigation controller not set yet
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	// show toolbar with animation
	[self.navigationController setToolbarHidden:NO animated:YES];

	// let user email & print only when estimate & global settings are ready
	emailButton.enabled = contract.isReady && [Currency isReadyStatus] && [MyInfo isReadyForContract];
	printButton.enabled = emailButton.enabled;

	[self reloadIndexes];
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	// hide toolbar with animation
	[self.navigationController setToolbarHidden:YES animated:YES];
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
		case ContractDetailSectionOrderNumber:
			return NSLocalizedString(@"Purchase Order Number", "Contract Detail Order Number section title");
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	if (indexPath.section == ContractDetailSectionOrderNumber) {
		cell.textLabel.text = [contract.estimate orderNumber];
	}
	else if (indexPath.section == ContractDetailSectionClientInfo) {
		cell.textLabel.text = [contract.estimate.clientInfo nonEmptyPropertyWithIndex:indexPath.row];
	}
	else if (indexPath.section >= ContractDetailSectionContactInfo && indexPath.section < indexFirstLineItem) {
		ContactInfo *contactInfo = [contract.estimate.clientInfo contactInfoAtIndex:indexPath.section - ContractDetailSectionContactInfo];

		cell.textLabel.text = [contactInfo nonEmptyPropertyWithIndex:indexPath.row];
	}
	else if (indexPath.section >= indexFirstLineItem && indexPath.section < indexLastSection) {
		LineItemSelection *lineItem = (LineItemSelection *)[lineItemSelections objectAtIndex:(indexPath.section - indexFirstLineItem)];

		if (indexPath.row == LineItemSelectionFieldName) {
			cell.textLabel.text = lineItem.lineItem.name;
		}
		else if (indexPath.row == LineItemSelectionFieldDescription && lineItem.desc.length > 0) {
			cell.textLabel.text = lineItem.desc;
		}
		else if (indexPath.row == LineItemSelectionFieldQuantity
				 || (indexPath.row == LineItemSelectionFieldDescription && lineItem.desc.length == 0)) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

			[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			NSString *quantity = [numberFormatter stringFromNumber:lineItem.nonNilQuantity];

			[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			[numberFormatter setCurrencyCode:[[[DataStore defaultStore] currency] isoCode]];
			NSString *unitCost = [numberFormatter stringFromNumber:lineItem.nonNilUnitCost];

			cell.textLabel.text = [NSString stringWithFormat:@"%@ x %@", quantity, unitCost];
			[numberFormatter release];
		}
	}

    return cell;
}


#pragma mark -
#pragma mark Button delegate

- (IBAction)email:(id)sender {
	[EmailManager mailContract:contract withDelegate:self];
}

- (IBAction)print:(id)sender {
	[PrintManager printContract:contract withDelegate:self];
}


#pragma mark -
#pragma mark Print completed delegate

- (void)mailSent:(MFMailComposeResult)result withError:(NSError *)error {
	if (result == MFMailComposeResultFailed) {
		NSLog(@"Contract∫DetailViewController.mailSent: failed to email contract %@ with error %@, %@", contract.estimate.clientInfo.name, error, [error userInfo]);
	}
}

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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.emailButton = nil;
	self.printButton = nil;
	self.spacerButton = nil;
	self.contract = nil;
	[lineItemSelections release];
	lineItemSelections = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ContractDetailViewController.dealloc");
#endif
	[emailButton release];
	[printButton release];
	[spacerButton release];
	[contract release];
	[lineItemSelections release];
    [super dealloc];
}


@end

