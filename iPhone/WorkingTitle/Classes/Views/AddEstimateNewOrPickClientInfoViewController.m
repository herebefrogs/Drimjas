//
//  AddEstimateNewOrPickViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateNewOrPickClientInfoViewController.h"
// API
#import "DataStore.h"
// Views
#import "AddEstimateClientInfoViewController.h"
#import "TableFields.h"

@implementation AddEstimateNewOrPickClientInfoViewController

@synthesize addEstimateClientInfoViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateNewOrPickClientInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Add Client", "AddEstimateNewOrPickClientInfo Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numClientInfoSection;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section == NewClientInfoSection) {
		cell.textLabel.text = NSLocalizedString(@"Add New Client Information", @"AddEstimateNewOrPickClientInfo New Client Section");
	} else if (indexPath.section == PickClientInfoSection) {
		cell.textLabel.text = NSLocalizedString(@"Pick Existing Client Information", @"AddEstimateNewOrPickClientInfo Pick Existing Client Section");
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// deselect cell immediately
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell setSelected:NO animated:YES];	

	if (indexPath.section == NewClientInfoSection) {
		[self.navigationController pushViewController:addEstimateClientInfoViewController animated:YES];
	} else if (indexPath.section == PickClientInfoSection) {
		// TODO will need to purge ClientInfo in estimate if selecting "pick" (use case add->new->back->pick)
		NSLog(@"pick existing client information not yet implemented");
	}
}

#pragma mark -
#pragma mark Button delegate

- (IBAction)cancel:(id)sender {
	// discard new estimate
	[[DataStore defaultStore] deleteEstimateStub];
	
	// hide new or pick client info view
	[self dismissModalViewControllerAnimated:YES];
}
	
#pragma mark -
#pragma mark Memory management
	
- (void)viewDidUnload {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateNewOrPickClientInfoViewController.viewDidUnload");
#endif
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.addEstimateClientInfoViewController = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
	[super viewDidUnload];
}

- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateNewOrPickClientInfoViewController.dealloc");
#endif
	[addEstimateClientInfoViewController release];
	[super dealloc];
}

@end

