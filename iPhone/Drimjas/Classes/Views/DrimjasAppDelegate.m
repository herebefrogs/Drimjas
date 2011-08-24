//
//  DrimjasAppDelegate.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "DrimjasAppDelegate.h"
// API
#import "DataStore.h"
// Views
#import "StartupViewController.h"
#import "EstimatesViewController.h"
#import "ContractsViewController.h"
#import "TabBarItems.h"


@implementation DrimjasAppDelegate

@synthesize window;
@synthesize startupViewController;
@synthesize tabBarController;
@synthesize estimatesViewController;
@synthesize contractsViewController;


#pragma mark -
#pragma mark Startup screen methods

- (void)selectTabBarItemWithTag:(NSInteger)tag {
	// dismiss startup view
	[tabBarController dismissModalViewControllerAnimated:YES];

	// each tab bar item's tag set to its index in the tab bar + 1 (since 0 is the default tag value)
	tabBarController.selectedIndex = (tag - 1);
}

- (void)showAddViewWithTag:(NSInteger)tag {
	if (tag == TabBarItemEstimates) {
		[estimatesViewController add:nil];
	}
	else if (tag == TabBarItemContracts) {
		[contractsViewController add:nil];
	}
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// initialize data store
	DataStore *dataStore = [[DataStore alloc] initWithName:@"Drimjas"];
	[DataStore setDefaultStore:dataStore];
	[dataStore release];
	
    // Add the tab bar controller's view to the window and display.
	[self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

	// load startup view on top of tab bar controller's view
	[tabBarController presentModalViewController:startupViewController animated:NO];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"appdelegate.applicationWillResignActive");
#endif
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"appdelegate.applicationDidEnterBackground");
#endif
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[[DataStore defaultStore] saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"appdelegate.applicationWillEnterForeground");
#endif
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"appdelegate.applicationDidBecomeActive");
#endif
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"appdelegate.applicationWillTerminate");
#endif
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[[DataStore defaultStore]  saveContext];
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
#ifdef __ENABLE_UI_LOGS__
	NSLog(@"appdelegate.applicationDidReceiveMemoryWarning");
#endif
}


- (void)dealloc {
	[DataStore setDefaultStore:nil];
	[contractsViewController release];
	[estimatesViewController release];
	[startupViewController release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

