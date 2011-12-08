//
//  EmailManager.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-02-11.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
//

#import "EmailManager.h"
// API
#import "ClientInfo.h"
#import "Contract.h"
#import "Estimate.h"
#import "Invoice.h"
// Utils
#import "PDFManager.h"


@implementation EmailManager

#pragma mark -
#pragma mark Public protocol implementation

+ (BOOL)isMailAvailable {
	return [MFMailComposeViewController canSendMail];
}

+ (UIViewController *)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
                                                forEstimate:(Estimate *)estimate {
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = delegate;
	
	[controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"Estimate #%@", "Estimate Mail Subject"),
													  estimate.orderNumber]];
	
	NSArray *toRecepients = estimate.clientInfo.toRecipients;
	[controller setToRecipients:toRecepients];
	
	// attach estimate PDF to email
	NSData *pdfData = [PDFManager pdfDataForEstimate:estimate];
	NSString *pdfName = [PDFManager pdfNameForEstimate:estimate];
	[controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfName];
	
	NSString *emailBody = NSLocalizedString(@"Estimate Email Body", @"Estimate Email Body");
	[controller setMessageBody:emailBody isHTML:NO];

    return controller;
}

+ (UIViewController *)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
                                                forContract:(Contract *)contract {
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = delegate;

	[controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"Contract #%@", "Contract Mail Subject"),
													  contract.estimate.orderNumber]];

	NSArray *toRecepients = contract.estimate.clientInfo.toRecipients;
	[controller setToRecipients:toRecepients];

	// attach contract PDF to email
	NSData *pdfData = [PDFManager pdfDataForContract:contract];
	NSString *pdfName = [PDFManager pdfNameForContract:contract];
	[controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfName];

	NSString *emailBody = NSLocalizedString(@"Contract Email Body", @"Contract Email Body");
	[controller setMessageBody:emailBody isHTML:NO];

    return controller;
}

+ (UIViewController *)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
                                                forInvoice:(Invoice *)invoice {
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = delegate;

	[controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"Invoice #%@", "Invoice Mail Subject"),
                                                      invoice.contract.estimate.orderNumber]];

	NSArray *toRecepients = invoice.contract.estimate.clientInfo.toRecipients;
	[controller setToRecipients:toRecepients];

	// attach invoice PDF to email
	NSData *pdfData = [PDFManager pdfDataForInvoice:invoice];
	NSString *pdfName = [PDFManager pdfNameForInvoice:invoice];
	[controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfName];

	NSString *emailBody = NSLocalizedString(@"Invoice Email Body", @"Invoice Email Body");
	[controller setMessageBody:emailBody isHTML:NO];

    return controller;
}

@end
