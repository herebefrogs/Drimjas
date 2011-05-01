//
//  AddEstimateNewOrPickViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddEstimateNewClientInfoViewController;
@class AddEstimatePickClientInfoViewController;

@interface AddEstimateNewOrPickClientInfoViewController : UITableViewController {
	AddEstimateNewClientInfoViewController *newClientInfoViewController;
	AddEstimatePickClientInfoViewController *pickClientInfoViewController;
}

@property (nonatomic, retain) IBOutlet AddEstimateNewClientInfoViewController *newClientInfoViewController;
@property (nonatomic, retain) IBOutlet AddEstimatePickClientInfoViewController *pickClientInfoViewController;

- (IBAction)cancel:(id)sender;

@end
