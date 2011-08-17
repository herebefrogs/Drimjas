//
//  ClientInfoDetailViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "ClientInfoDetailViewController.h"
// API
#import "ClientInfo.h"
#import "ContactInfo.h"
#import "Estimate.h"
#import "DataStore.h"
// View
#import "AddEstimateLineItemsViewController.h"
#import "TableFields.h"

@implementation ClientInfoDetailViewController

@synthesize deleteButton;
@synthesize nextButton;
@synthesize lineItemsViewController;
@synthesize clientInfo;
@synthesize optionsMode;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ClientInfoDetailViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Review Client", "ClientInfoDetail Navigation Item Title");
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");
	deleteButton.title = NSLocalizedString(@"Delete", "Delete Navigation Item Title");
}
	
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.navigationItem.rightBarButtonItem = optionsMode ? deleteButton : nextButton;

	// reload table data to match selected client info
	[self.tableView reloadData];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + clientInfo.contactInfos.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
		return [clientInfo countNonEmptyProperties];
	} else {
		ContactInfo *contactInfo = [clientInfo contactInfoAtIndex:section - 1];

		return [contactInfo countNonEmptyProperties];
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

	if (indexPath.section == 0) {
		cell.textLabel.text = [clientInfo nonEmptyPropertyWithIndex:indexPath.row];
	} else {
		ContactInfo *contactInfo = [clientInfo contactInfoAtIndex:indexPath.section - 1];

		cell.textLabel.text = [contactInfo nonEmptyPropertyWithIndex:indexPath.row];
	}

	return cell;
}

#pragma mark -
#pragma mark Button  delegate

- (IBAction)next:(id)sender {
	Estimate *estimate = [[DataStore defaultStore] estimateStub];

	// delete or deassociate previously set client info
	if ([estimate.clientInfo.status intValue] == StatusDraft) {
		[[DataStore defaultStore] deleteClientInfo:estimate.clientInfo andSave:NO];
	}
	else if ([estimate.clientInfo.status intValue] == StatusReady) {
		[estimate.clientInfo removeEstimatesObject:estimate];
	}

	// associate client info and estimate with each other
	estimate.clientInfo = clientInfo;
	[clientInfo addEstimatesObject:estimate];

	lineItemsViewController.editMode = NO;
	[self.navigationController pushViewController:lineItemsViewController animated:YES];
}

- (IBAction)delete:(id)sender {
	[[DataStore defaultStore] deleteClientInfo:clientInfo andSave:YES];

	[self.navigationController popViewControllerAnimated:YES];
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
	NSLog(@"ClientInfoDetailViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.nextButton = nil;
	self.lineItemsViewController = nil;
	self.clientInfo = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ClientInfoDetailViewController.dealloc");
#endif
	[nextButton release];
	[lineItemsViewController release];
	[clientInfo release];
    [super dealloc];
}


@end

