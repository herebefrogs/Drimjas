//
//  EstimatesViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkingTitleAppDelegate;
@class AddEstimateClientInfoViewController;
@class ReviewEstimateViewController;

@interface EstimatesViewController : UITableViewController {
	WorkingTitleAppDelegate *appDelegate;
	UINavigationController *addEstimateNavigationController;
	ReviewEstimateViewController *reviewEstimateViewController;
}

@property (nonatomic, retain) IBOutlet WorkingTitleAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UINavigationController *addEstimateNavigationController;
@property (nonatomic, retain) IBOutlet ReviewEstimateViewController *reviewEstimateViewController;

- (void)addEstimateWithClientName:(NSString *)newClientName;

- (IBAction)add:(id)sender;

@end
