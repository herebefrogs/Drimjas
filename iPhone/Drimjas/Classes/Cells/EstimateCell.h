//
//  EstimateCell.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-16.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EstimatesViewController;

@interface EstimateCell : UITableViewCell {
    UILabel *clientName;
    UILabel *orderNumber;
    UILabel *status;

	BOOL wasShowingDeleteButton;
	EstimatesViewController *estimatesViewController;
}

@property (nonatomic, strong) IBOutlet UILabel *clientName;
@property (nonatomic, strong) IBOutlet UILabel *orderNumber;
@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet EstimatesViewController *estimatesViewController;

@end
