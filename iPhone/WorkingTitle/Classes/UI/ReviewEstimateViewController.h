//
//  ReviewEstimateViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Utils
#import "EmailManager.h"
#import "PrintManager.h"


@class Estimate;

@interface ReviewEstimateViewController : UITableViewController <PrintNotifyDelegate, MailNotifyDelegate> {
	Estimate *estimate;
	IBOutlet UIBarButtonItem *emailButton;
	IBOutlet UIBarButtonItem *printButton;
	IBOutlet UIBarButtonItem *spacerButton;
}

@property (nonatomic, retain) Estimate *estimate;

- (IBAction)email:(id)sender;
- (IBAction)print:(id)sender;

@end
