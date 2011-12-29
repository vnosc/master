//
//  TestsPage.h
//  CyberImaging
//
//  Created by Troy Potts on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OpenCVTesting.h"
#import "PackageSelection.h"
#import "BillingTypeSelection.h"
#import "FrameStyling.h"
#import "SupplyFrameInfo.h"

#import "LensIndexView.h"
#import "HomePage.h"
#import "MeasureWrapAngle.h"

@interface TestsPage : BackgroundViewController
- (IBAction)openCVTestingClick:(id)sender;
- (IBAction)packageSelectionClick:(id)sender;
- (IBAction)billingTypeSelectionClick:(id)sender;
- (IBAction)frameStylingClick:(id)sender;
- (IBAction)supplyFrameInfo:(id)sender;
- (IBAction)patientConsultationClick:(id)sender;
- (IBAction)mainMenuRecreationClick:(id)sender;
- (IBAction)wrapAngleMeasureClick:(id)sender;

@end
