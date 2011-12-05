//
//  FrameStyling.h
//  Smart-i
//
//  Created by Troy Potts on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CaptureOverview.h"

@interface FrameStyling : BackgroundViewController <CAAction>
//@interface FrameStyling : BackgroundViewController <CAAction>
{
	UIImageView *_dragImage;
}
@property (retain, nonatomic) IBOutlet UITextField *txtPatientName;
@property (retain, nonatomic) IBOutlet UITextField *txtMemberId;
@property (retain, nonatomic) IBOutlet UIImageView *imageCompareL;
@property (retain, nonatomic) IBOutlet UIImageView *imageCompareR;

@property (retain, nonatomic) IBOutletCollection(UIImageView) NSArray *imageCompareViews;
@property (retain, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *imageViewBtns;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *retakePictureBtns;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *frameNameCompareLbls;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *frameNameLbls;
@property (retain, nonatomic) IBOutlet UIPanGestureRecognizer *pgr;
@property (retain, nonatomic) IBOutlet UITapGestureRecognizer *tgr;

@property (retain) UIImageView *dragImage;
@property (assign) BOOL draggedImage;

@property (retain, nonatomic) IBOutlet CapturePicture* captureVC;

@property (nonatomic) int selectedImageView;

- (IBAction)dragImage:(id)sender;
- (IBAction)touchImage:(id)sender;
- (IBAction)retakePictureBtnClicked:(id)sender;

@end
