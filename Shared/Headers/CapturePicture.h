//CapturePicture
//  CapturePicture.h
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CFDictionary.h>
#import <Foundation/NSURL.h>
#import <ImageIO/ImageIO.h>

@interface CapturePicture : BackgroundViewController
{
    UIImage *guideImage;
    
    AVAudioPlayer *_player;
}
@property (retain, nonatomic) IBOutlet UIView *vImagePreview;

@property(nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property(nonatomic, retain)AVCaptureStillImageOutput *stillImageOutput;
@property (retain, nonatomic) IBOutlet UILabel *navigationTitleLabel;

@property (retain, nonatomic) IBOutlet UIImageView *guideView;
@property (retain, nonatomic) IBOutlet UIButton *guideBtn;

@property (retain, nonatomic) IBOutlet UIView *instView;
@property (retain, nonatomic) IBOutlet UITextView *instTextView;
@property (retain, nonatomic) IBOutlet UIButton *instBtn;

@property(nonatomic, retain) UIImageView* iv;

@property int measureType;
@property BOOL usingFrontCamera;
@property BOOL guidesOn;
@property BOOL displayInstructions;

@property (retain) NSArray* alertMessages;
@property (retain) NSArray* instMessages;

- (void) setImagePreviewMask;
- (void) createCamera;
- (void) initGuideImage;

- (void) showGuides:(BOOL)isShown;

- (void) showInstructions:(BOOL)isShown;

- (void) showInstructionsAlert;
- (void) setInstructionsText;

- (IBAction)captureBtnClick:(id)sender;
- (IBAction)changeCamera:(id)sender;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)instBtnClick:(id)sender;
- (IBAction)guideBtnClick:(id)sender;

@end
