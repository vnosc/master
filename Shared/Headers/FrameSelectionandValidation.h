//
//  FrameSelectionandValidation.h
//  CyberImaging
//
//  Created by Kaushik on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"

@interface FrameSelectionandValidation : BackgroundViewController <DropDownViewDelegate>
{
    IBOutlet UIButton *btn_mens;
    IBOutlet UIButton *btn_womens;
    IBOutlet UIButton *btn_childrens;
    IBOutlet UIButton *btn_unisex;
    IBOutlet UIButton *btn_sport;
    IBOutlet UIButton *btn_computer;
    IBOutlet UIButton *btn_outdoor;
    
	IBOutlet UIButton *dropdownBtn1;
	IBOutlet UIButton *dropdownBtn2;
    NSArray *typedata1;
	NSArray *typedata2;
    
    DropDownView *dropDownView1;
	DropDownView *dropDownView2;
    IBOutlet UIButton *selectandcontinue;
    
    IBOutlet UIImageView *image1;
    IBOutlet UIImageView *image2;
    
}
@property (nonatomic,retain) NSArray *typedata1;
@property (nonatomic,retain) NSArray *typedata2;

@property (nonatomic,retain) IBOutlet UIButton *dropdownBtn1;
@property (nonatomic,retain) IBOutlet UIButton *dropdownBtn2;

@property (nonatomic,retain) UIImageView *image1;
@property (nonatomic,retain) UIImageView *image2;

-(IBAction) mensRadioclick : (id)sender;
-(IBAction) womensRadioclick : (id)sender;
-(IBAction) childrensRadioclick : (id)sender;
-(IBAction) unisexRadioclick : (id)sender;
-(IBAction) sportRadioclick : (id)sender;
-(IBAction) computerRadioclick : (id)sender;
-(IBAction) outdoorRadioclick : (id)sender;

-(IBAction) droapdownBtnClick1:(id)sender;
-(IBAction) droapdownBtnClick2:(id)sender;

-(IBAction) selectandcontinueBtnClick : (id) sender;
@end
