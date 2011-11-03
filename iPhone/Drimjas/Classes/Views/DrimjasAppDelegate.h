//
//  DrimjasAppDelegate.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartupViewController;
@class EstimatesViewController;
@class ContractsViewController;

@interface DrimjasAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	EstimatesViewController *estimatesViewController;
	ContractsViewController *contractsViewController;
	StartupViewController *startupViewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, strong) IBOutlet EstimatesViewController *estimatesViewController;
@property (nonatomic, strong) IBOutlet ContractsViewController *contractsViewController;
@property (nonatomic, strong) IBOutlet StartupViewController *startupViewController;

// startup screen methods
- (void)selectTabBarItemWithTag:(NSInteger)tag;
- (void)showAddViewWithTag:(NSInteger)tag;

@end
