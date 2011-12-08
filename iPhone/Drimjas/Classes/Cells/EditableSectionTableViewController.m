//
//  EditableSectionTableViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-07.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "EditableSectionTableViewController.h"
// Cells
#import "EditableSectionHeaderView.h"


@implementation EditableSectionTableViewController

@synthesize editableSectionHeaderView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.editableSectionHeaderView = nil;
}


- (UIView *)configureViewForHeaderInSection:(NSInteger)section withTitle:(NSString *)title
{
    EditableSectionHeaderView *view = nil;

    if (view == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EditableSectionHeaderView" owner:self options:nil];
        view = editableSectionHeaderView;
        self.editableSectionHeaderView = nil;
    }

    view.header.text = NSLocalizedString(title, "");
    [view.edit setTitle:NSLocalizedString(@"Edit", "") forState:UIControlStateNormal];
    view.edit.tag = section;

    // round up the Edit button's corners
    CALayer *layer = view.edit.layer;
    layer.cornerRadius = 6.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;

    return view;
}

@end