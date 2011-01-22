//
//  WorkingTitleAppDelegate.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WorkingTitleAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	UINavigationController *estimatesNavigationController;
	
	NSMutableArray *estimates;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet UINavigationController *estimatesNavigationController;

@property (nonatomic, retain) NSMutableArray *estimates;

- (void)addEstimateWithClientName:(NSString *)newClientName;


@end
