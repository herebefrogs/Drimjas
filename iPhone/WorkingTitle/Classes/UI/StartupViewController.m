//
//  StartupViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StartupViewController.h"
// UI
#import "WorkingTitleAppDelegate.h"


@implementation StartupViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"StartupViewController.viewDidLoad");
#endif
    [super viewDidLoad];
	addEstimate.titleLabel.text = NSLocalizedString(@"Add Estimate", @"Startup View Controller Button");
	estimates.title = NSLocalizedString(@"Estimates", @"Estimates Tab Bar Title");
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	if (item == estimates) {
		[appDelegate selectEstimatesTab];
	}
}

BOOL clickedAddEstimateButton = NO;

- (IBAction)click:(id)sender {
	if (sender == addEstimate) {
		// estimate view controller has to load before add: can be called
		// so register the add button has been clicked until startup view is dismissed
		clickedAddEstimateButton = YES;
		// select the estimate tab which will dismiss startup view
		[appDelegate selectEstimatesTab];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	// startup view has been dismissed, call add: on the appropriate view controller
	if (clickedAddEstimateButton) {
		[appDelegate showAddEstimateView];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"StartupViewController.viewDidUnload");
#endif
    [super viewDidUnload];
	addEstimate.titleLabel.text = nil;
	estimates.title = nil;
	estimates = nil;
}


- (void)dealloc {
	[estimates release];
	[addEstimate release];
    [super dealloc];
}


@end
