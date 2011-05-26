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

@implementation AddEstimatePickLineItemViewController

@synthesize lineItems;
@synthesize lineItemSelection;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimatePickLineItemViewController.viewDidLoad");
#endif
    [super viewDidLoad];

	self.title = NSLocalizedString(@"Pick Line Item", "AddEstimatePickLineItems Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

	self.lineItems = [[DataStore defaultStore] lineItemsFetchedResultsController];
	lineItems.delegate = self;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
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
    return lineItems.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [lineItems.sections objectAtIndex:section];
    return 1 + [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	id<NSFetchedResultsSectionInfo> sectionInfo = [lineItems.sections objectAtIndex:indexPath.section];
	if (indexPath.section == sectionInfo.numberOfObjects) {
		cell.textLabel.text = NSLocalizedString(@"Add a Line Item", "AddEstimatePickLineItem Add A Line Item Row");
	} else {
		LineItem *lineItem = [lineItems objectAtIndexPath:indexPath];
		cell.textLabel.text = NSLocalizedString(lineItem.name, "");
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// deselect cell immediately
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];

	if (indexPath.row == 0) {
		// TODO open New Line Item screen
		NSLog(@"open New Line Item screen");
	} else {
		// NOTE: reduce index path by 1 to account for extra "add a line item" row not in line items list
		indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
		LineItem *lineItem = [lineItems objectAtIndexPath:indexPath];

		lineItemSelection.lineItem = lineItem;
		lineItemSelection.details = lineItem.details;
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
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimatePickLineItemViewController.dealloc");
#endif
	[lineItems release];
	[lineItemSelection release];
    [super dealloc];
}


@end

