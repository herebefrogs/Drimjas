//
//  PrintManager.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-02-06.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import "PrintManager.h"
// API
#import "Contract.h"
#import "Estimate.h"
#import "Invoice.h"
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
	_delegate = delegate;

	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.jobName = [PDFManager pdfNameForEstimate:estimate];
	printInfo.outputType = UIPrintInfoOutputGeneral;
	printInfo.orientation = UIPrintInfoOrientationPortrait;
	printInfo.duplex = UIPrintInfoDuplexLongEdge;

	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	controller.printInfo = printInfo;

	// set printing data
	controller.printingItem = [PDFManager pdfDataForEstimate:estimate];

	// print completion handler/block/closure
	void (^printCompleted)(UIPrintInteractionController *, BOOL, NSError *) =
			^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {

		// notify delegate of print outcome
		[_delegate printJobCompleted:completed withError:error];
	};

/* Detect if iPad or iPhone to share same codebase
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[controller presentFromBarButtonItem:self.printButton animated:YES
					completionHandler:handler];
	} else { */
	[controller presentAnimated:YES completionHandler:printCompleted];
/*	} */
}

+ (void)printContract:(Contract *)contract withDelegate:(id<PrintNotifyDelegate>)delegate {
	_delegate = delegate;

	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.jobName = [PDFManager pdfNameForContract:contract];
	printInfo.outputType = UIPrintInfoOutputGeneral;
	printInfo.orientation = UIPrintInfoOrientationPortrait;
	printInfo.duplex = UIPrintInfoDuplexLongEdge;

	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	controller.printInfo = printInfo;

	// set printing data
	controller.printingItem = [PDFManager pdfDataForContract:contract];

	// print completion handler/block/closure
	void (^printCompleted)(UIPrintInteractionController *, BOOL, NSError *) =
	^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {

		// notify delegate of print outcome
		[_delegate printJobCompleted:completed withError:error];
	};

	/* Detect if iPad or iPhone to share same codebase
	 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	 [controller presentFromBarButtonItem:self.printButton animated:YES
	 completionHandler:handler];
	 } else { */
	[controller presentAnimated:YES completionHandler:printCompleted];
	/*	} */
}

+ (void)printInvoice:(Invoice *)invoice withDelegate:(id<PrintNotifyDelegate>)delegate {
	_delegate = delegate;

	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.jobName = [PDFManager pdfNameForInvoice:invoice];
	printInfo.outputType = UIPrintInfoOutputGeneral;
	printInfo.orientation = UIPrintInfoOrientationPortrait;
	printInfo.duplex = UIPrintInfoDuplexLongEdge;

	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	controller.printInfo = printInfo;

	// set printing data
	controller.printingItem = [PDFManager pdfDataForInvoice:invoice];

	// print completion handler/block/closure
	void (^printCompleted)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
		// notify delegate of print outcome
		[_delegate printJobCompleted:completed withError:error];
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
