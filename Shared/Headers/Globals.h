//
//  Globals.h
//  CyberImaging
//
//  Created by Troy Potts on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceObject.h"

int providerId = 0;
ServiceObject* mobileSessionXML;
ServiceObject* providerXML;
ServiceObject* memberXML;
ServiceObject* patientXML;
ServiceObject* prescriptionXML;
ServiceObject* frameXML;
ServiceObject* lensTypeXML;
ServiceObject* materialXML;

NSString* lensBrandName;
NSString* lensDesignName;

UIImage* patientImage1;
UIImage* patientImageProg;

int progressiveDesignId = 0;
UIColor* selectedMaterialColor;

NSArray* patientImages;
NSArray* patientImagesMeasured;

int blendMode = kCGBlendModeNormal;

@interface Globals : NSObject

@end
