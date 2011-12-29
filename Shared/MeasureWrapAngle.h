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
@property (retain, nonatomic) MeasureLine *sliderLine;
@property (retain, nonatomic) MeasureLine *diagLine;
@property (retain, nonatomic) IBOutlet UITextField *angleField;

- (IBAction)angleSliderChanged:(id)sender;
- (void) setSliderPoint:(float)f2;

@end


@interface MeasureAreaView : UIView 
@property (assign) float anglePointX;
@end