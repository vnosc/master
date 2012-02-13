//
//  FSHomePage.h
//  Smart-i
//
//  Created by Logistic on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HomePage.h"

#import "FrameCatelogs.h"

@interface FSHomePage : BackgroundViewController <UITabBarControllerDelegate>
{
    //SmartI_HomePage *home;
    UIActivityIndicatorView *activityIndicator;
    ServiceObject *_frameBrands;
}
@property (retain, nonatomic) IBOutlet UIScrollView *brandSV;

@property (retain, nonatomic) MBProgressHUD *HUD;

//@property (nonatomic,retain)SmartI_HomePage *home;
-(IBAction)selectViewForTab:(id)sender;
- (UIImage*)getFrameBrandImage:(int)brandId;

@end
