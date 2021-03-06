//
//  EditableSectionTableViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-07.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "DetailTableViewController.h"
// Utils
#import "EmailManager.h"
#import "PrintManager.h"
// Cells
#import "EditableSectionHeaderView.h"
// Views
#import "PDFViewController.h"


@implementation DetailTableViewController

@synthesize emailButton;
@synthesize printButton;
@synthesize pdfButton;
@synthesize spacerButton;
@synthesize pdfViewController;
@synthesize mailComposeViewController;
@synthesize editableSectionHeaderView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray *items = [NSMutableArray arrayWithObjects: spacerButton, pdfButton, nil];
	if ([EmailManager isMailAvailable]) {
		// add Email button only if mail is available on iPhone
		[items addObject:emailButton];
	}
	if ([PrintManager isPrintingAvailable]) {
		// add Print button only if printing is available on iPhone
		[items addObject:printButton];
	}
	[items addObject:spacerButton];
	self.toolbarItems = items;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // show toolbar with animation
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	// hide toolbar with animation
	[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.emailButton = nil;
	self.printButton = nil;
    self.pdfButton = nil;
    self.spacerButton = nil;
	self.toolbarItems = nil;
    self.pdfViewController = nil;
    self.mailComposeViewController = nil;
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