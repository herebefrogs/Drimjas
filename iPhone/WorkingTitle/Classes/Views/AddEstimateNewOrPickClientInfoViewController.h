//
//  AddEstimateNewOrPickViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddEstimateClientInfoViewController;
@class AddEstimatePickClientInfoViewController;

@interface AddEstimateNewOrPickClientInfoViewController : UITableViewController {
	AddEstimateClientInfoViewController *addEstimateClientInfoViewController;
	AddEstimatePickClientInfoViewController *pickClientInfoViewController;
}

@property (nonatomic, retain) IBOutlet AddEstimateClientInfoViewController *addEstimateClientInfoViewController;
@property (nonatomic, retain) IBOutlet AddEstimatePickClientInfoViewController *pickClientInfoViewController;

- (IBAction)cancel:(id)sender;

@end
