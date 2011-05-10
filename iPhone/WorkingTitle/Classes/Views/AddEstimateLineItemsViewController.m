//
//  AddEstimateLineItemsViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateLineItemsViewController.h"
// API
#import "DataStore.h"
#import "Estimate.h"
#import "LineItemSelection.h"
#import "LineItem.h"
// Views
#import "TableFields.h"

@implementation AddEstimateLineItemsViewController

@synthesize nextButton;
@synthesize lineItemSelections;
@synthesize estimate;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateLineItemsViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Add Line Item", "AddEstimateLineItems Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

    self.navigationItem.rightBarButtonItem = nextButton;

	// show add/delete widgets in front of rows
	[self.tableView setEditing:YES animated:NO];
	self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.estimate = [[DataStore defaultStore] estimateStub];
	self.lineItemSelections = [[DataStore defaultStore] lineItemSelectionsForEstimate:estimate];
	lineItemSelections.delegate = self;
}

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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	self.estimate = nil;
	self.lineItemSelections = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section per line item selection, plus 1 section to add a line item
    return 1 + lineItemSelections.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == lineItemSelections.sections.count) {
		// "add a line item" section has only 1 row
		return 1;
	} else {
		return numLineItemSelectionField;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == lineItemSelections.sections.count) {
		static NSString *CellIdentifier = @"AddLineItemSelectionCell";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		cell.textLabel.text = NSLocalizedString(@"Add a Line Item", "AddEstimateLineItem Add A Line Item Row");

		return cell;
	} else {
		static NSString *CellIdentifier = @"TextFieldCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		NSIndexPath *listIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
		LineItemSelection *lineItem = [lineItemSelections objectAtIndexPath:listIndexPath];

		if (indexPath.row == LineItemSelectionFieldName) {
			cell.textLabel.text = lineItem.lineItem.name;
		} else if (indexPath.row == LineItemSelectionFieldDetails) {
			cell.textLabel.text = lineItem.details;
		} else if (indexPath.row == LineItemSelectionFieldQuantity) {
			cell.textLabel.text = [lineItem.quantity stringValue];
		} else if (indexPath.row == LineItemSelectionFieldUnitCost) {
			cell.textLabel.text = [lineItem.unitCost stringValue];
		}
		
		return cell;
		
	}

	return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	// show a plus sign in front of "add a line item" row
	if (indexPath.section == lineItemSelections.sections.count) {
		return UITableViewCellEditingStyleInsert;
	}
	// show a minus sign in front of 1st row of a contact info section
	else if (indexPath.section != lineItemSelections.sections.count && indexPath.row == 0) {
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)insertLineItemSelectionForIndexPath:(NSIndexPath *)indexPath {
	LineItemSelection *lineItemSelection = [[DataStore defaultStore] createLineItemSelection];
	lineItemSelection.index = [NSNumber numberWithInteger:lineItemSelections.sections.count];

	[estimate addLineItemsObject:lineItemSelection];
	NSLog(@"click! estimate has %u line item selection(s)", estimate.lineItems.count);
	
	//[self controllerDidChangeContent:lineItemSelections];
	//[lineItemSelections performFetch:nil];

	// actually what should be done
	//[self.navigationController pushViewController:pickLineItemViewController animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self insertLineItemSelectionForIndexPath:indexPath];
    }   
}


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
	if (indexPath.section == lineItemSelections.sections.count) {
		// deselect cell immediately
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		[cell setSelected:NO animated:YES];

		[self insertLineItemSelectionForIndexPath:indexPath];
	}
}

#pragma mark -
#pragma mark FetchedResultsController delegate

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
	NSLog(@"lineitemselection controller changed");
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)next:(id)sender {
	// save estimate into estimates list
	[[DataStore defaultStore] saveEstimateStub];

	// hide client info view
	[self dismissModalViewControllerAnimated:YES];

	// reset navigation controller to first view
	[self.navigationController popToRootViewControllerAnimated:YES];
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
	NSLog(@"AddEstimateLineItemsViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.nextButton = nil;
	lineItemSelections.delegate = nil;
	self.lineItemSelections = nil;
	self.estimate = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateLineItemsViewController.dealloc");
#endif
	[nextButton release];
	[lineItemSelections release];
	[estimate release];
    [super dealloc];
}


@end

