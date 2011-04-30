//
//  AddEstimatePickClientInfoViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddEstimatePickClientInfoViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *clientInfos;
}

@property (nonatomic, retain) NSFetchedResultsController *clientInfos;

@end
