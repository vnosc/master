//
//  HomePage.h for Smart-i
//  CyberImaging
//
//  Created by Troy Potts on 12/29/11
//  Copyright 2011 Pro Fit Optix. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeView.h"

#import "TestsPage.h"

#import "MainViewController.h"

#import "Measurements.h"

#define HomePage SmartI_HomePage

#ifndef HOMEPAGE_H

#define HOMEPAGE_H

@interface SmartI_HomePage : BackgroundViewController <UITabBarControllerDelegate, UITabBarDelegate>{

	IBOutlet UIButton *clearSessionBtn;
	IBOutlet UIButton *logoutBtn;
	MainViewController *mainview;
	
}

@property (retain, nonatomic) IBOutlet UIButton *hackDropDownButton;
@property (retain, nonatomic) IBOutlet UIView *hackDropDownView;
@property (retain, nonatomic) IBOutlet UIView *hackAfterDropDownView;
@property (retain, nonatomic) IBOutlet UIView *hackDropDownView2;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *sectionBtns;
@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *sectionSubmenuViews;

@property (retain, nonatomic) IBOutlet UITabBarController *tbc;

@property (nonatomic,retain) MainViewController *mainview;
@property (retain, nonatomic) IBOutlet UITabBar *mainTabBar;

- (IBAction)logoutBtnClick:(id)sender;
- (IBAction)clearSessionBtnClick:(id)sender;

- (IBAction)testBtnClick:(id)sender;

- (void)pressTab;
@end

#endif
