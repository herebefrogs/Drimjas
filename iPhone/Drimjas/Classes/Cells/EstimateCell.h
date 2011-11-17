//
//  StatusCell.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-16.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstimateCell : UITableViewCell {
    UILabel *clientName;
    UILabel *orderNumber;
    UILabel *status;
}

@property (nonatomic, strong) IBOutlet UILabel *clientName;
@property (nonatomic, strong) IBOutlet UILabel *orderNumber;
@property (nonatomic, strong) IBOutlet UILabel *status;

@end
