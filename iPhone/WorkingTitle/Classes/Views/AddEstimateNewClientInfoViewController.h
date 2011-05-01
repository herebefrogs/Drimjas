//
//  AddEstimateViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cells
#import "TextFieldTableViewController.h"

@class AddEstimateContactInfoViewController;
@class Estimate;

@interface AddEstimateNewClientInfoViewController : TextFieldTableViewController {
	UIBarButtonItem *nextButton;
	AddEstimateContactInfoViewController *contactInfoViewController;

	Estimate *estimate;	// new estimate being created
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet AddEstimateContactInfoViewController *contactInfoViewController;

@property (nonatomic, retain) Estimate *estimate;

- (IBAction)next:(id)sender;

@end
