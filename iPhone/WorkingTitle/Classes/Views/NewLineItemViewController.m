//
//  NewLineItemViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewLineItemViewController.h"
// API
#import "DataStore.h"
#import "LineItem.h"
// Cells
#import "TextFieldCell.h"
// Views
#import "TableFields.h"


@implementation NewLineItemViewController


@synthesize addButton;
@synthesize lineItem;


#pragma mark -
#pragma mark Private attributes & methods stack

BOOL added = NO;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"NewLineItemViewController.viewDidLoad");
#endif
	[super viewDidLoad];

	self.title = NSLocalizedString(@"New Line Item", "NewLineItems Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

	self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.lineItem = [[DataStore defaultStore] createLineItemWithPreset:NO];

	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

	if (added) {
		[[DataStore defaultStore] saveLineItem:lineItem];
		added = NO;
	} else {
		[[DataStore defaultStore] deleteLineItem:lineItem];
	}

	self.lineItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


#pragma mark -
#pragma mark Table view delegate

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath {
	TextFieldCell *tfCell = (TextFieldCell *)aCell;

	if (indexPath.row == LineItemFieldName) {
		tfCell.textField.placeholder = NSLocalizedString(@"Line Item Name", "NewLineItem Name Textfield");
	}
	else if (indexPath.row == LineItemFieldDetails) {
		tfCell.textField.placeholder = NSLocalizedString(@"Description", "NewLineItem Description Textfield");
	}
}


#pragma mark -
#pragma mark Textfield delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSUInteger section = textField.tag / 10;
	NSUInteger row = textField.tag - (10 * section);

	// TODO hide overlay view if any
	// save textfield value into estimate
	if (row == LineItemFieldName) {
		lineItem.name = textField.text;
	}
	else if (row == LineItemFieldDetails) {
		lineItem.details = textField.text;
	}
}


#pragma mark -
#pragma mark Button delegate

// Customize the appearance of table view cells.
- (IBAction)add:(id)sender {
	// forces currently edited textfield's value to be processed
	[lastTextFieldEdited resignFirstResponder];

	if ([lineItem isValid]) {
		// saving line item will be done when screen disappear
		added = YES;

		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"NewLineItemViewController.viewDidUnload");
#endif
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.addButton = nil;
	self.lineItem = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"NewLineItemViewController.dealloc");
#endif
	[addButton release];
	[lineItem release];
    [super dealloc];
}


@end