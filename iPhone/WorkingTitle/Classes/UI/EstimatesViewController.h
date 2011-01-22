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
	WorkingTitleAppDelegate *appDelegate;
	AddEstimateViewController *addEstimateViewController;
	ReviewEstimateViewController *reviewEstimateViewController;
}

@property (nonatomic, retain) IBOutlet WorkingTitleAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet AddEstimateViewController *addEstimateViewController;
@property (nonatomic, retain) IBOutlet ReviewEstimateViewController *reviewEstimateViewController;

- (IBAction)add:(id)sender;
- (void)addEstimateWithClientName:(NSString *)newClientName;
- (void)reviewEstimateAtIndex:(NSInteger)index;

@end
