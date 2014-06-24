//
//  ClientInfosViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-29.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  Apache 2 License
//

#import <UIKit/UIKit.h>

@class ClientInfoDetailViewController;

@interface ClientInfosViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	ClientInfoDetailViewController *clientInfoDetailViewController;
	NSFetchedResultsController *clientInfos;

	BOOL optionsMode;
}

@property (nonatomic, strong) IBOutlet ClientInfoDetailViewController *clientInfoDetailViewController;
@property (nonatomic, strong) NSFetchedResultsController *clientInfos;
@property (nonatomic, assign) BOOL optionsMode;

@end
