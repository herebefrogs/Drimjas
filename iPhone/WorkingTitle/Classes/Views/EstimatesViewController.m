//
//  EstimatesViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstimatesViewController.h"
// API
#import "Estimate.h"
#import "DataStore.h"
// Views
#import "AddEstimateClientInfoViewController.h"
#import "ReviewEstimateViewController.h"


@implementation EstimatesViewController

@synthesize addEstimateNavigationController;
@synthesize addEstimateClientInfoViewController;
@synthesize reviewEstimateViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimatesViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Estimates", @"Estimates Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

	// start with toolbar hidden (no animation)
	self.navigationController.toolbarHidden = YES;

	self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
    // Return YES for supported orientations.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	DataStore *dataStore = [DataStore defaultStore];
    return dataStore.estimates.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

	DataStore *dataStore = [DataStore defaultStore];
	Estimate *estimate = [dataStore.estimates objectAtIndex:indexPath.row];
    cell.textLabel.text = estimate.clientName;
	cell.detailTextLabel.text = estimate.orderNumber;

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// attempt deleting the estimate from the data store
		if ([[DataStore defaultStore] deleteEstimateAtIndex:indexPath.row]) {
			// delete the row from the data source.
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
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
	DataStore *dataStore = [DataStore defaultStore];
	reviewEstimateViewController.estimate = [dataStore.estimates objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:reviewEstimateViewController animated:YES];
}


#pragma mark -
#pragma mark Button delegate

- (IBAction)add:(id)sender {
	// create empty estimate
	Estimate *estimate = [[DataStore defaultStore] createEstimate];
	// set callback to reload table once estimate has been saved and added to list
	estimate.callbackBlock = ^() {
		[self.tableView reloadData];
	};

	addEstimateClientInfoViewController.estimate = estimate;
	[self presentModalViewController:addEstimateNavigationController animated:YES];
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
	NSLog(@"EstimatesViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.reviewEstimateViewController = nil;
	self.addEstimateClientInfoViewController = nil;
	self.addEstimateNavigationController = nil;
	self.navigationItem.leftBarButtonItem = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimatesViewController.dealloc");
#endif
	[reviewEstimateViewController release];
	[addEstimateClientInfoViewController release];
	[addEstimateNavigationController release];
    [super dealloc];
}


@end

