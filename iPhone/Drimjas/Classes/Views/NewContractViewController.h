//
//  NewContractViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-23.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>

@class ContractDetailViewController;

@interface NewContractViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	ContractDetailViewController *contractDetailViewController;

	NSFetchedResultsController *estimates;
}

@property (nonatomic, strong) IBOutlet ContractDetailViewController *contractDetailViewController;
@property (nonatomic, strong) NSFetchedResultsController *estimates;

@end
