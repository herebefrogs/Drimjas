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

+ (void)printEstimate:(Estimate *)estimate withHandlerWhenDone:(UIPrintInteractionCompletionHandler)handler {
	// first save the estimate as PDF
	[PDFManager savePDFForEstimate:estimate];
	
	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.jobName = [PDFManager getPDFNameForEstimate:estimate];
	printInfo.outputType = UIPrintInfoOutputGeneral;
	printInfo.orientation = UIPrintInfoOrientationPortrait;
	printInfo.duplex = UIPrintInfoDuplexLongEdge;
	
	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	controller.printInfo = printInfo;
	
	// set printing data
	controller.printingItem = [NSURL fileURLWithPath:[PDFManager getPDFPathForEstimate:estimate]];
	
/* Detect if iPad or iPhone to share same codebase	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[controller presentFromBarButtonItem:self.printButton animated:YES
					completionHandler:handler];
	} else { */
	[controller presentAnimated:YES completionHandler:handler];
/*	} */	
}

@end
