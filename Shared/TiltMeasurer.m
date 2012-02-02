//
//  TiltMeasurer.m
//  Smart-i
//
//  Created by Troy Potts on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TiltMeasurer.h"
#import <CoreMotion/CoreMotion.h>

@implementation TiltMeasurer

- (id) init
{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.01;
    //[motionManager startGyroUpdatesToQueue:<#(NSOperationQueue *)#> withHandler:^(CMGyroData *gyroData, NSError *error) {
}
@end
