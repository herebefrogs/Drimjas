//
//  EstimatesViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkingTitleAppDelegate;
@class AddEstimateViewController;
@class ReviewEstimateViewController;

@interface EstimatesViewController : UITableViewController {
	IBOutlet WorkingTitleAppDelegate *appDelegate;
	IBOutlet AddEstimateViewController *addEstimateViewController;
	IBOutlet ReviewEstimateViewController *reviewEstimateViewController;
}

- (IBAction)add:(id)sender;
- (void)addEstimateWithClientName:(NSString *)newClientName;

@end
