//
//  VisualAcuity.h
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GlobalVariable.h"

@interface VisualAcuity : UIViewController<MBProgressHUDDelegate>
{
    
    MBProgressHUD *HUD;
    GlobalVariable *app;
    IBOutlet UIButton *startTestBtn;
    NSArray *array;
    IBOutlet UILabel *rendomTextLbl;
    IBOutlet UIButton *firstBtn;
    IBOutlet UIButton *secondBtn;
    IBOutlet UIButton *thirdBtn;
    IBOutlet UIButton *notSureBtn;
    NSString *rendomString;
    IBOutlet UIImageView *mainImage;
    IBOutlet UIButton *findOptician;
    IBOutlet UIButton *nextTest;
    IBOutlet UILabel *leftEyeLbl;
    IBOutlet UILabel *rightEyeLbl;
    IBOutlet UIImageView *redImageView;
}
@property (nonatomic,retain) NSArray *array;
@property (nonatomic,retain) UILabel *rendomTextLbl;
@property (nonatomic,retain) UILabel *leftEyeLbl;
@property (nonatomic,retain) UILabel *rightEyeLbl;
@property (nonatomic,retain) NSString *rendomString;
-(IBAction) startTestBtnClick : (id) sender;

-(IBAction) firstBtnClick : (id)sender;
-(IBAction) secondBtnClick : (id)sender;
-(IBAction) thirdBtnClick : (id)sender;
-(IBAction) noteSureBtnClick : (id)sender;
-(IBAction) findOpticianBtnClick : (id)sender;
-(IBAction) nextTestBtnClick : (id)sender;
- (void)myMixedTask;


@end
