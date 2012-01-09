//
//  CaptureOverview.h
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ASIFormDataRequest.h"

#import "MBProgressHUD.h"

#import "MeasurePicture.h"
#import "MeasureWrapAngle.h"

@interface MeasureOverview : BackgroundViewController

@property (retain, nonatomic) IBOutlet UITextField *txtPatientName;
@property (retain, nonatomic) IBOutlet UITextField *txtMemberId;
@property (retain, nonatomic) IBOutlet UIImageView *imageView1;
@property (retain, nonatomic) IBOutlet UIImageView *imageView2;
@property (retain, nonatomic) IBOutlet UIImageView *imageView3;
@property (retain, nonatomic) IBOutlet UIImageView *imageView4;
@property (retain, nonatomic) IBOutlet NSArray* imageViews;

@property (retain, nonatomic) IBOutlet UITextField *txtRightDistPD;
@property (retain, nonatomic) IBOutlet UITextField *txtLeftDistPD;
@property (retain, nonatomic) IBOutlet UITextField *txtRightNearPD;
@property (retain, nonatomic) IBOutlet UITextField *txtLeftNearPD;
@property (retain, nonatomic) IBOutlet UITextField *txtRightHeight;
@property (retain, nonatomic) IBOutlet UITextField *txtLeftHeight;
@property (retain, nonatomic) IBOutlet UITextField *txtPantho;
@property (retain, nonatomic) IBOutlet UITextField *txtVertex;
@property (retain, nonatomic) IBOutlet UITextField *txtWrap;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel1;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel2;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel3;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel4;

@property (retain, nonatomic) IBOutlet UIView *measureDetailView;
@property (retain, nonatomic) IBOutlet MeasurePicture* measureVC;

@property (assign) int measureType;

@property (retain) NSArray* suffixes;
@property (retain) NSArray* measureTexts;
@property (nonatomic) int selectedImageView;

@property (retain, nonatomic) MBProgressHUD* HUD;

- (void) getLatestPatientFromService;
- (void) loadPatientData:(ServiceObject *)patient;

- (void) getLatestPrescriptionFromService;
- (void) loadPrescription:(ServiceObject *)patient;

- (void)measurementDone:(NSNotification*)n;

- (void) uploadImages:(id)sender;

- (IBAction)touchImage:(id)sender;
- (IBAction)wrapAngleBtnClicked:(id)sender;

- (IBAction)saveAndContinue:(id)sender;

- (BOOL) validateMeasurementValue:(UITextField *)textField showAlert:(BOOL)showAlert;

@end
