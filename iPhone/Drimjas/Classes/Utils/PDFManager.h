//
//  PDFManager.h
//  Drimjas
//
//  Created by Jerome Lecomte on 11-01-31.
//  Copyright 2014 David J Peacock - david@davidjpeacock.ca.  GPLv3
//

#import <Foundation/Foundation.h>

@class Estimate;
@class Contract;
@class Invoice;

@interface PDFManager : NSObject {

}

+ (BOOL)savePDFFileForEstimate:(Estimate *)estimate;
+ (NSString *)getPDFPathForEstimate:(Estimate *)estimate;


+ (NSMutableData *)pdfDataForEstimate:(Estimate *)estimate;	// PDF content
+ (NSString *)pdfNameForEstimate:(Estimate *)estimate;		// PDF filename
+ (NSString *)pdfTitleForEstimate:(Estimate *)estimate;		// PDF title as appearing in PDF metadata
+ (NSDictionary *)pdfInfoForEstimate:(Estimate *)estimate;	// dictionary of PDF metadata


+ (NSMutableData *)pdfDataForContract:(Contract *)contract;	// PDF content
+ (NSString *)pdfNameForContract:(Contract *)contract;		// PDF filename
+ (NSString *)pdfTitleForContract:(Contract *)contract;		// PDF title as appearing in PDF metadata
+ (NSDictionary *)pdfInfoForContract:(Contract *)contract;	// dictionary of PDF metadata

+ (NSMutableData *)pdfDataForInvoice:(Invoice *)invoice;	// PDF content
+ (NSString *)pdfNameForInvoice:(Invoice *)invoice;			// PDF filename
+ (NSString *)pdfTitleForInvoice:(Invoice *)invoice;		// PDF title as appearing in PDF metadata
+ (NSDictionary *)pdfInfoForInvoice:(Invoice *)invoice;		// dictionary of PDF metadata

@end