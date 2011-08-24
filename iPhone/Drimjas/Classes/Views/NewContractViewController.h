//
//  NewContractViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-23.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewContractViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *estimates;
}

@property (nonatomic, retain) NSFetchedResultsController *estimates;

@end
