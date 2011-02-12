//
//  PrintManager.m
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-02-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrintManager.h"
// API
#import "Estimate.h"
// Utils
#import "PDFManager.h"

@implementation PrintManager

#pragma mark -
#pragma mark Public protocol implementation

+ (BOOL)isPrintingAvailable {
	return [UIPrintInteractionController isPrintingAvailable];
}

static id<PrintNotifyDelegate> _delegate;


+ (void)printEstimate:(Estimate *)estimate withDelegate:(id<PrintNotifyDelegate>)delegate {
	// first save the estimate as PDF
	[PDFManager savePDFForEstimate:estimate];

	_delegate = [delegate retain];

	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.jobName = [PDFManager getPDFNameForEstimate:estimate];
	printInfo.outputType = UIPrintInfoOutputGeneral;
	printInfo.orientation = UIPrintInfoOrientationPortrait;
	printInfo.duplex = UIPrintInfoDuplexLongEdge;

	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	controller.printInfo = printInfo;

	// set printing data
	controller.printingItem = [NSURL fileURLWithPath:[PDFManager getPDFPathForEstimate:estimate]];

	// print completion handler/block/closure
	void (^printCompleted)(UIPrintInteractionController *, BOOL, NSError *) =
			^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
		// notify delegate of print outcome
		[_delegate printJobCompleted:completed withError:error];
		// free up delegate
		[_delegate release];
	};

/* Detect if iPad or iPhone to share same codebase	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[controller presentFromBarButtonItem:self.printButton animated:YES
					completionHandler:handler];
	} else { */
	[controller presentAnimated:YES completionHandler:printCompleted];
/*	} */	
}

@end
