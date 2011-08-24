//
//  ContractDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-24.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contract;

@interface ContractDetailViewController : UITableViewController {
	Contract *contract;
}

@property (nonatomic, retain) Contract *contract;

@end