//
//  BackgroundViewController.h
//  Smart-i
//
//  Created by Troy Potts on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundViewController : UIViewController

@property (assign) NSString* backgroundImageName;
@property (retain) NSString* buttonImageName;
@property (retain) NSString* buttonHighlightedImageName;
@property (retain) UIColor* textColor;
@property (retain) UIColor* highlightedTextColor;
@property (assign) int buttonImageLeftCap;
@property (assign) int buttonImageTopCap;
@property (assign) int heightThreshold;

- (void) applyChangesToSubviews:(UIView*)mv;
- (void) setStretchBackground:(UIView*)v imageName:(NSString*)imageName leftCap:(int)leftCap topCap:(int)topCap;
- (UIImage*) getStretchBackgroundForImage:(NSString*)imageName leftCap:(int)leftCap topCap:(int)topCap;

- (void) setBoxBackground:(UIView*)v;
- (void) setBoxBackgroundLarge:(UIView*)v;
- (void) setDropDownBackground:(UIButton*)btn;

@end
