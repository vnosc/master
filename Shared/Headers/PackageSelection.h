//
//  PackageSelection.h
//  CyberImaging
//
//  Created by Troy Potts on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListsTableViewController.h"
#import "PatientPrescription.h"

#import <QuartzCore/QuartzCore.h>

@interface PackageSelection : BackgroundViewController
@property (retain, nonatomic) IBOutlet UIScrollView *packageSelectorView;
@property (retain, nonatomic) IBOutlet UIView *packageSelectorTestView;
@property (retain, nonatomic) IBOutlet UIToolbar *toolbar;
@property (retain, nonatomic) IBOutlet UIImageView *frameView;
@property (retain, nonatomic) IBOutlet UIImageView *patientPreview;
@property (retain, nonatomic) IBOutlet UIScrollView *frameSelectorView;
@property (retain, nonatomic) IBOutlet UIView *frameSelectorContent;
@property (retain, nonatomic) IBOutlet UIView *frameInfoView;
@property (retain, nonatomic) IBOutlet UIView *packageInfoView;
@property (retain, nonatomic) IBOutlet UIView *priceView;
@property (retain, nonatomic) IBOutlet UITextField *txtPatientName;
@property (retain, nonatomic) IBOutlet UITextField *txtMemberId;
@property (retain, nonatomic) IBOutlet UIView *colorView;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *colorBtn;
@property (retain, nonatomic) IBOutlet UILabel *frameNameLabel;

@property (retain, nonatomic) IBOutlet UIView *mainSectionView;
@property (retain, nonatomic) IBOutlet SVSegmentedControl *lensTypeBar;
@property (retain, nonatomic) IBOutlet SVSegmentedControl *packageBar;

@property (retain, nonatomic) IBOutlet UITextField *rSphere;
@property (retain, nonatomic) IBOutlet UITextField *rCylinder;
@property (retain, nonatomic) IBOutlet UITextField *rAxis;
@property (retain, nonatomic) IBOutlet UITextField *rAddition;
@property (retain, nonatomic) IBOutlet UITextField *rPrism1;
@property (retain, nonatomic) IBOutlet UITextField *rBase1;
@property (retain, nonatomic) IBOutlet UITextField *rPrism2;
@property (retain, nonatomic) IBOutlet UITextField *rBase2;

@property (retain, nonatomic) IBOutlet UITextField *lSphere;
@property (retain, nonatomic) IBOutlet UITextField *lCylinder;
@property (retain, nonatomic) IBOutlet UITextField *lAxis;
@property (retain, nonatomic) IBOutlet UITextField *lAddition;
@property (retain, nonatomic) IBOutlet UITextField *lPrism1;
@property (retain, nonatomic) IBOutlet UITextField *lBase1;
@property (retain, nonatomic) IBOutlet UITextField *lPrism2;
@property (retain, nonatomic) IBOutlet UITextField *lBase2;

@property (retain, nonatomic) IBOutlet UILabel *frameABox;
@property (retain, nonatomic) IBOutlet UILabel *frameBBox;
@property (retain, nonatomic) IBOutlet UILabel *frameED;
@property (retain, nonatomic) IBOutlet UILabel *frameDBL;
@property (retain, nonatomic) IBOutlet UILabel *frameTemple;
@property (retain, nonatomic) IBOutlet UILabel *frameMfr;
@property (retain, nonatomic) IBOutlet UILabel *frameTypeLabel;
@property (retain, nonatomic) IBOutlet UILabel *frameCollection;
@property (retain, nonatomic) IBOutlet UILabel *frameGender;
@property (retain, nonatomic) IBOutlet UILabel *frameColorLabel;

@property (retain, nonatomic) IBOutlet ListsTableViewController *materialList;
@property (retain) NSString *fontName;
@property (retain) UIFont *smallFont;
- (IBAction)selectAndContinue:(id)sender;

@property (retain) NSMutableArray *frmNames;
@property (retain) NSMutableArray *frmIds;
@property (retain) NSMutableArray *lensTypeIds;
@property (retain) NSMutableArray *packageIds;

@property (retain) ServiceObject *packageInfo;

@property (assign) NSInteger selectedFrameIndex;
@property (assign) NSInteger selectedFrameId;
@property (assign) NSInteger selectedPackageId;

@property (assign) BOOL hasSelectedLensType;
@property (assign) BOOL hasSelectedPackageType;
@property (retain, nonatomic) MBProgressHUD* HUD;
@property (retain, nonatomic) IBOutlet UILabel *retailPriceLbl;
@property (retain, nonatomic) IBOutlet UILabel *vspPriceLbl;
@property (retain, nonatomic) IBOutlet UILabel *savingsLbl;

//@property (retain) NSDictionary

- (IBAction)clickSingleVision:(id)sender;
- (IBAction)frameImagePopup:(id)sender;

- (void) updateAllPackageInfo;
- (void) loadAllDataByPackage;
- (void) loadFramesByPackage:(int)packageId;

- (void) selectFrame:(int)frameId;
- (void) selectFrameAtIndex:(int)frameIdx;

- (void) setUpOptionListForMaterial:(int)materialId;
- (void) setUpColorsForFrame:(int)frameId;

- (void)listsTableSelected:(NSNotification*)n;
- (void)listsTableSelectionCleared:(NSNotification*)n;

- (UIImage*)getFrameImage:(int)frameId;

- (void) getLatestPrescriptionFromService;
- (void) getLatestPatientFromService;
- (void) loadPrescription:(ServiceObject *)prescription;

- (NSString*) getField:(NSString*)fieldName forFrameId:(int)frameId;

@end
