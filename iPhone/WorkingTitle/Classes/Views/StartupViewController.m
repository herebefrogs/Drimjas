//
//  StartupViewController.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StartupViewController.h"
// Views
#import "WorkingTitleAppDelegate.h"
#import "TabBarItems.h"


@implementation StartupViewController

@synthesize appDelegate;
@synthesize tabBar;

NSInteger buttonTagClicked_ = 0;

- (IBAction)click:(id)sender {
	UIButton *clicked = (UIButton *)sender;

	// view controllers have to load before add: can be called so
	// register add button has been clicked until startup view is dismissed
	buttonTagClicked_ = clicked.tag;

	[appDelegate selectTabBarItemWithTag:clicked.tag];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	[appDelegate selectTabBarItemWithTag:item.tag];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"StartupViewController.viewDidLoad");
#endif
    [super viewDidLoad];

	// IMPORTANT: as 0 is the tag for Estimates, all button objects
	// in startup.xib must have their tag set to 1+
	for (UIView *subview in self.view.subviews) {
		if (subview.tag == TabBarItemEstimates) {
			UIButton *addEstimate = (UIButton *)subview;
			addEstimate.titleLabel.text = NSLocalizedString(@"Add Estimate", @"Startup View Controller Button");
		}
	}

	// get authoritative list of tab bar items from main window
	[tabBar setItems:appDelegate.tabBarController.tabBar.items animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

	// startup view has been dismissed, call add: on the appropriate view controller if necessary
	if (buttonTagClicked_ >= TabBarItemEstimates) {
		[appDelegate showAddViewWithTag:buttonTagClicked_];
		buttonTagClicked_ = 0;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// only allow portrait orientation on main window not to be bothered
	// with laying out buttons properly in landscape orientation
    return interfaceOrientation == UIInterfaceOrientationPortrait;
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
	self.appDelegate = nil;
	self.tabBar = nil;
}


- (void)dealloc {
	[appDelegate release];
	[tabBar release];
    [super dealloc];
}


@end
