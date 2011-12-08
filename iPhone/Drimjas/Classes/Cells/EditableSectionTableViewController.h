//
//  EditableSectionTableViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-07.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditableSectionHeaderView;

@protocol EditableSectionDelegate

@optional
- (IBAction)modify:(id)sender;

@end


@interface EditableSectionTableViewController : UITableViewController <EditableSectionDelegate> {
    EditableSectionHeaderView *editableSectionHeaderView;
}

@property (nonatomic, strong) IBOutlet EditableSectionHeaderView *editableSectionHeaderView;
- (UIView *)configureViewForHeaderInSection:(NSInteger)section withTitle:(NSString *)title;


@end

