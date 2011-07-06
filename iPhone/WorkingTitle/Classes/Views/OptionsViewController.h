//
//  OptionsViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-06-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyInfoViewController;

@interface OptionsViewController : UITableViewController {
	MyInfoViewController *myInfoViewController;
}

@property (nonatomic, retain) IBOutlet MyInfoViewController *myInfoViewController;

@end
