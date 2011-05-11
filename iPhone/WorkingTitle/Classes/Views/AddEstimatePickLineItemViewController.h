//
//  AddEstimatePickLineItem.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddEstimatePickLineItemViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *lineItems;
}

@property (nonatomic, retain) NSFetchedResultsController *lineItems;

@end
