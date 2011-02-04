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
// Utils
#import "PDFManager.h"
#import "PrintManager.h"


@implementation ReviewEstimateViewController

@synthesize estimate;

- (void)setEstimate:(Estimate *)newEstimate {
	if(estimate != newEstimate) {
		[estimate release];
		estimate = [newEstimate retain];
		[self.tableView reloadData];
	}
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ReviewEstimateViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Review Estimate", "ReviewEstimate Navigation Item Title");
	pdfButton.title = NSLocalizedString(@"PDF", "ReviewEstimate Toolbar PDF Button Title");
	emailButton.title = NSLocalizedString(@"Email", "ReviewEstimate Toolbar Email Button Title");
	printButton.title = NSLocalizedString(@"Print", "ReviewEstimate Toolbar Print Button Title");

	// if printing is available...
	if ([UIPrintInteractionController isPrintingAvailable]) {
		// ... add the Print button to the toolbar
		self.toolbarItems = [NSArray arrayWithObjects: spacerButton, pdfButton, emailButton,
													   printButton, spacerButton, nil];
	} else {
		// ... otherwise don't add the Print button to the toolbar
		self.toolbarItems = [NSArray arrayWithObjects: spacerButton, pdfButton, emailButton,
												       spacerButton, nil];
	}
	// note: navigation controller not set yet
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	// show toolbar with animation
	[self.navigationController setToolbarHidden:NO animated:YES];
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
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


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

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.textLabel.text = estimate.clientName;

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
#pragma mark Button delegage

- (IBAction)savePDF:(id)sender {
	[PDFManager savePDFForEstimate:estimate];
}

- (IBAction)email:(id)sender {
	NSLog(@"emailing estimate %@", estimate.clientName);
}

- (IBAction)print:(id)sender {
	// print completion handler/block/closure
	void (^didPrint)(UIPrintInteractionController *, BOOL, NSError *) =
				   ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
		if (error)
			NSLog(@"ReviewEstimateViewController.didPrint failed to print estimate %@ due to error in domain %@ with error code %u", estimate.clientName, error.domain, error.code);
	};
	
	[PrintManager printEstimate:estimate withHandlerWhenDone:didPrint];
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
	pdfButton.title = nil;
	pdfButton = nil;
	emailButton.title = nil;
	emailButton = nil;
	printButton.title = nil;
	printButton = nil;
	estimate = nil;
}


- (void)dealloc {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"ReviewEstimateViewController.dealloc");
#endif
	[spacerButton release];
	[printButton release];
	[emailButton release];
	[pdfButton release];
	[estimate release];
    [super dealloc];
}


@end

