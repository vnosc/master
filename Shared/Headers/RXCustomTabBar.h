//
//  RumexCustomTabBar.h
//  
//
//  Created by Oliver Farago on 19/06/2010.
//  Copyright 2010 Rumex IT All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePage.h"
@interface RXCustomTabBar : UITabBarController <UITabBarControllerDelegate>{
	UIButton *btn1;
	UIButton *btn2;
	UIButton *btn3;
	UIButton *btn4;
	HomePage *homePage;
}

@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;
@property (nonatomic, retain) UIButton *btn3;
@property (nonatomic, retain) UIButton *btn4;

-(void) hideTabBar;
-(void) addCustomElements;
-(void) selectTab:(int)tabID;

-(void) hideNewTabBar;
-(void) showNewTabBar;

@end
