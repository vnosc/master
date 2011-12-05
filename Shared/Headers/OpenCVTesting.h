//
//  OpenCVTesting.h
//  CyberImaging
//
//  Created by Troy Potts on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCVTesting : BackgroundViewController
{
	UIImage* _baseImage;
	UIImage* _cannyImage;
	
	CGPoint focusPoint;
	
}

@property CGPoint focusPoint;
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

- (IBAction)revertBtnClick:(id)sender;

- (IBAction)cannyBtnClick:(id)sender;
- (IBAction)cannySliderChanged:(id)sender;
- (IBAction)trackBtnClick:(id)sender;
- (IBAction)trackSliderChanged:(id)sender;
- (IBAction)threshBtnClick:(id)sender;
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

@end
