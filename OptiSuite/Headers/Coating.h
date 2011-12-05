//
//  Coating.h
//  LENSIndex
//
//  Created by nitesh suvagia on 11/26/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoatingView.h"

@class DraggableLens;

@interface Coating : BackgroundViewController
{
    UIBezierPath *myPath;
    UIColor *brushPattern;
	
	UIImage *lensImage;
	UIImage *lensFrameImage;
	UIImage *lensMaskImage;
	
	CGContextRef ctx;
}

@property (retain) UIColor *baseTintColor;
@property (assign) float lastTintStrength;
@property (assign) int mode;

@property (retain, nonatomic) IBOutlet UIButton *btnAR;
@property (retain, nonatomic) IBOutlet UIButton *btnPolarized;
@property (retain, nonatomic) IBOutlet UIButton *btnScratch;
@property (retain, nonatomic) IBOutlet UIButton *btnTint;
@property (retain, nonatomic) IBOutlet UISegmentedControl *modeSegment;

@property (retain, nonatomic) IBOutlet UIView *glassesViewLeft;
@property (retain, nonatomic) IBOutlet UIView *glassesViewRight;
@property (retain, nonatomic) IBOutlet DraggableLens *glassLeft;
@property (retain, nonatomic) IBOutlet DraggableLens *glassRight;
@property (retain, nonatomic) IBOutlet UIImageView *bgLeft;
@property (retain, nonatomic) IBOutlet UIImageView *bgRight;

@property (retain, nonatomic) IBOutlet UISlider *tintSlider;
@property (retain, nonatomic) IBOutlet UILabel *tintLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *tintSegment;
@property (retain) CoatingView *coatingView;
@property (retain, nonatomic) IBOutlet UILabel *polarizedPercentLabel;
@property (retain, nonatomic) IBOutlet UISlider *polarizedPercentSlider;

@property (retain, nonatomic) IBOutlet UIView *viewTint;
@property (retain, nonatomic) IBOutlet UIView *viewTintControlBox;
@property (retain, nonatomic) IBOutlet UIView *arControlBox;
@property (retain, nonatomic) IBOutlet UIView *scratchCoatControlBox;
@property (retain, nonatomic) IBOutlet UIView *polarizedControlBox;
@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *modeViews;

@property (retain) NSMutableArray *withoutImages;
@property (retain) NSMutableArray *withImages;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *polarizedColorBtns;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *tintColorBtns;

- (IBAction)tintSliderChanged:(id)sender;
- (IBAction)tintSegmentChanged:(id)sender;
- (IBAction)tintColorBtnClick:(id)sender;
- (IBAction)modeBtnClick:(id)sender;
- (IBAction)modeSegmentChanged:(id)sender;

- (void) applyTint:(DraggableLens*)lens;
- (void) applyTint:(DraggableLens*)lens strength:(float)tintStrength;

- (UIImage*) getTintedImage:(DraggableLens*)lens color:(UIColor*)color;
- (void) displayViewForMode:(int)modeArg;

//-(IBAction) scretchBtnClick : (id)sender;
//- (id)initWithFrame:(CGRect)frame;
@end


@interface DraggableLens : UIImageView
{
	CGPoint dragDistFromCenter;
    UIColor *brushPattern;
    UIBezierPath *myPath;
    CGPoint touchStart;
}
@property (assign) BOOL doesCutOut;
@property (assign) BOOL doesDrag;
@property (assign) BOOL doesTint;
@property (assign) BOOL doesScratch;

@property (retain, nonatomic) UIColor *brushPattern;
@property (retain, nonatomic) UIBezierPath *myPath;
@property (retain, nonatomic) IBOutlet Coating *coatingView;

@end