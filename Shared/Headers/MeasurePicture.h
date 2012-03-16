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
#import "OpenCVTesting.h"

/*@interface MeasureProcessStep
{
    UIEvent *_event;
    NSNotification *_notification;
}

+ (MeasureProcessStep *) stepWithEvent:(UIEvent*)event;
+ (MeasureProcessStep *) stepWithNotification:(NSNotification*)n;

- (MeasureProcessStep *) initWithEvent:(UIEvent*)event notification:(NSNotification*)n;

- (CGPoint*) touchPoint;

- (void) setNotification:(NSNotification *)n;
- (void) setMeasureLine:(MeasureLine *)l;
- (void) setTouches:(NSSet *)l;
- (void) setEvent:(

@end*/

@interface MeasurePicture : BackgroundViewController <MBProgressHUDDelegate>
{
	LineView* touchView;
	
	int measureType;
	CGAffineTransform initialTrans;
	float initialScale;
	float currentScale;
	
	float minScale;
	float maxScale;
	
	CGRect initialLocation;
    
    float realLaserDistance;
    float detectedLaserDistance;
    float imageScale;
}

@property (retain, nonatomic) IBOutlet UIView *imageContainer;
@property (retain, nonatomic) IBOutlet UIImageView *vImagePreview;
@property (retain, nonatomic) IBOutlet LineView *touchView;
@property (retain, nonatomic) IBOutlet UILabel *navigationTitleLabel;
@property int measureType;
@property (retain, nonatomic) IBOutlet UIView *instView;
@property (retain, nonatomic) IBOutlet UITextView *instTextView;

@property (retain, nonatomic) MBProgressHUD* HUD;

@property CGPoint rightEyePoint;
@property CGPoint leftEyePoint;
@property CGPoint bridgePoint;
@property CGPoint rightLaserPoint;
@property CGPoint leftLaserPoint;

@property int processStep;

@property(nonatomic, retain) UIImageView* iv;
@property(nonatomic, retain) UIImage* img;
@property (retain, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGR;
@property (retain, nonatomic) IBOutlet UIPanGestureRecognizer *panGR;

@property (retain, nonatomic) IBOutlet UISlider *zoomSlider;
- (void) initLines;

- (void) moveSelectedPoint:(NSString*)dir X:(int)x Y:(int)y;

- (void) beginMeasureProcess;
- (void) incrementProcessCounter;

- (void) nextProcessStep:(UIEvent*)event notification:(NSNotification*)n;
- (void) nextPDStep:(UIEvent*)event notification:(NSNotification*)n;
- (void) nextPantoStep:(UIEvent*)event notification:(NSNotification*)n;
- (void) nextVertexStep:(UIEvent*)event notification:(NSNotification*)n;

- (void) beginProcessStep:(NSString*)instructions;
- (void) beginRectStep:(NSString*)instructions;
- (void) beginLineStep:(NSString*)instructions;
- (void) beginPointStep:(NSString*)instructions;
- (void) beginAdjustStep:(NSString*)instructions;

- (void) prepareForMeasureRect;
- (void) prepareForMeasureLine;
- (void) prepareForMeasurePoint;

- (float) calculateImageScale;
- (float) transformPixelsToRealDistance:(float)pixels;

- (void) changeInstructions:(NSString*)instructions;

- (void) setZoomLevel:(float)zoomValue;

- (float) getLaserDistance;

- (IBAction)captureBtnClick:(id)sender;
- (IBAction)cancelMeasure:(id)sender;
- (IBAction)moveSelectedUp:(id)sender;
- (IBAction)moveSelectedDown:(id)sender;
- (IBAction)moveSelectedLeft:(id)sender;
- (IBAction)moveSelectedRight:(id)sender;
- (IBAction)resetBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

-(IBAction)scale:(id)sender;
- (IBAction)pan:(id)sender;
- (IBAction)testBlendMode:(id)sender;
- (IBAction)zoomSliderChanged:(id)sender;
- (IBAction)zoomSliderTouched:(id)sender;

@end
