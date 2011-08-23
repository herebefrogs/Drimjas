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
// Utils
#import "PDFManager.h"
// Cells
#import "EditSectionHeader.h"
// Views
#import "AddEstimateLineItemsViewController.h"
#import "ContactInfosViewController.h"
#import "NewClientInfoViewController.h"
#import "TableFields.h"


@implementation EstimateDetailViewController

#pragma mark -
#pragma mark Private methods stack

- (void)reloadIndexes {
	indexFirstLineItem = EstimateDetailSectionContactInfo + MAX(1, estimate.clientInfo.contactInfos.count);
	indexLastSection = indexFirstLineItem + MAX(1, estimate.lineItems.count);

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	[lineItemSelections release];
	lineItemSelections = [[estimate.lineItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] retain];
	[sortDescriptor release];
}


#pragma mark -
#pragma mark Properties stack

@synthesize emailButton;
@synthesize printButton;
@synthesize spacerButton;
@synthesize editSectionHeader;
@synthesize lineItemSelectionsViewController;
@synthesize contactInfosViewController;
@synthesize newClientInfoViewController;
@synthesize estimate;

- (void)setEstimate:(Estimate *)newEstimate {
	[estimate release];

	estimate = [newEstimate retain];
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
	self.title = NSLocalizedString(@"Review Estimate", "EstimateDetail Navigation Item Title");

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
			return NSLocalizedString(@"Purchase Order Number", "Review Estimate Order Number section title");
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
			[numberFormatter release];
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
	
	CALayer *layer = editHeader.edit.layer;
    layer.cornerRadius = 6.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;
	
	CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = editHeader.edit.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.2f alpha:0.2f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [editHeader.edit.layer addSublayer:shineLayer];

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
	[EmailManager mailEstimate:estimate withDelegate:self];
}

- (IBAction)print:(id)sender {
	[PrintManager printEstimate:estimate withDelegate:self];
}

- (IBAction)modify:(id)sender {
	UIButton *edit = (UIButton *)sender;

	if (edit.tag == EstimateDetailSectionClientInfo) {
		newClientInfoViewController.estimate = estimate;
		newClientInfoViewController.editMode = YES;
		[self.navigationController pushViewController:newClientInfoViewController animated:YES];
	}
	else if (edit.tag == EstimateDetailSectionContactInfo) {
		contactInfosViewController.clientInfo = estimate.clientInfo;
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
#pragma mark Print completed delegate

- (void)mailSent:(MFMailComposeResult)result withError:(NSError *)error {
	if (result == MFMailComposeResultFailed) {
		NSLog(@"EstimateDetailViewController.mailSent: failed to email estimate %@ with error %@, %@", estimate.clientInfo.name, error, [error userInfo]);
	}
}

- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error {
	if (error) {
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
	self.lineItemSelectionsViewController = nil;
	self.contactInfosViewController = nil;
	self.newClientInfoViewController = nil;
	self.estimate = nil;
	[lineItemSelections release];
	lineItemSelections = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimateDetailViewController.dealloc");
#endif
	[editSectionHeader release];
	[spacerButton release];
	[printButton release];
	[emailButton release];
	[lineItemSelectionsViewController release];
	[contactInfosViewController release];
	[newClientInfoViewController release];
	[estimate release];
	[lineItemSelections release];
    [super dealloc];
}


@end

