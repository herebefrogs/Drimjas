//
//  EstimatesViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddEstimateClientInfoViewController;
@class ReviewEstimateViewController;

@interface EstimatesViewController : UITableViewController {
	UINavigationController *addEstimateNavigationController;
	AddEstimateClientInfoViewController *addEstimateClientInfoViewController;
	ReviewEstimateViewController *reviewEstimateViewController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *addEstimateNavigationController;
@property (nonatomic, retain) IBOutlet AddEstimateClientInfoViewController *addEstimateClientInfoViewController;
@property (nonatomic, retain) IBOutlet ReviewEstimateViewController *reviewEstimateViewController;

- (IBAction)add:(id)sender;

@end
