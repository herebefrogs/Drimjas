//
//  EstimatesViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewOrPickClientInfoViewController;
@class EstimateDetailViewController;

@interface EstimatesViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NewOrPickClientInfoViewController *aNewOrPickClientInfoViewController;
	EstimateDetailViewController *estimateDetailViewController;
	NSFetchedResultsController *estimates;
}

@property (nonatomic, strong) IBOutlet NewOrPickClientInfoViewController *aNewOrPickClientInfoViewController;
@property (nonatomic, strong) IBOutlet EstimateDetailViewController *estimateDetailViewController;
@property (nonatomic, strong) IBOutlet NSFetchedResultsController *estimates;

- (IBAction)add:(id)sender;

@end
