//
//  EstimatesViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstimatesViewController.h"
#import "WorkingTitleAppDelegate.h"
#import "ReviewEstimateViewController.h"
#import "AddEstimateViewController.h"
#import "Estimate.h"


@implementation EstimatesViewController


- (void)addEstimateWithClientName:(NSString *)newClientName {
	[appDelegate addEstimateWithClientName:newClientName];
	[self.tableView reloadData];
}

- (void)reviewEstimateAtIndex:(NSInteger)index {
	reviewEstimateViewController.estimate = [appDelegate.estimates objectAtIndex:index];
	[self.navigationController pushViewController:reviewEstimateViewController animated:YES];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimatesViewController.viewDidLoad");
#endif
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Estimates", @"Estimates Navigation Item Title");
	self.navigationController.tabBarItem.title = NSLocalizedString(@"Estimates", @"Estimates Tab Bar Title");

	// start with toolbar hidden (no animation)
	self.navigationController.toolbarHidden = YES;
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
    return appDelegate.estimates.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	Estimate *estimate = [appDelegate.estimates objectAtIndex:indexPath.row];
    cell.textLabel.text = estimate.clientName;

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
	[self reviewEstimateAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)add:(id)sender {
	[self presentModalViewController:addEstimateViewController animated:YES];
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
	reviewEstimateViewController = nil;
	addEstimateViewController = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"EstimatesViewController.dealloc");
#endif
	[reviewEstimateViewController release];
	[addEstimateViewController release];
	[appDelegate release];
    [super dealloc];
}


@end

