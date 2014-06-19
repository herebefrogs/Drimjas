//
//  AddEstimateNewOrPickViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-04-28.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>

@class NewClientInfoViewController;
@class ClientInfosViewController;

@interface NewOrPickClientInfoViewController : UITableViewController {
	NewClientInfoViewController *aNewClientInfoViewController;
	ClientInfosViewController *clientInfosViewController;
}

@property (nonatomic, strong) IBOutlet NewClientInfoViewController *aNewClientInfoViewController;
@property (nonatomic, strong) IBOutlet ClientInfosViewController *clientInfosViewController;

- (IBAction)cancel:(id)sender;

@end
