//
//  ReviewEstimateViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReviewEstimateViewController.h"
// API
#import "ClientInfo.h"
#import "ContactInformation.h"
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
#import "TableFields.h"


@implementation ReviewEstimateViewController

@synthesize estimate;
@synthesize emailButton;
@synthesize printButton;
@synthesize spacerButton;
@synthesize editSectionHeader;

- (void)setEstimate:(Estimate *)newEstimate {
	[estimate release];
	[lineItemSelections release];

	estimate = [newEstimate retain];
	if (estimate) {
		indexFirstLineItem = ReviewEstimateSectionContactInfo + estimate.clientInfo.contactInfos.count;
		indexLastSection = indexFirstLineItem + estimate.lineItems.count;
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
		lineItemSelections = [[estimate.lineItems sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] retain];
		[sortDescriptor release];
	}
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ReviewEstimateViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Review Estimate", "ReviewEstimate Navigation Item Title");

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
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	// hide toolbar with animation
	[self.navigationController setToolbarHidden:YES animated:YES];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ReviewEstimateSectionContactInfo + estimate.clientInfo.contactInfos.count + estimate.lineItems.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case ReviewEstimateSectionOrderNumber:
			return NSLocalizedString(@"Order Number", "Review Estimate Order Number section title");
		default:
			return nil;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == ReviewEstimateSectionOrderNumber) {
		// order number
		return 1;
	}
	else if (section == ReviewEstimateSectionClientInfo) {
		return [estimate.clientInfo numSetProperties];
	}
	else if (section >= ReviewEstimateSectionContactInfo && section < indexFirstLineItem) {
		// BUG #5: must have saved contact info order to be able to lookup one by index
		ContactInformation *contactInfo = [[estimate.clientInfo.contactInfos allObjects] objectAtIndex:(section - ReviewEstimateSectionContactInfo)];
		return [contactInfo numSetProperties];
	}
	else {
		LineItemSelection *lineItem = (LineItemSelection *)[lineItemSelections objectAtIndex:(section - indexFirstLineItem)];

		// collapse Quantity & Unit Cost rows together, and skip Description row if empty
		return numLineItemSelectionField - (lineItem.details.length > 0 ? 1 : 2);
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

	if (indexPath.section == ReviewEstimateSectionOrderNumber) {
		cell.textLabel.text = [estimate orderNumber];
	}
	else if (indexPath.section == ReviewEstimateSectionClientInfo) {
		cell.textLabel.text = [estimate.clientInfo getSetPropertyWithIndex:indexPath.row];
	}
	else if (indexPath.section >= ReviewEstimateSectionContactInfo && indexPath.section < indexFirstLineItem) {
		// BUG #5: must have saved contact info order to be able to lookup one by index
		ContactInformation *contactInfo = [[estimate.clientInfo.contactInfos allObjects] objectAtIndex:(indexPath.section - ReviewEstimateSectionContactInfo)];
		
		cell.textLabel.text = [contactInfo getSetPropertyWithIndex:indexPath.row];
	}
	else if (indexPath.section >= indexFirstLineItem && indexPath.section < indexLastSection) {
		LineItemSelection *lineItem = (LineItemSelection *)[lineItemSelections objectAtIndex:(indexPath.section - indexFirstLineItem)];

		if (indexPath.row == LineItemSelectionFieldName) {
			cell.textLabel.text = lineItem.lineItem.name;
		}
		else if (indexPath.row == LineItemSelectionFieldDetails && lineItem.details.length > 0) {
			cell.textLabel.text = lineItem.details;
		}
		else if (indexPath.row == LineItemSelectionFieldQuantity
				 || (indexPath.row == LineItemSelectionFieldDetails && lineItem.details.length == 0)) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

			[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			NSString *quantity = [numberFormatter stringFromNumber:lineItem.quantity];

			[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			[numberFormatter setCurrencyCode:[[[DataStore defaultStore] currency] isoCode]];
			NSString *unitCost = [numberFormatter stringFromNumber:lineItem.unitCost];

			cell.textLabel.text = [NSString stringWithFormat:@"%@ x %@", quantity, unitCost];
			[numberFormatter release];
		}
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

- (UIView *)loadEditSectionHeaderForTag:(NSInteger)tag withTitle:(NSString *)title {
	EditSectionHeader *editHeader;

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
		case ReviewEstimateSectionClientInfo:
			return [self loadEditSectionHeaderForTag:ReviewEstimateSectionClientInfo withTitle:@"Client Information"];
			break;
		case ReviewEstimateSectionContactInfo:
			return [self loadEditSectionHeaderForTag:ReviewEstimateSectionContactInfo withTitle:@"Contact Information"];
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
	NSLog(@"Edit section %u", edit.tag);
}

#pragma mark -
#pragma mark Print completed delegate

- (void)mailSent:(MFMailComposeResult)result withError:(NSError *)error {
	if (result == MFMailComposeResultFailed) {
		NSLog(@"ReviewEstimateViewController.mailSent: failed to email estimate %@ with error %@, %@", estimate.clientInfo.name, error, [error userInfo]);
	}
}

- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error {
	if (error) {
		NSLog(@"ReviewEstimateViewController.printJobCompleted: failed to print estimate %@ with error %@, %@", estimate.clientInfo.name, error, [error userInfo]);
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
	NSLog(@"ReviewEstimateViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.title = nil;
	self.toolbarItems = nil;
	self.editSectionHeader = nil;
	self.emailButton = nil;
	self.printButton = nil;
	self.estimate = nil;
	[lineItemSelections release];
	lineItemSelections = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ReviewEstimateViewController.dealloc");
#endif
	[editSectionHeader release];
	[spacerButton release];
	[printButton release];
	[emailButton release];
	[estimate release];
	[lineItemSelections release];
    [super dealloc];
}


@end

