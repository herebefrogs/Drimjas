//
//  PDFManager.h
//  WorkingTitle
//
//  Created by Jerome Lecomte on 11-01-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Estimate;

@interface PDFManager : NSObject {

}

+ (NSMutableData *)getPDFDataForEstimate:(Estimate *)estimate;
+ (BOOL)savePDFFileForEstimate:(Estimate *)estimate;
+ (NSString *)getPDFNameForEstimate:(Estimate *)estimate;
+ (NSString *)getPDFPathForEstimate:(Estimate *)estimate;

@end
