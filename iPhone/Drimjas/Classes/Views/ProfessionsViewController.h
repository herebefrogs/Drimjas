//
//  ProfessionsViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-10-17.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyInfo;

@interface ProfessionsViewController : UITableViewController {
@private
    NSArray *professions;
    MyInfo *myInfo;
}

@property (nonatomic, retain) MyInfo *myInfo;

@end
