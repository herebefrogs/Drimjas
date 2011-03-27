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
	UIBarButtonItem *emailButton;
	UIBarButtonItem *printButton;
	UIBarButtonItem *spacerButton;
}

@property (nonatomic, retain) Estimate *estimate;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *emailButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *printButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *spacerButton;

- (IBAction)email:(id)sender;
- (IBAction)print:(id)sender;

@end