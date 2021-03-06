//
//  OptionsViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import "OptionsViewController.h"
// Views
#import "ClientInfosViewController.h"
#import "LineItemsViewController.h"
#import "MyInfoViewController.h"
#import "TableFields.h"
#import "TaxesAndCurrencyViewController.h"
#import "AboutViewController.h"

@implementation OptionsViewController

@synthesize clientInfosViewController;
@synthesize lineItemsViewController;
@synthesize taxesAndCurrencyViewController;
@synthesize myInfoViewController;
@synthesize aboutViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"OptionsViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Options", @"Options Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;
}

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
    return numOptionsField;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == OptionsFieldClients) {
		cell.textLabel.text = NSLocalizedString(@"Clients", "Options Clients Title");
	}
	else if (indexPath.row == OptionsFieldLineItems) {
		cell.textLabel.text = NSLocalizedString(@"Line Items", "Options Line Items Title");
	}
	else if (indexPath.row == OptionsFieldTaxes) {
		cell.textLabel.text = NSLocalizedString(@"Taxes & Currency", "Options Currency & Taxes Title");
	}
	else if (indexPath.row == OptionsFieldMyInfo) {
		cell.textLabel.text = NSLocalizedString(@"My Information", "Options My Information Title");
	}
	else if (indexPath.row == OptionsFieldAbout) {
		cell.textLabel.text = NSLocalizedString(@"About", "Options About Title");
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == OptionsFieldClients) {
		clientInfosViewController.optionsMode = YES;
		[self.navigationController pushViewController:clientInfosViewController animated:YES];
	}
	else if (indexPath.row == OptionsFieldLineItems) {
		lineItemsViewController.optionsMode = YES;
		[self.navigationController pushViewController:lineItemsViewController animated:YES];
	}
	else if (indexPath.row == OptionsFieldTaxes) {
		taxesAndCurrencyViewController.optionsMode = YES;
		[self.navigationController pushViewController:taxesAndCurrencyViewController animated:YES];
	}
	else if (indexPath.row == OptionsFieldMyInfo) {
		myInfoViewController.optionsMode = YES;
		[self.navigationController pushViewController:myInfoViewController animated:YES];
	}
	else if (indexPath.row == OptionsFieldAbout) {
		[self.navigationController pushViewController:aboutViewController animated:YES];
	}
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
	NSLog(@"OptionsViewController.viewDidUnload");
#endif
    [super viewDidUnload];
	self.clientInfosViewController = nil;
	self.lineItemsViewController = nil;
	self.taxesAndCurrencyViewController = nil;
    self.myInfoViewController = nil;
	self.aboutViewController = nil;
}




@end

