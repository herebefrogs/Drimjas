//
//  AddEstimateReviewClientInfoViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-05-01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientInformation;

@interface AddEstimateReviewClientInfoViewController : UITableViewController {
	ClientInformation *clientInfo;
}

@property (nonatomic, retain) ClientInformation *clientInfo;

@end
