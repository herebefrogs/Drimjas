//
//  EmailManager.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EmailManager.h"
// API
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
	// first save the estimate as PDF
	[PDFManager savePDFForEstimate:estimate];
	
	EmailManager* emailManager = [[EmailManager alloc] initWithDelegate:delegate];
	
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	
	// FIXME not delegate but something that implement mailComposeController
	controller.mailComposeDelegate = emailManager;
	
	[controller setSubject:[NSString stringWithFormat:@"%@ %@",
							NSLocalizedString(@"Estimate", "Estimate Mail Subject"),
							// TODO use estimate order number instead
							estimate.clientName]];
	
	NSArray *toRecepients = [NSArray arrayWithObjects:@"For Example <for@example.com>", nil];
	[controller setToRecipients:toRecepients];
	
	// attach estimate PDF to email
	NSString *path = [PDFManager getPDFPathForEstimate:estimate];
	NSData *pdfData = [NSData dataWithContentsOfFile:path];
	[controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[PDFManager getPDFNameForEstimate:estimate]];
	
	NSString *emailBody = NSLocalizedString(@"Estimate Email Body", @"Estimate Email Body");
	[controller setMessageBody:emailBody isHTML:NO];
	
	[delegate presentModalViewController:controller animated:YES];
	[controller release];
}

@end
