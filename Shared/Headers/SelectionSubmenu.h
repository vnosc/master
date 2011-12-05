//
//  SelectionSubmenu.h
//  CyberImaging
//
//  Created by Troy Potts on 10/31/11.
//  Copyright 2011 Pro Fit Optix. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeView.h"

#import "Lenses.h"

#import "FrameSelectionandValidationNew.h"
#import "LensSelectionandValidation.h"
#import "LensOptionSelection.h"
#import "PatientPrescription.h"
#import "PatientSearch.h"
#import "SelectSpech.h"

#import "MainViewController.h"

@interface SelectionSubmenu : BackgroundViewController <UITabBarControllerDelegate>{
	
	MainViewController *mainview;
	
	FrameSelectionandValidationNew *frameselect;
	Lenses *framevalidate;
	Adjust *lensselect;
	CreateUser *lensvalidate;
	
	FrameSelectionandValidationNew *frameVC;
	LensSelectionandValidation *lensMaterialVC;
	LensOptionSelection *lensOptionVC;
	PatientPrescription *patientVC;
	SelectSpech *frameTryonVC;
	
	UITabBarController *tabbar;
	UITabBarController *tabbar2;
	
	IBOutlet UIButton *frameBtn;
	IBOutlet UIButton *lensMaterialBtn;
	IBOutlet UIButton *lensOptionBtn;
	IBOutlet UIButton *patientBtn;
	IBOutlet UIButton *frameTryonBtn;
	
	IBOutlet UIButton *backBtn;
}

@property (nonatomic,retain) MainViewController *mainview;

@property (nonatomic,retain) FrameSelectionandValidationNew *frameVC;
@property (nonatomic,retain) LensSelectionandValidation *lensMaterialVC;
@property (nonatomic,retain) LensOptionSelection *lensOptionVC;
@property (nonatomic,retain) PatientPrescription *patientVC;
@property (nonatomic,retain) SelectSpech *frameTryonVC;

-(IBAction) frameBtnClick:(id)sender;
-(IBAction) lensMaterialBtnClick:(id)sender;
-(IBAction) lensOptionBtnClick:(id)sender;
-(IBAction) patientBtnClick:(id)sender;
-(IBAction) frameTryonBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;

@end

