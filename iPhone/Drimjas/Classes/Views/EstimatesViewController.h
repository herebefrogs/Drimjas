//
//  EstimatesViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>

@class NewOrPickClientInfoViewController;
@class EstimateDetailViewController;
@class EstimateCell;

@interface EstimatesViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NewOrPickClientInfoViewController *aNewOrPickClientInfoViewController;
	EstimateDetailViewController *estimateDetailViewController;
	NSFetchedResultsController *estimates;
    EstimateCell *estimateCell;

	NSIndexPath *deleteIndexPath;
	NSIndexPath *warningIndexPath;
}

@property (nonatomic, strong) IBOutlet NewOrPickClientInfoViewController *aNewOrPickClientInfoViewController;
@property (nonatomic, strong) IBOutlet EstimateDetailViewController *estimateDetailViewController;
@property (nonatomic, strong) IBOutlet NSFetchedResultsController *estimates;
@property (nonatomic, strong) IBOutlet EstimateCell *estimateCell;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;
@property (nonatomic, strong) NSIndexPath *warningIndexPath;

- (IBAction)add:(id)sender;

- (void)showDeleteWarningForCell:(UITableViewCell *)cell;
- (void)hideDeleteWarningForCell:(UITableViewCell *)cell;

@end
