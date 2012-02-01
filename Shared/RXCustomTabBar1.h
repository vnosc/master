//
//  RumexCustomTabBar.h
//  
//
//  Created by Oliver Farago on 19/06/2010.
//  Copyright 2010 Rumex IT All rights reserved.
//

#import <UIKit/UIKit.h>
//@class HOMEPa;

@interface RXCustomTabBar1 : UITabBarController {
	UIButton *btn1;
	UIButton *btn2;
	UIButton *btn3;
	UIButton *btn4;
    UIButton *btn5;
    UIButton *btnBg;
}
@property (nonatomic,retain)UIButton *btnBg;
@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;
@property (nonatomic, retain) UIButton *btn3;
@property (nonatomic, retain) UIButton *btn4;
@property (nonatomic, retain) UIButton *btn5;

-(void) hideTabBar;
-(void) addCustomElements;
-(void) selectTab:(int)tabID;

-(void) hideNewTabBar;
-(void) ShowNewTabBar;

-(void)selectTab:(int)tabID;
+(void)callmethod;
@end
