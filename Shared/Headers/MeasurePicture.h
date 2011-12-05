//
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

#import "LineView.h"

@interface MeasurePicture : BackgroundViewController
{
	LineView* touchView;
	
	int measureType;
	CGAffineTransform initialTrans;
	float initialScale;
	float currentScale;
	
	float minScale;
	float maxScale;
	
	CGRect initialLocation;
}

@property (retain, nonatomic) IBOutlet UIView *imageContainer;
@property (retain, nonatomic) IBOutlet UIImageView *vImagePreview;
@property (retain, nonatomic) IBOutlet LineView *touchView;
@property int measureType;

@property CGPoint rightEyePoint;
@property CGPoint leftEyePoint;
@property CGPoint bridgePoint;

@property int processStep;

@property(nonatomic, retain) UIImageView* iv;
@property(nonatomic, retain) UIImage* img;
@property (retain, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGR;
@property (retain, nonatomic) IBOutlet UIPanGestureRecognizer *panGR;

@property (retain, nonatomic) IBOutlet UISlider *zoomSlider;
- (void) initLines;

- (void) moveSelectedPoint:(NSString*)dir X:(int)x Y:(int)y;

- (void) beginMeasureProcess;

- (float) transformPixelsToRealDistance:(float)pixels;

- (IBAction)captureBtnClick:(id)sender;
- (IBAction)cancelMeasure:(id)sender;
- (IBAction)moveSelectedUp:(id)sender;
- (IBAction)moveSelectedDown:(id)sender;
- (IBAction)moveSelectedLeft:(id)sender;
- (IBAction)moveSelectedRight:(id)sender;
- (IBAction)resetBtnClick:(id)sender;

-(IBAction)scale:(id)sender;
- (IBAction)pan:(id)sender;
- (IBAction)testBlendMode:(id)sender;
- (IBAction)zoomSliderChanged:(id)sender;
- (IBAction)zoomSliderTouched:(id)sender;

@end
