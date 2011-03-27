//
//  AddEstimateViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddEstimateClientInfoViewController.h"
// API
#import "Estimate.h"
#import "Datastore.h"
// Cells
#import "TextFieldCell.h"


@implementation AddEstimateClientInfoViewController

@synthesize textFieldCell;
@synthesize estimate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateClientInfoViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Add Client", "AddEstimateClientInfo Navigation Item Title");
	self.navigationController.tabBarItem.title = self.title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
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

    static NSString *CellIdentifier = @"TextFieldCell";

    TextFieldCell *cell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = textFieldCell;
		self.textFieldCell = nil;
    }

	// initialize client name from estimate
	cell.textField.placeholder = NSLocalizedString(@"Client Name", "ClientName Text Field Placeholder");
	cell.textField.text = estimate.clientName;

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
	NSDate *today = [[NSDate alloc] init];
	estimate.date = today;
	[today release];
	
	[estimate calculateNumber:[[DataStore defaultStore] estimates]];

	// TODO save only if client name valid

	// save estimate into estimates list
	[[DataStore defaultStore] saveEstimate:estimate];

	// trigger callback to refresh estimates table
	estimate.callbackBlock();

	// release estimate
	self.estimate = nil;

	// hide client info view
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
	// discard new estimate
	[[DataStore defaultStore] deleteEstimate:estimate];

	// release estimate
	self.estimate = nil;

	// hide client info view
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (textField.text == nil || textField.text.length == 0) {
		// TODO show an overlay view next to text field to indicate it's empty
		return NO;
	}
	// hide keyboard
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	// TODO hide overlay view if any
	// save current client name into estimate
	estimate.clientName = textField.text;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	return [self textFieldShouldEndEditing:textField];
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
	self.textFieldCell = nil;
	self.estimate = nil;
	// note: don't nil title or navigationController.tabBarItem.title
	// as it may appear on the view currently displayed
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"AddEstimateClientInfoViewController.dealloc");
#endif
	[estimate release];
	[textFieldCell release];
    [super dealloc];
}


@end

