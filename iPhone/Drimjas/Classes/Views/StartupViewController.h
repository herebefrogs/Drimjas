//
//  StartupViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-02-10.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrimjasAppDelegate;

@interface StartupViewController : UIViewController <UITabBarDelegate> {
	DrimjasAppDelegate *appDelegate;

	UITabBar *tabBar;
}

@property (nonatomic, retain) IBOutlet DrimjasAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;

- (IBAction)click:(id)sender;

@end
