//
//  EyeAdvice.h
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EyeAdvice : UIViewController
{
    IBOutlet UIScrollView *imgTextScroll;
    
    IBOutlet UIImageView *textImageView;
    IBOutlet UIButton *findOpticianBtn;
    IBOutlet UIButton *viewOtherEyeFacts;
    IBOutlet UIButton *seeMoreAbout;
    
}

@property (nonatomic,retain) UIScrollView *imgTextScroll;

@property (nonatomic,retain) UIImageView *textImageView;
-(IBAction) findOpticianBtnClick : (id)sender;
-(IBAction) viewOtherEyeFactsBtnClick : (id)sender; 
-(IBAction) seeMoreBtnClick : (id)sender;
@end
