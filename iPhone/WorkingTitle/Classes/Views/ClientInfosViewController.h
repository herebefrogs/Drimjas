//
//  ClientInfosViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientInfoDetailViewController;

@interface ClientInfosViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	ClientInfoDetailViewController *clientInfoDetailViewController;
	NSFetchedResultsController *clientInfos;

	BOOL optionsMode;
}

@property (nonatomic, retain) IBOutlet ClientInfoDetailViewController *clientInfoDetailViewController;
@property (nonatomic, retain) NSFetchedResultsController *clientInfos;
@property (nonatomic, assign) BOOL optionsMode;

@end
