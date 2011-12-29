//
//  Questions.h
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CyberImagingAppDelegate.h"
@interface Questions : UIViewController
{
    CyberImagingAppDelegate *app;
    IBOutlet UIButton *yesBtn;
    IBOutlet UIButton *noBtn;
    IBOutlet UILabel *scoreLbl;
    IBOutlet UILabel *questionLbl;
    IBOutlet UIButton *findOpticianBtn;
    IBOutlet UIButton *myResultBtn;
    IBOutlet UIImageView *mainImage;
}
@property(nonatomic,retain) UILabel *scoreLbl;
@property (nonatomic,retain) UILabel *questionLbl;
-(IBAction) yesAndNoBtnClick : (id) sender;
-(IBAction) findOpticianBtnClick : (id) sender;
-(IBAction) myResultBtnClick : (id) sender;
-(void) jump1;
@end
