//
//  StartupViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkingTitleAppDelegate;

@interface StartupViewController : UIViewController <UITabBarDelegate> {
	IBOutlet WorkingTitleAppDelegate *appDelegate;
	
	IBOutlet UIButton *addEstimate;
	IBOutlet UITabBarItem *estimates;
}

- (IBAction)click:(id)sender;

@end
