//
//  WorkingTitleAppDelegate.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingTitleAppDelegate.h"
// API
#import "Estimate.h"
// UI
#import "StartupViewController.h"
#import "EstimatesViewController.h"


@implementation WorkingTitleAppDelegate

@synthesize window;
@synthesize tabBarController;

@synthesize estimates;

- (void)selectEstimatesTab {
	// dismiss startup view
	[tabBarController dismissModalViewControllerAnimated:YES];
	// not clear how that selects the estimates tab
	// TODO verify that it works when there are multiple tabs
}

- (void)showAddEstimateView {
	[estimatesViewController add:nil];
}

- (void)addEstimateWithClientName:(NSString *)newClientName {
	[estimates addObject: [[[Estimate alloc] initWithClientName:newClientName] autorelease]];
}

- (void)loadDefaultData {
	estimates = [[NSMutableArray arrayWithObjects:
					[[[Estimate alloc] initWithClientName:@"John Doe"] autorelease],
					[[[Estimate alloc] initWithClientName:@"John Smith"] autorelease],
					nil]
				 retain];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self loadDefaultData];

    // Add the tab bar controller's view to the window and display.
	[self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

	// load startup view on top of tab bar controller's view
	[tabBarController presentModalViewController:startupViewController animated:NO];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
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
}


- (void)dealloc {
	[estimates release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

