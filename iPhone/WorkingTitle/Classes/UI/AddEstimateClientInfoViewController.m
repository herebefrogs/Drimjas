//
//  AddEstimateViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateClientInfoViewController.h"
#import "EstimatesViewController.h"


@implementation AddEstimateClientInfoViewController

@synthesize estimatesViewController, clientNameTextField, clientNameCell;

- (BOOL)addEstimate {
	// discard empty names
	if (clientNameTextField.text == nil || clientNameTextField.text.length == 0) {
		return NO;
	} else {
		[estimatesViewController addEstimateWithClientName:clientNameTextField.text];
		return YES;
	}
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateClientInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Add Client", "AddEstimateClientInfo Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;
	clientNameTextField.placeholder = NSLocalizedString(@"Client Name", "ClientName Text Field Placeholder");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	clientNameTextField.text = nil;
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
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

    static NSString *CellIdentifier = @"ClientNameCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = clientNameCell;
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
#pragma mark Button & Textfield delegate

- (IBAction)save:(id)sender {
	[self addEstimate];
	[self cancel:sender];
}

- (IBAction)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

// keyboard's Done button pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	BOOL nameValid = [self addEstimate];
	if (nameValid) {
		// hide keyboard
		[textField resignFirstResponder];
	}
	return nameValid;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	// as client name is the only field and estimate has been saved,
	// hide modal window. when there will be multiple field, it should
	// probably do nothing
	[self cancel:textField];
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
	NSLog(@"AddEstimateClientInfoViewController.viewDidUnload");
#endif
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	clientNameTextField.text = nil;
	clientNameTextField.placeholder = nil;
	self.clientNameTextField = nil;
	self.clientNameCell = nil;
	self.estimatesViewController = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateClientInfoViewController.dealloc");
#endif
	[estimatesViewController release];
	[clientNameCell release];
	[clientNameTextField release];
    [super dealloc];
}


@end

