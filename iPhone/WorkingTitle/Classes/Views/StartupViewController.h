//
//  StartupViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-10.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkingTitleAppDelegate;

@interface StartupViewController : UIViewController <UITabBarDelegate> {
	WorkingTitleAppDelegate *appDelegate;

	UITabBar *tabBar;
}

@property (nonatomic, retain) IBOutlet WorkingTitleAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;

- (IBAction)click:(id)sender;

@end
