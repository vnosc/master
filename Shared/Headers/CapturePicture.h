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

@property (retain, nonatomic) IBOutlet UIView *vImagePreview;

@property(nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property(nonatomic, retain)AVCaptureStillImageOutput *stillImageOutput;

@property(nonatomic, retain) UIImageView* iv;
@property int measureType;
@property BOOL usingFrontCamera;

@property (retain) NSArray* instMessages;

- (void) createCamera;

- (IBAction)captureBtnClick:(id)sender;
- (IBAction)changeCamera:(id)sender;

@end
