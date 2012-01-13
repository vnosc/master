//
//  Settings.h
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariable.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface Settings : UIViewController<MFMailComposeViewControllerDelegate>
{
    GlobalVariable *app;
    IBOutlet UIButton *resetResultsBtn;
    IBOutlet UIButton *visitBtn;
    IBOutlet UIButton *submitReviewBtn;
    IBOutlet UIButton *termsAndConditionBtn;
    
}
-(IBAction) resetResultsBtnClick : (id)sender;
-(IBAction) visitBtnClick : (id) sender;
-(IBAction) submitReviewBtnClick : (id)sender;
-(IBAction) termsAndConditionBtnClick : (id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
@end
