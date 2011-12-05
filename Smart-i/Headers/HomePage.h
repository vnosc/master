//
//  HomePage.h
//  CyberImaging
//
//  Created by jay gurudev on 9/22/11.
//  Copyright 2011 software house. All rights reserved.
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

@property (retain, nonatomic) IBOutlet UITabBarController *tbc;

@property (nonatomic,retain) MainViewController *mainview;
@property (retain, nonatomic) IBOutlet UITabBar *mainTabBar;

- (IBAction)logoutBtnClick:(id)sender;
- (IBAction)clearSessionBtnClick:(id)sender;

- (IBAction)testBtnClick:(id)sender;

- (void)pressTab;
@end

#endif
