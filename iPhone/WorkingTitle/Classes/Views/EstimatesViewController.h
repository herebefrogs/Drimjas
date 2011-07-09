//
//  EstimatesViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddEstimateNewOrPickClientInfoViewController;
@class EstimateDetailViewController;

@interface EstimatesViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	AddEstimateNewOrPickClientInfoViewController *newOrPickClientInfoViewController;
	EstimateDetailViewController *estimateDetailViewController;
	NSFetchedResultsController *estimates;
}

@property (nonatomic, retain) IBOutlet AddEstimateNewOrPickClientInfoViewController *newOrPickClientInfoViewController;
@property (nonatomic, retain) IBOutlet EstimateDetailViewController *estimateDetailViewController;
@property (nonatomic, retain) IBOutlet NSFetchedResultsController *estimates;

- (IBAction)add:(id)sender;

@end
