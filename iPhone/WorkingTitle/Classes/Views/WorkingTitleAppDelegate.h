//
//  WorkingTitleAppDelegate.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartupViewController;
@class EstimatesViewController;

@interface WorkingTitleAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	EstimatesViewController *estimatesViewController;
	StartupViewController *startupViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet EstimatesViewController *estimatesViewController;
@property (nonatomic, retain) IBOutlet StartupViewController *startupViewController;

// startup screen methods
- (void)selectTabBarItemWithTag:(NSInteger)tag;
- (void)showAddViewWithTag:(NSInteger)tag;

@end
