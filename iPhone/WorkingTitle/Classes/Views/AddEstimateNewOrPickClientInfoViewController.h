//
//  AddEstimateNewOrPickViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-04-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewClientInfoViewController;
@class ClientInfosViewController;

@interface AddEstimateNewOrPickClientInfoViewController : UITableViewController {
	NewClientInfoViewController *newClientInfoViewController;
	ClientInfosViewController *clientInfosViewController;
}

@property (nonatomic, retain) IBOutlet NewClientInfoViewController *newClientInfoViewController;
@property (nonatomic, retain) IBOutlet ClientInfosViewController *clientInfosViewController;

- (IBAction)cancel:(id)sender;

@end
