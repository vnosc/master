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
	
    float defaultMinArea;
    float defaultMaxArea;
    float defaultMinDist;
    float defaultMaxDist;
    float defaultMinAngle;
    float defaultMaxAngle;
    
    double valDP;
    double valMinDist;
    double valCanny;
    double valAccumulator;
    
    UIImage *_baseContourImage;
    int cIdx;
}

@property CGPoint focusPoint;
@property (assign) int labelSize;
@property (assign) float detectMinArea;
@property (assign) float detectMaxArea;
@property (assign) float detectMinDist;
@property (assign) float detectMaxDist;
@property (assign) float detectMinAngle;
@property (assign) float detectMaxAngle;

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
@property (retain, nonatomic) IBOutlet UILabel *detectMinAreaLabel;
@property (retain, nonatomic) IBOutlet UILabel *detectMaxAreaLabel;
@property (retain, nonatomic) IBOutlet UILabel *detectMinDistLabel;
@property (retain, nonatomic) IBOutlet UILabel *detectMaxDistLabel;
@property (retain, nonatomic) IBOutlet UILabel *detectMinAngleLabel;
@property (retain, nonatomic) IBOutlet UILabel *detectMaxAngleLabel;
@property (retain, nonatomic) IBOutlet UISlider *detectMinAreaSlider;
@property (retain, nonatomic) IBOutlet UISlider *detectMaxAreaSlider;
@property (retain, nonatomic) IBOutlet UISlider *detectMinDistSlider;
@property (retain, nonatomic) IBOutlet UISlider *detectMaxDistSlider;
@property (retain, nonatomic) IBOutlet UISlider *detectMinAngleSlider;
@property (retain, nonatomic) IBOutlet UISlider *detectMaxAngleSlider;

- (void) setBaseImageFromPatient:(int)idx;

- (void) drawContour:(int)contourIdx;
- (float) transformPixelsToRealDistance:(float)pixels;

- (UIImage*)detectAndDrawLasers:(UIImage*)baseInputImg;

- (void)findLasers:(UIImage*)inputImg;
- (UIImage*)drawLasers:(UIImage*)inputImg;
- (float)getLaserDistance:(UIImage*)baseInputImg;

- (UIImage*)doMethod1:(UIImage*)inputImg;
- (UIImage*)doMethod2:(UIImage*)inputImg;
- (UIImage*)doMethod3:(UIImage*)inputImg;
- (UIImage*)doMethod4:(UIImage*)inputImg;
- (UIImage*)doMethod5:(UIImage*)inputImg;

- (float)getMaxValue;

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
- (IBAction)displayHueBtnClick:(id)sender;
- (IBAction)displaySaturationBtnClick:(id)sender;
- (IBAction)displayValueBtnClick:(id)sender;
- (IBAction)detectMinAreaSliderChanged:(id)sender;
- (IBAction)detectMaxAreaSliderChanged:(id)sender;
- (IBAction)detectMinDistSliderChanged:(id)sender;
- (IBAction)detectMaxDistSliderChanged:(id)sender;
- (IBAction)detectMinAngleSliderChanged:(id)sender;
- (IBAction)detectMaxAngleSliderChanged:(id)sender;
- (IBAction)resetDetectParams:(id)sender;

- (IBAction)patientBtnClick:(id)sender;
- (IBAction)method1:(id)sender;
- (IBAction)method2:(id)sender;
- (IBAction)method3:(id)sender;
- (IBAction)method4:(id)sender;
- (IBAction)method5:(id)sender;

@end
