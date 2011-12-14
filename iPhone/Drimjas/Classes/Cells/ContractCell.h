//
//  ContractCell.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-15.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContractsViewController;

@interface ContractCell : UITableViewCell {
    UILabel *clientName;
    UILabel *orderNumber;

	BOOL wasShowingDeleteButton;
	ContractsViewController *contractsViewController;
}

@property (nonatomic, strong) IBOutlet UILabel *clientName;
@property (nonatomic, strong) IBOutlet UILabel *orderNumber;
@property (nonatomic, strong) IBOutlet ContractsViewController *contractsViewController;

@end
