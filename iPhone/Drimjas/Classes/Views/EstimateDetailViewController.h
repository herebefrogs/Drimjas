//
//  EstimateDetailViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-17.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <UIKit/UIKit.h>
// Cells
#import "DetailTableViewController.h"


@class Estimate;
@class AddEstimateLineItemsViewController;
@class ContactInfosViewController;
@class NewClientInfoViewController;
@class PDFViewController;

@interface EstimateDetailViewController : DetailTableViewController {
	AddEstimateLineItemsViewController *lineItemSelectionsViewController;
	ContactInfosViewController *contactInfosViewController;
	NewClientInfoViewController *aNewClientInfoViewController;

	Estimate *estimate;
@private
	NSInteger indexFirstLineItem;
	NSInteger indexLastSection;
	NSArray *lineItemSelections;
}

@property (nonatomic, strong) IBOutlet AddEstimateLineItemsViewController *lineItemSelectionsViewController;
@property (nonatomic, strong) IBOutlet ContactInfosViewController *contactInfosViewController;
@property (nonatomic, strong) IBOutlet NewClientInfoViewController *aNewClientInfoViewController;
@property (nonatomic, strong) Estimate *estimate;

@end
