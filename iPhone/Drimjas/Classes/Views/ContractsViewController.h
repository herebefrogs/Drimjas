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

@interface ContractsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NewContractViewController *newContractViewController;
	ContractDetailViewController *contractDetailViewController;

	NSFetchedResultsController *contracts;
}

@property (nonatomic, retain) IBOutlet NewContractViewController *newContractViewController;
@property (nonatomic, retain) IBOutlet ContractDetailViewController *contractDetailViewController;
@property (nonatomic, retain) NSFetchedResultsController *contracts;

- (IBAction)add:(id)sender;

@end
