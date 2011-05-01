//
//  AddEstimateLineItemsViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddEstimateLineItemsViewController : UITableViewController {
	UIBarButtonItem *nextButton;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;

- (IBAction)next:(id)sender;

@end
