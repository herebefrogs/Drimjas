//
//  EstimateDetailViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-17.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "EstimateDetailViewController.h"
// API
#import "ClientInfo.h"
#import "ContactInfo.h"
#import "Currency.h"
#import "DataStore.h"
#import "Estimate.h"
#import "LineItem.h"
#import "LineItemSelection.h"
#import "MyInfo.h"
// Utils
#import "EmailManager.h"
#import "PDFManager.h"
// Cells
#import "EditSectionHeader.h"
// Views
#import "AddEstimateLineItemsViewController.h"
#import "ContactInfosViewController.h"
#import "NewClientInfoViewController.h"
#import "PDFViewController.h"
#import "TableFields.h"


@interface EstimateDetailViewController ()

@property (nonatomic, strong) UIViewController *mailComposeViewController;

@end


@implementation EstimateDetailViewController

#pragma mark -
#pragma mark Private methods stack

- (void)reloadIndexes {
	indexFirstLineItem = EstimateDetailSectionContactInfo + MAX(1, estimate.clientInfo.contactInfos.count);
	indexLastSection = indexFirstLineItem + MAX(1, estimate.lineItems.count);

	// TODO move this into Estimate, cached in a local transient array refreshed when (un)binding Line Item Selections
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	lineItemSelections = [estimate.lineItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}


#pragma mark -
#pragma mark Properties stack

@synthesize emailButton;
@synthesize printButton;
@synthesize pdfButton;
@synthesize spacerButton;
@synthesize editSectionHeader;
@synthesize lineItemSelectionsViewController;
@synthesize contactInfosViewController;
@synthesize aNewClientInfoViewController;
@synthesize pdfViewController;
@synthesize estimate;
@synthesize mailComposeViewController;

- (void)setEstimate:(Estimate *)newEstimate {

	estimate = newEstimate;
	if (estimate) {
		[self reloadIndexes];
	}
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimateDetailViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Estimate Detail", "EstimateDetail Navigation Item Title");

	NSMutableArray *items = [NSMutableArray arrayWithObjects: spacerButton, pdfButton, nil];
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
	emailButton.enabled = estimate.isReady && [DataStore areGlobalsReadyForEstimate];
	printButton.enabled = emailButton.enabled;

	[self reloadIndexes];
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	// hide toolbar with animation
	[self.navigationController setToolbarHidden:YES animated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return EstimateDetailSectionContactInfo
			// even if there isn't a ContactInfo object, add an empty section to show Modify button
			+ MAX(1, estimate.clientInfo.contactInfos.count)
			// even if there isn't a LineItemSelection object, add an empty section to show Modify button
			+ MAX(1, estimate.lineItems.count);
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case EstimateDetailSectionOrderNumber:
			return NSLocalizedString(@"Purchase Order Number", "Estimate Detail Order Number section title");
		default:
			return nil;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == EstimateDetailSectionOrderNumber) {
		// order number
		return 1;
	}
	else if (section == EstimateDetailSectionClientInfo) {
		return [estimate.clientInfo countNonEmptyProperties];
	}
	else if (section >= EstimateDetailSectionContactInfo && section < indexFirstLineItem) {
		if (estimate.clientInfo.contactInfos.count == 0) {
			// empty section to show Modify button
			return 0;
		}
		else {
			ContactInfo *contactInfo = [estimate.clientInfo contactInfoAtIndex:section - EstimateDetailSectionContactInfo];

			return [contactInfo countNonEmptyProperties];
		}
	}
	else {
		if (estimate.lineItems.count == 0) {
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


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	if (indexPath.section == EstimateDetailSectionOrderNumber) {
		cell.textLabel.text = [estimate orderNumber];
	}
	else if (indexPath.section == EstimateDetailSectionClientInfo) {
		cell.textLabel.text = [estimate.clientInfo nonEmptyPropertyWithIndex:indexPath.row];
	}
	else if (indexPath.section >= EstimateDetailSectionContactInfo && indexPath.section < indexFirstLineItem) {
		ContactInfo *contactInfo = [estimate.clientInfo contactInfoAtIndex:indexPath.section - EstimateDetailSectionContactInfo];

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
		}
	}

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (UIView *)loadEditSectionHeaderForTag:(NSInteger)tag withTitle:(NSString *)title {
	EditSectionHeader *editHeader = nil;

	if (editSectionHeader == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"EditSectionHeader" owner:self options:nil];
		editHeader = editSectionHeader;
		self.editSectionHeader = nil;
	}

	editHeader.header.text = NSLocalizedString(title, "");
	[editHeader.edit setTitle:NSLocalizedString(@"Edit", "") forState:UIControlStateNormal];
	editHeader.edit.tag = tag;

	// round up the button's corners
	CALayer *layer = editHeader.edit.layer;
    layer.cornerRadius = 6.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;

	return editHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	switch (section) {
		case EstimateDetailSectionClientInfo:
			return [self loadEditSectionHeaderForTag:EstimateDetailSectionClientInfo withTitle:@"Client Information"];
			break;
		case EstimateDetailSectionContactInfo:
			return [self loadEditSectionHeaderForTag:EstimateDetailSectionContactInfo withTitle:@"Contact Information"];
		default:
			if (section == indexFirstLineItem) {
				return [self loadEditSectionHeaderForTag:indexFirstLineItem withTitle:@"Line Items"];
			}
			return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 32.5;
}


#pragma mark -
#pragma mark Button delegate

- (IBAction)email:(id)sender {
    self.mailComposeViewController = [EmailManager mailComposeViewControllerWithDelegate:self forEstimate:estimate];

    [self.navigationController presentModalViewController:mailComposeViewController animated:YES];
}

- (IBAction)print:(id)sender {
	[PrintManager printEstimate:estimate withDelegate:self];
}

- (IBAction)view:(id)sender {
    self.pdfViewController.pdfData = [PDFManager pdfDataForEstimate:self.estimate];
    [self.navigationController pushViewController:pdfViewController animated:YES];
}

- (IBAction)modify:(id)sender {
	UIButton *edit = (UIButton *)sender;

	if (edit.tag == EstimateDetailSectionClientInfo) {
		aNewClientInfoViewController.estimate = estimate;
		aNewClientInfoViewController.editMode = YES;
		[self.navigationController pushViewController:aNewClientInfoViewController animated:YES];
	}
	else if (edit.tag == EstimateDetailSectionContactInfo) {
		contactInfosViewController.estimate = estimate;
		contactInfosViewController.editMode = YES;
		[self.navigationController pushViewController:contactInfosViewController animated:YES];
	}
	else if (edit.tag == indexFirstLineItem) {
		lineItemSelectionsViewController.estimate = estimate;
		lineItemSelectionsViewController.editMode = YES;
		[self.navigationController pushViewController:lineItemSelectionsViewController animated:YES];
	}
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
		NSLog(@"EstimateDetailViewController.mailComposeController:didFinishWithResult:error failed to email estimate %@ with error %@, %@", estimate.clientInfo.name, error, [error userInfo]);
	}

    self.mailComposeViewController = nil;
}

#pragma mark -
#pragma mark Print completed delegate

- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error {
	if (error) {
		// TODO handle error
		NSLog(@"EstimateDetailViewController.printJobCompleted: failed to print estimate %@ with error %@, %@", estimate.clientInfo.name, error, [error userInfo]);
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
	NSLog(@"EstimateDetailViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.title = nil;
	self.toolbarItems = nil;
	self.editSectionHeader = nil;
	self.emailButton = nil;
	self.printButton = nil;
    self.pdfButton = nil;
	self.lineItemSelectionsViewController = nil;
	self.contactInfosViewController = nil;
	self.aNewClientInfoViewController = nil;
    self.pdfViewController = nil;
	self.estimate = nil;
	lineItemSelections = nil;
    self.mailComposeViewController = nil;
}




@end

