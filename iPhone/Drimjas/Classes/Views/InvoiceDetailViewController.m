//
//  InvoiceDetailViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-05.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "InvoiceDetailViewController.h"
// API
#import "ClientInfo.h"
#import "ContactInfo.h"
#import "Contract.h"
#import "Currency.h"
#import "DataStore.h"
#import "Estimate.h"
#import "Invoice.h"
#import "KeyValue.h"
#import "LineItem.h"
#import "LineItemSelection.h"
// Utils
#import "EmailManager.h"
#import "PDFManager.h"
// Views
#import "TableFields.h"
#import "PDFViewController.h"

@interface InvoiceDetailViewController ()

- (void)reloadIndexes;

@end;


@implementation InvoiceDetailViewController

@synthesize invoice;

- (void)setInvoice:(Invoice *)newInvoice
{
	invoice = newInvoice;
	if (invoice) {
		[self reloadIndexes];
	}
}

- (void)reloadIndexes
{
	indexFirstLineItem = EstimateDetailSectionContactInfo + invoice.contract.estimate.clientInfo.contactInfos.count;
	indexLastSection = indexFirstLineItem + MAX(1, invoice.lineItems.count);

	// TODO move this into Invoice, cached in a local transient array refreshed when (un)binding Line Item Selections
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	lineItemSelections = [invoice.lineItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"InvoiceDetailViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Invoice Detail", "InvoiceDetail Navigation Item Title");

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"InvoiceDetailViewController.viewDidUnload");
#endif
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.invoice = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// show toolbar with animation
	[self.navigationController setToolbarHidden:NO animated:YES];

    [self reloadIndexes];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	// hide toolbar with animation
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return InvoiceDetailSectionContactInfo + invoice.contract.estimate.clientInfo.contactInfos.count
            // even if there isn't a LineItemSelection object, add an empty section to show Modify button
            + MAX(1, invoice.lineItems.count);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == InvoiceDetailSectionOrderNumber) {
		// order number
		return 1;
	}
	else if (section == InvoiceDetailSectionClientInfo) {
		return [invoice.contract.estimate.clientInfo countNonEmptyProperties];
	}
	else if (section >= InvoiceDetailSectionContactInfo && section < indexFirstLineItem) {
        ContactInfo *contactInfo = [invoice.contract.estimate.clientInfo contactInfoAtIndex:(section - InvoiceDetailSectionContactInfo)];

        return [contactInfo countNonEmptyProperties];
	}
	else {
		if (invoice.lineItems.count == 0) {
			// empty section to show Modify button
			return 0;
		}
		else {
			LineItemSelection *lineItem = (LineItemSelection *)[lineItemSelections objectAtIndex:(section - indexFirstLineItem)];

			// collapse Quantity & Unit Cost rows together, and skip Description row if empty
			return numLineItemSelectionField - (lineItem.desc.length > 0 ? 1 : 2);
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

	if (indexPath.section == InvoiceDetailSectionOrderNumber) {
        cell.textLabel.text = NSLocalizedString(@"Order #", "Invoice Detail Order Number section title");
		cell.detailTextLabel.text = [invoice.contract.estimate orderNumber];
	}
	else if (indexPath.section == InvoiceDetailSectionClientInfo) {
        KeyValue *keyVal = [[invoice.contract.estimate.clientInfo nonEmptyProperties] objectAtIndex:indexPath.row];

		cell.textLabel.text = NSLocalizedString(keyVal.key, "Name of ClientInfo property");
        cell.detailTextLabel.text = keyVal.value;
	}
	else if (indexPath.section >= InvoiceDetailSectionContactInfo && indexPath.section < indexFirstLineItem) {
		ContactInfo *contactInfo = [invoice.contract.estimate.clientInfo contactInfoAtIndex:(indexPath.section - InvoiceDetailSectionContactInfo)];

        KeyValue *keyVal = [[contactInfo nonEmptyProperties] objectAtIndex:indexPath.row];

		cell.textLabel.text = NSLocalizedString(keyVal.key, "Name of ClientInfo property");
        cell.detailTextLabel.text = keyVal.value;
	}
	else if (indexPath.section >= indexFirstLineItem && indexPath.section < indexLastSection) {
		LineItemSelection *lineItem = (LineItemSelection *)[lineItemSelections objectAtIndex:(indexPath.section - indexFirstLineItem)];

		if (indexPath.row == LineItemSelectionFieldName) {
            cell.textLabel.text = NSLocalizedString(@"Name", "Invoice Detail Line item name");
			cell.detailTextLabel.text = lineItem.lineItem.name;
		}
		else if (indexPath.row == LineItemSelectionFieldDescription && lineItem.desc.length > 0) {
            cell.textLabel.text = NSLocalizedString(@"Description", "Invoice Detail Line item description");
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

            cell.textLabel.text = NSLocalizedString(@"Cost", "Invoice Detail Line item quantity & unit cost");
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x %@", quantity, unitCost];
		}
	}

    return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case InvoiceDetailSectionClientInfo:
			return NSLocalizedString(@"Client Information", "Invoice Detail Client Info section title");
		case InvoiceDetailSectionContactInfo:
			return NSLocalizedString(@"Contact Information", "Invoice Detail Contact Info section title");
		default:
			return nil;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == indexFirstLineItem) {
        return [self configureViewForHeaderInSection:section withTitle:@"Line Items"];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == indexFirstLineItem) {
        return 36;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - Button delegate

- (IBAction)email:(id)sender {
    self.mailComposeViewController = [EmailManager mailComposeViewControllerWithDelegate:self forInvoice:self.invoice];
    
    [self.navigationController presentModalViewController:mailComposeViewController animated:YES];
}

- (IBAction)print:(id)sender {
	[PrintManager printInvoice:self.invoice withDelegate:self];
}

- (IBAction)view:(id)sender {
    self.pdfViewController.pdfData = [PDFManager pdfDataForInvoice:self.invoice];
    [self.navigationController pushViewController:pdfViewController animated:YES];
}

- (IBAction)modify:(id)sender
{
	UIButton *edit = (UIButton *)sender;
    NSLog(@"Clicked edit button #%u", edit.tag);
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
		NSLog(@"InvoiceDetailViewController.mailComposeController:didFinishWithResult:error failed to email invoice %@ with error %@, %@", invoice.contract.estimate.clientInfo.name, error, [error userInfo]);
	}
    
    self.mailComposeViewController = nil;
}

#pragma mark -
#pragma mark Print completed delegate

- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error {
	if (error) {
		NSLog(@"InvoiceDetailViewController.printJobCompleted: failed to print invoice %@ with error %@, %@", invoice.contract.estimate.clientInfo.name, error, [error userInfo]);
	}
}


@end
