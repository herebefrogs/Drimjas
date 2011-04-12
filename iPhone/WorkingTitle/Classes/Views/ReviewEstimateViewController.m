//
//  ReviewEstimateViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReviewEstimateViewController.h"
// API
#import "Estimate.h"
#import "ClientInformation.h"
#import "ContactInformation.h"
// Utils
#import "PDFManager.h"
// Views
#import "TableFields.h"


@implementation ReviewEstimateViewController

@synthesize estimate, emailButton, printButton, spacerButton;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ReviewEstimateViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Review Estimate", "ReviewEstimate Navigation Item Title");

	NSMutableArray *items = [NSMutableArray arrayWithObject: spacerButton];
	if ([EmailManager isMailAvailable]) {
		// add Email button only if mail is available on iPhone
		[items addObject:emailButton];
	}
	if ([PrintManager isPrintingAvailable]) {
		// add Print button only if printing is available on iPhone
		[items addObject:printButton];
	}
	[items addObject:spacerButton];
	self.toolbarItems = items;

	// note: navigation controller not set yet
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	// show toolbar with animation
	[self.navigationController setToolbarHidden:NO animated:YES];
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	// hide toolbar with animation
	[self.navigationController setToolbarHidden:YES animated:YES];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1 + estimate.clientInfo.contactInfos.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return (section == 0) ? numClientInfoField : numContactInfoField;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	cell.textLabel.tag = indexPath.row;

	if (indexPath.section == 0) {
		// initialize textfield value from estimate
		if (indexPath.row == ClientInfoFieldName) {
			cell.textLabel.text = estimate.clientInfo.name;
		}
		else if (indexPath.row == ClientInfoFieldAddress1) {
			cell.textLabel.text = estimate.clientInfo.address1;
		}
		else if (indexPath.row == ClientInfoFieldAddress2) {
			cell.textLabel.text = estimate.clientInfo.address2;
		}
		else if (indexPath.row == ClientInfoFieldCity) {
			cell.textLabel.text = estimate.clientInfo.city;
		}
		else if (indexPath.row == ClientInfoFieldState) {
			cell.textLabel.text = estimate.clientInfo.state;
		}
		else if (indexPath.row == ClientInfoFieldPostalCode) {
			cell.textLabel.text = estimate.clientInfo.postalCode;
		}
		else if (indexPath.row == ClientInfoFieldCountry) {
			cell.textLabel.text = estimate.clientInfo.country;
		}
	} else {
		// BUG #5: must have saved contact info order to be able to lookup one by index
		ContactInformation *contactInfo = [[estimate.clientInfo.contactInfos allObjects] objectAtIndex:indexPath.section - 1];

		if (indexPath.row == ContactInfoFieldName) {
			cell.textLabel.text = contactInfo.name;
		} else if (indexPath.row == ContactInfoFieldPhone) {
			cell.textLabel.text = contactInfo.phone;
		} else if (indexPath.row == ContactInfoFieldEmail) {
			cell.textLabel.text = contactInfo.email;
		}
	}

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
#pragma mark Button delegate

- (IBAction)email:(id)sender {
	[EmailManager mailEstimate:estimate withDelegate:self];
}

- (IBAction)print:(id)sender {
	[PrintManager printEstimate:estimate withDelegate:self];
}

#pragma mark -
#pragma mark Print completed delegate

- (void)mailSent:(MFMailComposeResult)result withError:(NSError *)error {
	if (result == MFMailComposeResultFailed) {
		NSLog(@"ReviewEstimateViewController.mailSent: failed to email estimate %@ with error %@, %@", estimate.clientInfo.name, error, [error userInfo]);
	}
}

- (void)printJobCompleted:(BOOL)completed withError:(NSError *)error {
	if (error) {
		NSLog(@"ReviewEstimateViewController.printJobCompleted: failed to print estimate %@ with error %@, %@", estimate.clientInfo.name, error, [error userInfo]);
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
	NSLog(@"ReviewEstimateViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.title = nil;
	self.toolbarItems = nil;
	self.emailButton = nil;
	self.printButton = nil;
	self.estimate = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ReviewEstimateViewController.dealloc");
#endif
	[spacerButton release];
	[printButton release];
	[emailButton release];
	[estimate release];
    [super dealloc];
}


@end

