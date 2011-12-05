//
//  MainViewController.h
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginView;
@class Loading;
@interface MainViewController : BackgroundViewController {
    UIWindow *mainWindow;
	UITabBarController *tabcontrol;
    Loading *loading;
    LoginView *login;
}
@property (nonatomic,retain) IBOutlet UIWindow *mainWindow;

-(void)showLogin;
-(void)showHome;
@end
