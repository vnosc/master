//
//  OpenCVTesting.h
//  CyberImaging
//
//  Created by Troy Potts on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCVTesting : BackgroundViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImage* _firstImage;
	UIImage* _baseImage;
	
	CGPoint focusPoint;
	
    double valDP;
    double valMinDist;
    double valCanny;
    double valAccumulator;
    
    UIImage *_baseContourImage;
    int cIdx;
}

@property CGPoint focusPoint;
@property (assign) int labelSize;

@property (retain, nonatomic) IBOutlet UIScrollView *propertySV;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIImageView *drawView;
@property (retain, nonatomic) IBOutlet UISlider *lowSlider;
@property (retain, nonatomic) IBOutlet UISlider *highSlider;
@property (retain, nonatomic) IBOutlet UILabel *lowSliderLabel;
@property (retain, nonatomic) IBOutlet UILabel *highSliderLabel;
@property (retain, nonatomic) IBOutlet UISlider *maxCornersSlider;
@property (retain, nonatomic) IBOutlet UISlider *qualityLevelSlider;
@property (retain, nonatomic) IBOutlet UISlider *minDistanceSlider;
@property (retain, nonatomic) IBOutlet UILabel *maxCornersLabel;
@property (retain, nonatomic) IBOutlet UILabel *qualityLevelLabel;
@property (retain, nonatomic) IBOutlet UILabel *minDistanceLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *apertureSegment;
@property (retain, nonatomic) IBOutlet UISwitch *labelSwitch;
@property (retain, nonatomic) IBOutlet UISegmentedControl *blurTypeSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *morphTypeSegment;
@property (retain, nonatomic) IBOutlet UISlider *morphIterSlider;
@property (retain, nonatomic) IBOutlet UILabel *morphIterLabel;
@property (retain, nonatomic) IBOutlet UISlider *threshSlider;
@property (retain, nonatomic) IBOutlet UILabel *threshLabel;
@property (retain, nonatomic) IBOutlet UILabel *labelSizeLabel;
@property (retain, nonatomic) IBOutlet UISlider *labelSizeSlider;
@property (retain, nonatomic) IBOutlet UISlider *houghCircleDPSlider;
@property (retain, nonatomic) IBOutlet UISlider *houghCircleMinDistSlider;
@property (retain, nonatomic) IBOutlet UISlider *houghCircleCannySlider;
@property (retain, nonatomic) IBOutlet UISlider *houghCircleAccumulatorSlider;

- (void) setBaseImageFromPatient:(int)idx;

- (void) drawContour:(int)contourIdx;
- (float) transformPixelsToRealDistance:(float)pixels;

- (UIImage*)detectAndDrawLasers:(UIImage*)baseInputImg;

- (void)findLasers:(UIImage*)inputImg;
- (UIImage*)drawLasers:(UIImage*)inputImg;
- (float)getLaserDistance:(UIImage*)baseInputImg;

- (UIImage*)doMethod2:(UIImage*)inputImg;

- (IBAction)revertBtnClick:(id)sender;

- (IBAction)cannyBtnClick:(id)sender;
- (IBAction)cannySliderChanged:(id)sender;
- (IBAction)trackBtnClick:(id)sender;
- (IBAction)trackSliderChanged:(id)sender;
- (IBAction)threshBtnClick:(id)sender;
- (IBAction)adaptiveThreshBtnClick:(id)sender;
- (IBAction)pyrMeanShiftFilterBtnClick:(id)sender;
- (IBAction)harrisBtnClick:(id)sender;
- (IBAction)eigenBtnClick:(id)sender;
- (IBAction)contoursBtnClick:(id)sender;
- (IBAction)gaussianBlurBtnClick:(id)sender;
- (IBAction)cvBlobDetectBtnClick:(id)sender;
- (IBAction)sobelBtnClick:(id)sender;
- (IBAction)dilateBtnClick:(id)sender;
- (IBAction)erodeBtnClick:(id)sender;
- (IBAction)equalizeHistBtnClick:(id)sender;
- (IBAction)morphBtnClick:(id)sender;
- (IBAction)morphIterSliderChanged:(id)sender;
- (IBAction)customBtnClick:(id)sender;
- (IBAction)laplaceBtnClick:(id)sender;
- (IBAction)recoverBtnClick:(id)sender;
- (IBAction)storeBtnClick:(id)sender;
- (IBAction)threshSliderChanged:(id)sender;
- (IBAction)detectPupilClick:(id)sender;
- (IBAction)labelSizeSliderChanged:(id)sender;
- (IBAction)houghCirclesBtnClick:(id)sender;
- (IBAction)nextContourBtnClick:(id)sender;
- (IBAction)drawLaserCandidatesBtnClick:(id)sender;
- (IBAction)changeImageBtnClick:(id)sender;
- (IBAction)patientImageBtnClick:(id)sender;
- (IBAction)mixRedBtnClick:(id)sender;
- (IBAction)mixBlueBtnClick:(id)sender;
- (IBAction)mixGreenBtnClick:(id)sender;
- (IBAction)convertToHSVBtnClick:(id)sender;
- (IBAction)testChannelSubBtnClick:(id)sender;
- (IBAction)normalizeBtnClick:(id)sender;

- (IBAction)method1:(id)sender;
- (IBAction)method2:(id)sender;

@end
