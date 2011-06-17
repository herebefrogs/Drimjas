//
//  TaxesAndCurrencyViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxesAndCurrencyViewController.h"
// API
#import "DataStore.h"
#import "Currency.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "ReviewEstimateViewController.h"
#import "TableFields.h"


@implementation TaxesAndCurrencyViewController


@synthesize nextButton;
@synthesize saveButton;
@synthesize reviewEstimateViewController;
@synthesize currency;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"TaxesAndCurrencyViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Taxes & Currency", "TaxesAndCurrencyView Navigation Item Title");
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");

	self.currency = [[DataStore defaultStore] currency];

    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	[self.tableView reloadData];
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
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
	[super configureCell:aCell atIndexPath:indexPath];

	TextFieldCell *tfCell = (TextFieldCell *)aCell;

	if (indexPath.section == TaxesAndCurrencySectionCurrency) {
		tfCell.textField.text = currency.isoCode;
		tfCell.textField.placeholder = NSLocalizedString(@"Currency Code", "TaxesAndCurrency Currency Code Placeholder");
		tfCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSUInteger section = textField.tag / 10;
	NSUInteger row = textField.tag - (10 * section);

	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];

	if (indexPath.section == TaxesAndCurrencySectionCurrency) {
		currency.isoCode = textField.text;
	}
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)next:(id)sender {
	NSLog(@"open Photographer Information screen");
}

- (IBAction)save:(id)sender {
	// TODO save taxes
	[[DataStore defaultStore] saveCurrency];

	// save estimate into estimates list
	reviewEstimateViewController.estimate = [[DataStore defaultStore] saveEstimateStub];

	// reset navigation controller to review estimate view controller
	UIViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
	[self.navigationController setViewControllers:[NSArray arrayWithObjects:rootController,
												   reviewEstimateViewController,
												   nil]
										 animated:YES];
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
	NSLog(@"TaxesAndCurrencyViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.nextButton = nil;
    self.saveButton = nil;
	self.reviewEstimateViewController = nil;
	self.currency = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"TaxesAndCurrencyViewController.dealloc");
#endif
	[nextButton release];
	[saveButton release];
	[reviewEstimateViewController release];
	[currency release];
    [super dealloc];
}


@end

