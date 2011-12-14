//
//  ContractsViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewContractViewController;
@class ContractDetailViewController;
@class ContractCell;

@interface ContractsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NewContractViewController *aNewContractViewController;
	ContractDetailViewController *contractDetailViewController;
	ContractCell *contractCell;

	NSFetchedResultsController *contracts;

	NSIndexPath *deleteIndexPath;
	NSIndexPath *warningIndexPath;
}

@property (nonatomic, strong) IBOutlet NewContractViewController *aNewContractViewController;
@property (nonatomic, strong) IBOutlet ContractDetailViewController *contractDetailViewController;
@property (nonatomic, strong) IBOutlet ContractCell *contractCell;
@property (nonatomic, strong) NSFetchedResultsController *contracts;
@property (nonatomic, strong) NSIndexPath *deleteIndexPath;
@property (nonatomic, strong) NSIndexPath *warningIndexPath;

- (IBAction)add:(id)sender;

- (void)showDeleteWarningForCell:(UITableViewCell *)cell;
- (void)hideDeleteWarningForCell:(UITableViewCell *)cell;

@end
