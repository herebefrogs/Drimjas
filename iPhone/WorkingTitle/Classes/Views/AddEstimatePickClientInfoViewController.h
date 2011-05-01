//
//  AddEstimatePickClientInfoViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddEstimateReviewClientInfoViewController;

@interface AddEstimatePickClientInfoViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *clientInfos;
	AddEstimateReviewClientInfoViewController *reviewClientInfoViewController;
}

@property (nonatomic, retain) NSFetchedResultsController *clientInfos;
@property (nonatomic, retain) IBOutlet AddEstimateReviewClientInfoViewController *reviewClientInfoViewController;

@end
