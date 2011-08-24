//
//  ContractsViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContractsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *contracts;
}

@property (nonatomic, retain) NSFetchedResultsController *contracts;

@end
