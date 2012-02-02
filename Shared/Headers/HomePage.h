//
//  HomePage.h
//  CyberImaging
//
//  Created by jay gurudev on 9/22/11.
//  Copyright 2011 software house. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeView.h"
#import "CaptureOverview.h"
#import "Adjust.h"
#import "Lenses.h"
#import "CreateUser.h"
#import "SelectSpech.h"

#import "PatientList.h"

#import "TestsPage.h"

#import "FrameSelectionandValidationNew.h"

#import "MainViewController.h"

#import "SelectionSubmenu.h"


#import "TOTakePhotoView.h"
#import "RXCustomTabBar1.h"
#import "FrameCatelogs.h"

#ifndef HOMEPAGE_H

//#define HOMEPAGE_H

@interface HomePage : BackgroundViewController <UITabBarControllerDelegate>{
	MainViewController *mainview;
	
	CaptureOverview *h;
	Adjust *adjust;
	Lenses *lense;
	CreateUser *createuser;
	SelectSpech *selectspect;
	
	FrameSelectionandValidationNew *frameselect;
	Lenses *framevalidate;
	Adjust *lensselect;
	CreateUser *lensvalidate;
    
    UINavigationController *ncFrameStyling;
    RXCustomTabBar1 *rdx;
	
	UITabBarController *tabbar;
	UITabBarController *tabbar2;
	 
	IBOutlet UIButton *clearSessionBtn;
	IBOutlet UIButton *logoutBtn;
	
	IBOutlet UIButton *unityBtn;
	IBOutlet UIButton *measurementBtn;
	IBOutlet UIButton *patientBtn;
	IBOutlet UIButton *lensOptionBtn;
	IBOutlet UIButton *frameOptionBtn;
	IBOutlet UIButton *framesTryoutBtn;
	IBOutlet UIButton *contactLensSelectionBtn;
	IBOutlet UIButton *patientImageBtn;
}
@property (nonatomic,retain)RXCustomTabBar1 *rdx;
@property (nonatomic,retain) MainViewController *mainview;

@property (nonatomic,retain) CaptureOverview *h;
@property (nonatomic,retain) Adjust *adjust;
@property (nonatomic,retain) Lenses *lense;
@property (nonatomic,retain) CreateUser *createuser;
@property (nonatomic,retain) SelectSpech *selectspect;

@property (nonatomic,retain) FrameSelectionandValidationNew *frameselect;
@property (nonatomic,retain) Lenses *framevalidate;
@property (nonatomic,retain) Adjust *lensselect;
@property (nonatomic,retain) CreateUser *lensvalidate;

@property (retain, nonatomic) IBOutlet UIButton *hackDropDownButton;
@property (retain, nonatomic) IBOutlet UIView *hackDropDownView;
@property (retain, nonatomic) IBOutlet UIView *hackAfterDropDownView;
@property (retain, nonatomic) IBOutlet UIView *hackDropDownView2;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *sectionBtns;
@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *sectionSubmenuViews;
@property (retain, nonatomic) IBOutlet UIButton *testsBtn;

-(IBAction) measurementBtnClick:(id)sender;
- (IBAction)patientCareBtnClick:(id)sender;
-(IBAction) patientBtnClick:(id)sender;
- (IBAction)lifeStyleBtnClick:(id)sender;
-(IBAction) lensOptionBtnClick:(id)sender;
-(IBAction) frameOptionBtnClick:(id)sender;
-(IBAction) framesTryoutBtnClick:(id)sender;
-(IBAction) contactLensSelectionBtnClick:(id)sender;
-(IBAction) patientImageBtnClick:(id)sender;
- (IBAction)logoutBtnClick:(id)sender;
- (IBAction)clearSessionBtnClick:(id)sender;
- (IBAction)unityBtnClick:(id)sender;
- (IBAction)testBtnClick:(id)sender;
- (IBAction)packageSelectBtnClick:(id)sender;
- (IBAction)frameStylingBtnClick:(id)sender;
- (IBAction)privatePatientBtnClick:(id)sender;
- (IBAction)productSelectDropDownClick:(id)sender;
- (IBAction)visualAcuityBtnClick:(id)sender;

- (void)pressTab;
@end

#endif


