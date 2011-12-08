//
//  EditableSectionTableViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-12-07.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
// Utils
#import "PrintManager.h"

@class PDFViewController;
@class EditableSectionHeaderView;

@protocol EditableSectionDelegate

@optional
- (IBAction)modify:(id)sender;

@end

@protocol ToolbarItemsDeletage

@optional
- (IBAction)email:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)view:(id)sender;

@end


@interface DetailTableViewController : UITableViewController <MFMailComposeViewControllerDelegate,
                                                              PrintNotifyDelegate,
                                                              EditableSectionDelegate,
                                                              ToolbarItemsDeletage> {
	UIBarButtonItem *emailButton;
	UIBarButtonItem *printButton;
    UIBarButtonItem *pdfButton;
	UIBarButtonItem *spacerButton;

    PDFViewController *pdfViewController;
    UIViewController* mailComposeViewController;

    EditableSectionHeaderView *editableSectionHeaderView;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *emailButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *printButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *pdfButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *spacerButton;

@property (nonatomic, strong) IBOutlet PDFViewController *pdfViewController;
@property (nonatomic, strong) UIViewController *mailComposeViewController;

@property (nonatomic, strong) IBOutlet EditableSectionHeaderView *editableSectionHeaderView;
- (UIView *)configureViewForHeaderInSection:(NSInteger)section withTitle:(NSString *)title;

@end

