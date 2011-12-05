//
//  LoginView.h
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface LoginView : BackgroundViewController <MBProgressHUDDelegate>
{
    MainViewController *mainView;
    UITextField *username;
    UITextField *password;
    IBOutlet UIButton *btnLoagin;
    IBOutlet UIButton *btnRemember;
	
	MBProgressHUD *HUD;
}
@property (nonatomic,retain) IBOutlet UITextField *username;
@property (nonatomic,retain) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UITextField *npi;
@property (nonatomic ,retain) MainViewController *mainView;
@property (retain, nonatomic) IBOutlet UIImageView *usernameImage;
@property (retain, nonatomic) IBOutlet UIImageView *passwordImage;

@property (retain, nonatomic) MBProgressHUD *HUD;

- (void)login;
-(IBAction) loginButtonClick :(id)sender;
-(IBAction) rememberButtonClick : (id)sender;
@end
