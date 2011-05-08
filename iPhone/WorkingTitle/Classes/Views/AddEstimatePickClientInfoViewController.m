//
//  AddEstimatePickClientInfoViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimatePickClientInfoViewController.h"
// API
#import "ClientInformation.h"
#import "DataStore.h"
// Views
#import "AddEstimateReviewClientInfoViewController.h"


@implementation AddEstimatePickClientInfoViewController

@synthesize clientInfos;
@synthesize reviewClientInfoViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimatePickClientInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Pick Client", "AddEstimatePickClientInfo Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;

	self.clientInfos = [[DataStore defaultStore] clientInfosFetchedResultsController];
	clientInfos.delegate = self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return clientInfos.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = [clientInfos.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ClientInformation *clientInfo = [clientInfos objectAtIndexPath:indexPath];
	cell.textLabel.text = clientInfo.name;

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	reviewClientInfoViewController.clientInfo = [clientInfos objectAtIndexPath:indexPath];

	[self.navigationController pushViewController:reviewClientInfoViewController animated:YES];
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
	NSLog(@"AddEstimatePickClientInfoViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	clientInfos.delegate = nil;
	self.clientInfos = nil;
	self.reviewClientInfoViewController = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimatePickClientInfoViewController.dealloc");
#endif
	[clientInfos release];
	[reviewClientInfoViewController release];
    [super dealloc];
}


@end

