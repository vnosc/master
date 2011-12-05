//
//  CyberImagingAppDelegate.h
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CyberImagingAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {
    UIViewController *viewController;
}
@property (nonatomic,retain) IBOutlet UIViewController *viewController;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
