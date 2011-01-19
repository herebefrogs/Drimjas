//
//  EstimatesViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkingTitleAppDelegate;
@class AddEstimateViewController;

@interface EstimatesViewController : UITableViewController {
	WorkingTitleAppDelegate *appDelegate;
	AddEstimateViewController *addEstimateViewController;
}

@property (nonatomic, retain) IBOutlet WorkingTitleAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet AddEstimateViewController *addEstimateViewController;

- (IBAction)add:(id)sender;
- (void)addEstimateWithClientName:(NSString *)newClientName;

@end
