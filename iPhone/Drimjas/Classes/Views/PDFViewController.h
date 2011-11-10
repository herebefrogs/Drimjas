//
//  PDFViewController.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-11-09.
//  Copyright (c) 2011 David J Peacock Photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController {
    UIWebView *webView;
    NSData *pdfData;
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSData *pdfData;

@end
