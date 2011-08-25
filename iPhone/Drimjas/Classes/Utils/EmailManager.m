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
// Utils
#import "PDFManager.h"


@implementation EmailManager

#pragma mark -
#pragma mark Mail compose delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error {
	// hide mail compose view
	[_delegate dismissModalViewControllerAnimated:YES];
	// notify delegate of mail outcome
	[_delegate mailSent:result withError:error];
	// release memory of this shortlived instance
	[self release];
}

#pragma mark -
#pragma mark Private messsage implementation

- (id) initWithDelegate:(UIViewController<MailNotifyDelegate>*)newDelegate {
	self = [super init];
	if (self) {
		_delegate = [newDelegate retain];
	}
	return self;
}

- (void)dealloc {
	[_delegate release];
	[super dealloc];
}

#pragma mark -
#pragma mark Public protocol implementation

+ (BOOL)isMailAvailable {
	return [MFMailComposeViewController canSendMail];
}

+ (void)mailEstimate:(Estimate *)estimate withDelegate :(UIViewController<MailNotifyDelegate>*)delegate {
	EmailManager* emailManager = [[EmailManager alloc] initWithDelegate:delegate];
	
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	
	// FIXME not delegate but something that implement mailComposeController
	controller.mailComposeDelegate = emailManager;
	
	[controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"Estimate #%@", "Estimate Mail Subject"),
													  estimate.orderNumber]];
	
	NSArray *toRecepients = estimate.clientInfo.toRecipients;
	[controller setToRecipients:toRecepients];
	
	// attach estimate PDF to email
	NSData *pdfData = [[PDFManager pdfDataForEstimate:estimate] retain];
	NSString *pdfName = [PDFManager pdfNameForEstimate:estimate];
	[controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfName];
	
	NSString *emailBody = NSLocalizedString(@"Estimate Email Body", @"Estimate Email Body");
	[controller setMessageBody:emailBody isHTML:NO];
	
	[delegate presentModalViewController:controller animated:YES];
	[controller release];
	[pdfData release];
}

+ (void)mailContract:(Contract *)contract withDelegate :(UIViewController<MailNotifyDelegate>*)delegate {
	EmailManager* emailManager = [[EmailManager alloc] initWithDelegate:delegate];

	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];

	// FIXME not delegate but something that implement mailComposeController
	controller.mailComposeDelegate = emailManager;

	[controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"Contract #%@", "Contract Mail Subject"),
													  contract.estimate.orderNumber]];

	NSArray *toRecepients = contract.estimate.clientInfo.toRecipients;
	[controller setToRecipients:toRecepients];

	// attach estimate PDF to email
	NSData *pdfData = [[PDFManager pdfDataForContract:contract] retain];
	NSString *pdfName = [PDFManager pdfNameForContract:contract];
	[controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfName];

	NSString *emailBody = NSLocalizedString(@"Contract Email Body", @"Contract Email Body");
	[controller setMessageBody:emailBody isHTML:NO];

	[delegate presentModalViewController:controller animated:YES];
	[controller release];
	[pdfData release];
}

@end
