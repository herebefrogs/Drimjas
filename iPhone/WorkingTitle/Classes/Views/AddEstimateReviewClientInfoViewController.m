//
//  AddEstimateReviewClientInfoViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateReviewClientInfoViewController.h"
// API
#import "ClientInformation.h"
#import "ContactInformation.h"
#import "Estimate.h"
#import "DataStore.h"
// View
#import "AddEstimateLineItemsViewController.h"
#import "TableFields.h"

@implementation AddEstimateReviewClientInfoViewController

@synthesize nextButton;
@synthesize lineItemsViewController;
@synthesize clientInfo;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateReviewClientInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Review Client", "AddEstimateReviewClientInfo Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;
	nextButton.title = NSLocalizedString(@"Next", "Next Navigation Item Title");
}
	
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	self.navigationItem.rightBarButtonItem = nextButton;

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
		return [clientInfo numSetProperties];
	} else {
		// BUG #5: must have saved contact info order to be able to lookup one by index
		ContactInformation *contactInfo = [[clientInfo.contactInfos allObjects] objectAtIndex:section - 1];
		return [contactInfo numSetProperties];
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
		cell.textLabel.text = [clientInfo getSetPropertyWithIndex:indexPath.row];
	} else {
		// BUG #5: must have saved contact info order to be able to lookup one by index
		ContactInformation *contactInfo = [[clientInfo.contactInfos allObjects] objectAtIndex:indexPath.section - 1];

		cell.textLabel.text = [contactInfo getSetPropertyWithIndex:indexPath.row];
	}

	return cell;
}

#pragma mark -
#pragma mark Button  delegate

- (IBAction)next:(id)sender {
	Estimate *estimate = [[DataStore defaultStore] estimateStub];

	// delete or deassociate previously set client info
	if ([estimate.clientInfo.status integerValue] == StatusCreated) {
		[[DataStore defaultStore] deleteClientInformation:estimate.clientInfo];
	}
	else if ([estimate.clientInfo.status integerValue] == StatusActive) {
		[estimate.clientInfo removeEstimatesObject:estimate];
	}

	// associate client info and estimate with each other
	estimate.clientInfo = clientInfo;
	[clientInfo addEstimatesObject:estimate];

	[self.navigationController pushViewController:lineItemsViewController animated:YES];
}

#pragma mark -
#pragma mark Table view delegate

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
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateReviewClientInfoViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.nextButton = nil;
	self.lineItemsViewController = nil;
	self.clientInfo = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateReviewClientInfoViewController.dealloc");
#endif
	[nextButton release];
	[lineItemsViewController release];
	[clientInfo release];
    [super dealloc];
}


@end

