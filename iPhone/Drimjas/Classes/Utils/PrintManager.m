//
//  PrintManager.m
//  Drimjas
//
//  Created by Jerome Lecomte on 11-02-06.
//  Copyright 2011 David J Peacock Photography. All rights reserved.
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
	_delegate = [delegate retain];

	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.jobName = [PDFManager getPDFNameForEstimate:estimate];
	printInfo.outputType = UIPrintInfoOutputGeneral;
	printInfo.orientation = UIPrintInfoOrientationPortrait;
	printInfo.duplex = UIPrintInfoDuplexLongEdge;

	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	controller.printInfo = printInfo;

	// set printing data
	controller.printingItem = [PDFManager getPDFDataForEstimate:estimate];

	// print completion handler/block/closure
	void (^printCompleted)(UIPrintInteractionController *, BOOL, NSError *) =
			^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {

		// notify delegate of print outcome
		[_delegate printJobCompleted:completed withError:error];
		// free up delegate
		[_delegate release];
		// free up pdf data
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
