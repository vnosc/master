//
//  CyberImagingAppDelegate.h
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomUI.h"

@interface CyberImagingAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {
    UIViewController *viewController;
	
	NSString *visualAcuityLeftEye;
    NSString *visualAcuityRightEye;
    
    NSString *astigmatismLeftEye;
    NSString *astigmatismRightEye;
    
    NSString *duochromeLeftEye;
    NSString *duochromeRightEye;
    
    NSString *colorTestLeftEye;
    NSString *colorTestRightEye;
    
    NSString *questionLeftEye;
    NSString *questionRightEye;
	
}
@property (nonatomic, retain) NSString *visualAcuityLeftEye;
@property (nonatomic, retain) NSString *visualAcuityRightEye;

@property (nonatomic, retain) NSString *astigmatismLeftEye;
@property (nonatomic, retain) NSString *astigmatismRightEye;

@property (nonatomic, retain) NSString *duochromeLeftEye;
@property (nonatomic, retain) NSString *duochromeRightEye;

@property (nonatomic, retain) NSString *colorTestLeftEye;
@property (nonatomic, retain) NSString *colorTestRightEye;

@property (nonatomic, retain) NSString *questionLeftEye;
@property (nonatomic, retain) NSString *questionRightEye;

@property (nonatomic,retain) IBOutlet UIViewController *viewController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
