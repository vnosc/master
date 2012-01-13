//
//  ColourTest.h
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalVariable.h"
@interface ColourTest : UIViewController
{
    GlobalVariable *app;
    IBOutlet UIButton *nextTestBtn;
    IBOutlet UIButton *findOpticianBtn;
    IBOutlet UIButton *startTestBtn;
    IBOutlet UILabel *scoreLbl;
    IBOutlet UIImageView *mainImage;
    IBOutlet UIButton *firstBtn;
    IBOutlet UIButton *secondBtn;
    IBOutlet UIButton *thirdBtn;
    IBOutlet UIButton *fourthBtn;
    IBOutlet UIButton *notSureBtn;
    IBOutlet UIImageView *smallImage;
    NSString *rendomString;
    IBOutlet UIImageView *redImageView;
}
@property (nonatomic,retain) NSString *rendomString;
@property (nonatomic,retain) UILabel *scoreLbl;
-(IBAction) nextTestBtnClick : (id) sender;
-(IBAction) findOpticianBtnClick : (id) sender;
-(IBAction) startTestBtnClick : (id) sender;
-(IBAction) firstBtnClick : (id) sender;
-(IBAction) secondBtnClick : (id) sender;
-(IBAction) thirdBtnClick : (id) sender;
-(IBAction) fourthBtnClick : (id) sender;
-(IBAction) notSureBtnClick : (id) sender;
@end
