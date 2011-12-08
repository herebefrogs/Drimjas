//
//  ContractDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-08-24.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "DetailTableViewController.h"


@class Contract;

@interface ContractDetailViewController : DetailTableViewController {
	Contract *contract;
	NSInteger indexFirstLineItem;
	NSInteger indexLastSection;
	NSArray *lineItemSelections;
}

@property (nonatomic, strong) Contract *contract;

@end
