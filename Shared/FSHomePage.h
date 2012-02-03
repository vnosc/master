//
//  FSHomePage.h
//  Smart-i
//
//  Created by Logistic on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HomePage.h"
@interface FSHomePage : BackgroundViewController <UITabBarControllerDelegate>
{
    //SmartI_HomePage *home;
    UIActivityIndicatorView *activityIndicator;

}
//@property (nonatomic,retain)SmartI_HomePage *home;
-(IBAction)selectViewForTab:(id)sender;

@end
