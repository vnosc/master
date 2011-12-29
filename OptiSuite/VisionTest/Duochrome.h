//
//  Duochrome.h
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CyberImagingAppDelegate.h"
@interface Duochrome : UIViewController<MBProgressHUDDelegate>
{
    CyberImagingAppDelegate *app;
     MBProgressHUD *HUD;
    IBOutlet UIButton *startTestBtn;
    IBOutlet UIImageView *mainImage;
    IBOutlet UIButton *yesBtn;
    IBOutlet UIButton *noBtn;
    IBOutlet UILabel *leftLabel;
    IBOutlet UILabel *rightLabel;
    IBOutlet UIButton *findOptician;
    IBOutlet UIButton *nextTest;

}
@property (nonatomic,retain) UILabel *leftLabel;
@property (nonatomic,retain) UILabel *rightLabel;
-(IBAction) yesandNoBtnClick : (id)sender;
-(IBAction) startTestBtnClick :(id)sender;
-(IBAction) findOpticianBtnClick : (id)sender;
-(IBAction) nextTestBtnClick : (id)sender;
- (void)myMixedTask;

@end
