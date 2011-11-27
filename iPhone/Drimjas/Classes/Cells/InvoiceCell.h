//
//  InvoiceCell.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-27.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceCell : UITableViewCell {
    UILabel *clientName;
    UILabel *orderNumber;
    UILabel *paid;
}

@property (nonatomic, strong) IBOutlet UILabel *clientName;
@property (nonatomic, strong) IBOutlet UILabel *orderNumber;
@property (nonatomic, strong) IBOutlet UILabel *paid;

@end
