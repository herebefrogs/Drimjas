//
//  AddEstimatePickLineItem.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimatePickLineItemViewController.h"
// API
#import "DataStore.h"
#import "LineItem.h"
#import "LineItemSelection.h"
// Views
#import "NewLineItemViewController.h"

@implementation AddEstimatePickLineItemViewController

@synthesize lineItems;
@synthesize lineItemSelection;
@synthesize newLineItemViewController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimatePickLineItemViewController.viewDidLoad");
#endif
    [super viewDidLoad];

	self.title = NSLocalizedString(@"Pick Line Item", "AddEstimatePickLineItems Navigation Item Title");

	self.lineItems = [[DataStore defaultStore] lineItemsFetchedResultsController];
	lineItems.delegate = self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [lineItems.sections objectAtIndex:section];
    return 1 + [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.row == 0) {
		static NSString *CellIdentifier = @"AddLineItemCell";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		cell.textLabel.text = NSLocalizedString(@"Add a Line Item", "AddEstimatePickLineItem Add A Line Item Row");
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		return cell;
	} else {
		static NSString *CellIdentifier = @"LineItemCell";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}

		// NOTE: reduce index path by 1 to account for extra "add a line item" row not in line items list
		indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];

		LineItem *lineItem = [lineItems objectAtIndexPath:indexPath];
		cell.textLabel.text = NSLocalizedString(lineItem.name, "");
		cell.detailTextLabel.text = NSLocalizedString(lineItem.details, "");

		return cell;
	}
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[self.navigationController pushViewController:newLineItemViewController animated:YES];
	} else {
		// NOTE: reduce index path by 1 to account for extra "add a line item" row not in line items list
		indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
		LineItem *lineItem = [lineItems objectAtIndexPath:indexPath];

		lineItemSelection.lineItem = lineItem;
		lineItemSelection.details = lineItem.details;
		if ([lineItem.name isEqualToString:NSLocalizedString(@"Handling & Shipping", "")]) {
			lineItemSelection.quantity = [NSNumber numberWithInt:1];
		}
		[lineItem addLineItemSelectionsObject:lineItemSelection];

		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark -
#pragma mark FetchedResultsController delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
	[self.tableView reloadData];
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
	NSLog(@"AddEstimatePickLineItemViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    lineItems.delegate = nil;
	self.lineItems = nil;
	self.lineItemSelection = nil;
	self.newLineItemViewController = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimatePickLineItemViewController.dealloc");
#endif
	[lineItems release];
	[lineItemSelection release];
	[newLineItemViewController release];
    [super dealloc];
}


@end

