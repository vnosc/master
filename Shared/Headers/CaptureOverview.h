//
//  CaptureOverview.h
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "CapturePicture.h"
#import "MeasureOverview.h"

#import "PatientRecord.h"
#import "PatientSearch.h"
#import "SupplyFrameInfo.h"
#import "MBProgressHUD.h"

#import "MemberSearch.h"

@interface CaptureOverview : BackgroundViewController
{
    int _patientId;
}
@property (retain, nonatomic) IBOutlet UITextField *txtPatientName;
@property (retain, nonatomic) IBOutlet UITextField *txtMemberId;
@property (retain, nonatomic) IBOutlet UIImageView *imageView1;
@property (retain, nonatomic) IBOutlet UIImageView *imageView2;
@property (retain, nonatomic) IBOutlet UIImageView *imageView3;
@property (retain, nonatomic) IBOutlet UIImageView *imageView4;
@property (retain, nonatomic) IBOutlet NSArray* imageViews;
@property (retain, nonatomic) IBOutlet NSMutableArray* imageModified;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel1;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel2;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel3;
@property (retain, nonatomic) IBOutlet UILabel *imageLabel4;
@property (retain, nonatomic) IBOutlet UIButton *imageClearBtn1;
@property (retain, nonatomic) IBOutlet UIButton *imageClearBtn2;
@property (retain, nonatomic) IBOutlet UIButton *imageClearBtn3;
@property (retain, nonatomic) IBOutlet UIButton *imageClearBtn4;

@property (retain, nonatomic) IBOutlet UIView *frameInfo;
@property (retain, nonatomic) IBOutlet UITextField *frameMfr;
@property (retain, nonatomic) IBOutlet UITextField *frameModel;
@property (retain, nonatomic) IBOutlet UITextField *frameType;
@property (retain, nonatomic) IBOutlet UITextField *frameColor;
@property (retain, nonatomic) IBOutlet UITextField *frameABox;
@property (retain, nonatomic) IBOutlet UITextField *frameBBox;
@property (retain, nonatomic) IBOutlet UITextField *frameED;
@property (retain, nonatomic) IBOutlet UITextField *frameDBL;

@property (retain, nonatomic) NSMutableArray* vcQueue;

@property (retain, nonatomic) IBOutlet CapturePicture* captureVC;
@property (retain) NSArray* suffixes;
@property (retain) NSArray* measureTexts;

@property (nonatomic) int selectedImageView;

@property (assign) BOOL wantsToFinish;

@property (retain, nonatomic) MBProgressHUD* HUD;

- (void) getLatestPatientFromService;
- (void) loadPatientData:(ServiceObject *)patient;
- (void)loadPatientImages:(id)sender;
- (void) getFrameInfoFromService;
- (void) loadFrameData:(ServiceObject *)frame;

- (void) uploadImagesAndFinish:(id)sender;

- (BOOL) validatePatient;
- (BOOL) validateFrame;

- (BOOL) validateAll;
- (void) validateAllAndFinish;

- (IBAction)touchImage:(id)sender;
- (IBAction)clearImage:(id)sender;
- (IBAction)touchFrameInfo:(id)sender;

- (IBAction)saveAndContinue:(id)sender;

@end
