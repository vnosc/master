//
//  HomeView.h
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CFDictionary.h>
#import <Foundation/NSURL.h>
#import <ImageIO/ImageIO.h>

#import <UIKit/UIKit.h>

#import "Adjust.h"
#import "SelectSpech.h"
#import "CreateUser.h"
//#import "Lenses.h"
@interface HomeView : BackgroundViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPopoverControllerDelegate>{
    
	
	//Lenses *lense;
	UIWindow *mainWindow;
	UITabBarController *tabcontrol;
	Adjust *adjust;
	SelectSpech *select;
	CreateUser *User;
	IBOutlet UIButton *lensesBtn;
	IBOutlet UITextField *firstName;
	IBOutlet UITextField *lastName;
	IBOutlet UIButton *captureBtn;
	IBOutlet UIImageView *captureImage;
    IBOutlet UIImageView *smallImage; 
	IBOutlet UIImageView *smallImage2;
	IBOutlet UIImageView *smallImage3;
	
	IBOutlet UIButton *adjustbtn;
	IBOutlet UIButton *selectspechbtn;
	IBOutlet UIButton *selectBtn1;
	IBOutlet UIButton *selectBtn2;
	IBOutlet UIButton *selectBtn3;
	IBOutlet UIButton *selectBtn4;
	IBOutlet UIButton *selectBtn5;
	IBOutlet UIButton *selectBtn6;	
	UIPopoverController * popover;
    IBOutlet UIScrollView *scroll;
    IBOutlet UISlider *slider1;
    IBOutlet UIButton *retack;
     UIImageView *vline;
     UIImageView *hline;
}
@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property(nonatomic, retain)AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic,retain) UIImageView *vline;
@property(nonatomic,retain) UIImageView *hline;

@property (nonatomic,retain)IBOutlet UISlider *slider1;
@property (nonatomic,retain)     IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) IBOutlet UIWindow *mainWindow;
@property (nonatomic,retain) UITextField *firstName;
@property (nonatomic,retain) UITextField *lastName;
@property (nonatomic,retain) UIImageView *captureImage;
@property (nonatomic,retain) UIImageView *smallImage; 
@property (nonatomic,retain) UIImageView *smallImage2;
@property (nonatomic,retain) UIImageView *smallImage3;


-(IBAction) retackBtnClick : (id)sender;
-(IBAction)ResizeSpect:(id)sender;
-(IBAction) captureBtnClick:(id)sender;
//-(IBAction) lensesbtnclick:(id)sender;
//-(IBAction) adjustbtnclick:(id)sender;
//-(IBAction) selectspechbtnclick:(id)sender;
//-(IBAction) CreateUserbtnClick:(id)sender;
-(IBAction) selectImageBtnClick:(id)sender;
@end
