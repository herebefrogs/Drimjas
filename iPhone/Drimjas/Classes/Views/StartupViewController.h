//
//  StartupViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-02-10.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <UIKit/UIKit.h>

@class DrimjasAppDelegate;

@interface StartupViewController : UIViewController <UITabBarDelegate> {
	DrimjasAppDelegate *appDelegate;

	UITabBar *tabBar;
}

@property (nonatomic, strong) IBOutlet DrimjasAppDelegate *appDelegate;
@property (nonatomic, strong) IBOutlet UITabBar *tabBar;

- (IBAction)click:(id)sender;

@end
