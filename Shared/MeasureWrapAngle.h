//
//  MeasureWrapAngle.h
//  Smart-i
//
//  Created by Troy Potts on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasureLine.h"

@class MeasureAreaView;

@interface MeasureWrapAngle : BackgroundViewController

@property (retain, nonatomic) IBOutlet MeasureAreaView *measureAreaView;
@property (retain, nonatomic) IBOutlet UISlider *angleSlider;
@property (retain, nonatomic) IBOutlet UISlider *frameWidthSlider;
@property (retain, nonatomic) MeasureLine *sliderLine;
@property (retain, nonatomic) MeasureLine *diagLine;
@property (retain, nonatomic) IBOutlet UITextField *angleField;
@property (retain, nonatomic) IBOutlet UIImageView *wrapImageView;

- (IBAction)angleSliderChanged:(id)sender;
- (IBAction)frameWidthSliderChanged:(id)sender;
- (void) setSliderPoint:(float)f2;
- (void) setFrameWidthPoint:(float)f2;
- (IBAction)saveAndContinue:(id)sender;

@end


@interface MeasureAreaView : UIView 

@property (assign) int effOffset;
@property (assign) float anglePointX;
@property (assign) float anglePointY;

@end