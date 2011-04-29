//
//  AddEstimateNewOrPickViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddEstimateClientInfoViewController;

@interface AddEstimateNewOrPickClientInfoViewController : UITableViewController {
	AddEstimateClientInfoViewController *addEstimateClientInfoViewController;
}

@property (nonatomic, retain) IBOutlet AddEstimateClientInfoViewController *addEstimateClientInfoViewController;

- (IBAction)cancel:(id)sender;

@end
