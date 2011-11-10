//
//  PDFViewController.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-09.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import "PDFViewController.h"

@implementation PDFViewController

@synthesize webView;
@synthesize pdfData;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"PDF Preview", "PDF View Controller Navigation Item Title");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.webView loadData:self.pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-16" baseURL:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.webView = nil;
    self.pdfData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
