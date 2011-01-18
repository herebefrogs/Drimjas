//
//  ReviewEstimateViewController.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Estimate;

@interface ReviewEstimateViewController : UITableViewController {
	Estimate *estimate;
}

@property (nonatomic, retain) Estimate *estimate;

@end
