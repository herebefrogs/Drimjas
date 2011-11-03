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
	NewContractViewController *aNewContractViewController;
	ContractDetailViewController *contractDetailViewController;

	NSFetchedResultsController *contracts;
}

@property (nonatomic, strong) IBOutlet NewContractViewController *aNewContractViewController;
@property (nonatomic, strong) IBOutlet ContractDetailViewController *contractDetailViewController;
@property (nonatomic, strong) NSFetchedResultsController *contracts;

- (IBAction)add:(id)sender;

@end
