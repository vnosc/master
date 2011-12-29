//
//  HomePage.h
//  VisionTest
//
//  Created by MAC OS on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"


@interface VisionTestHomePage : UIViewController 
{
    MainViewController *mainview;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *honeBtn;
    IBOutlet UIButton *Astigmatismbtn;
    IBOutlet UIButton *colorbtn;
    IBOutlet UIButton *distancebtn;
    IBOutlet UIButton *testresultbtn;
    IBOutlet UIButton *settingbtn;
    IBOutlet UIButton *eyeadvicebtn;
    IBOutlet UIButton *opticianbtn;
    IBOutlet UIButton *questionbtn;
    IBOutlet UIButton *duochromebtn;
    IBOutlet UIButton *visualbtn;

    IBOutlet UIView *homepageView;
    IBOutlet UIView *visualView;
    IBOutlet UIView *astigmatismView;
    IBOutlet UIView *duochromeView;
    IBOutlet UIView *colourView;
    IBOutlet UIView *questionsView;
    IBOutlet UIView *distanceView;
    IBOutlet UIView *opticianView;
    IBOutlet UIView *testView;
    IBOutlet UIView *eyeView;
    IBOutlet UIView *settingView;
    IBOutlet UIView *howerView;
    UINavigationController *nav;
}
@property (nonatomic,retain) MainViewController *mainview;
-(IBAction) homeBtnClick: (id)sender;
-(IBAction)showAstigmatism:(id)sender;
-(IBAction)showColourTest:(id)sender;
-(IBAction)showDistanceVision:(id)sender;
-(IBAction)showTestResults:(id)sender;
-(IBAction)showSettings:(id)sender;
-(IBAction)showEyeAdvice:(id)sender;
-(IBAction)showOpticianFinder:(id)sender;
-(IBAction)showQuestions:(id)sender;
-(IBAction)showDuochrome:(id)sender;
-(IBAction)showVisualAcuity:(id)sender;



@end
