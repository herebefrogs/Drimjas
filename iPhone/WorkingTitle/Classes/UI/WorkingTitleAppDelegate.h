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
	IBOutlet StartupViewController *startupViewController;
	IBOutlet EstimatesViewController *estimatesViewController;
	
	NSMutableArray *estimates;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, readonly) NSMutableArray *estimates;

- (void)addEstimateWithClientName:(NSString *)newClientName;

- (void)selectEstimatesTab;
- (void)showAddEstimateView;


@end
