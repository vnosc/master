//
//  Lenses.h
//  CyberImaging
//
//  Created by jay gurudev on 9/21/11.
//  Copyright 2011 software house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"


@interface Lenses : BackgroundViewController <DropDownViewDelegate>{
	//IBOutlet UIButton *saveBtn;
	IBOutlet UIButton *radioBtn1;
	IBOutlet UIButton *radioBtn2;
	IBOutlet UIButton *radioBtn3;
	IBOutlet UIImageView *captureImage;
    	IBOutlet UIImageView *straitImage;
    	IBOutlet UIImageView *lookdownImage;
    	IBOutlet UIImageView *sideImage;
	IBOutlet UITextView *textview;
	DropDownView *dropDownView1;
	DropDownView *dropDownView2;
	DropDownView *dropDownView3;
	IBOutlet UIButton *dropdownBtn1;
	IBOutlet UIButton *dropdownBtn3;
	IBOutlet UIButton *dropdownBtn2;
	NSArray *typedata1;
	NSArray *typedata2;
	NSArray *typedata3;
	UIImage *image;
    UIImage *image_1;
    UIImage *image_2;
    IBOutlet UIButton *selectBtn1;
	IBOutlet UIButton *selectBtn2;
	IBOutlet UIButton *selectBtn3;
	IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *right;
    IBOutlet UIButton *left;
    IBOutlet UIButton *top;
    IBOutlet UIButton *bottom;
    IBOutlet UIImageView *arrowImage;
    IBOutlet UILabel *move;
    IBOutlet UILabel *resize;
}
@property (nonatomic,retain)UILabel *move;
@property (nonatomic,retain) UIScrollView *scroll;
@property (nonatomic,retain) UIImageView *captureImage;
@property (nonatomic,retain) UIImageView *straitImage;
@property (nonatomic,retain) UIImageView *lookdownImage;
@property (nonatomic,retain) UIImageView *sideImage;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) UIImage *image_1;
@property (nonatomic,retain) UIImage *image_2;
@property (nonatomic,retain) NSArray *typedata1;
@property (nonatomic,retain) NSArray *typedata2;
@property (nonatomic,retain) NSArray *typedata3;
@property (nonatomic,retain) IBOutlet UIButton *dropdownBtn1;
@property (nonatomic,retain) IBOutlet UIButton *dropdownBtn3;
@property (nonatomic,retain) IBOutlet UIButton *dropdownBtn2;

//@property (nonatomic,retain)IBOutlet UITextView *textview;
//-(IBAction) saveBtnClick:(id)sender;
-(IBAction) radiobtn1Click:(id)sender;
-(IBAction) radiobtn2Click:(id)sender;
-(IBAction) radiobtn3Click:(id)sender;
-(IBAction) droapdownBtnClick1:(id)sender;
-(IBAction) droapdownBtnClick2:(id)sender;
-(IBAction) droapdownBtnClick3:(id)sender;
- (void) opencvFaceDetect:(UIImage *)overlayImage;

-(IBAction)ResizeSpect:(id)sender;
-(IBAction) selectImageBtnClick:(id)sender;
-(IBAction)MoveBoxErrow:(id)sender;
@end
