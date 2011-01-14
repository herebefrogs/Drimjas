//
//  EstimatesViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkingTitleAppDelegate;

@interface EstimatesViewController : UITableViewController {
	WorkingTitleAppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet WorkingTitleAppDelegate *appDelegate;

@end
