//
//  SelectSpech.h
//  CyberImaging
//
//  Created by jay gurudev on 9/23/11.
//  Copyright 2011 software house. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ThumbImageView.h"
@interface SelectSpech : BackgroundViewController <UIGestureRecognizerDelegate,ThumbImageViewDelegate>
{
    
	CGFloat lastScale;
	CGFloat lastRotation;
	IBOutlet UIScrollView *scroll;
	CGFloat firstX;
	CGFloat firstY;	
	UIView *scrollImageView;
	UIImageView *captureImage1;
	UIImageView *captureImage2;
	UIImageView *selectedImage;
	UIImage *image;
	IBOutlet UIScrollView *scrollimage;
	UIView *frameView;
	UIImageView *imageview;
	UIView *holderView;
}
@property (nonatomic ,retain) IBOutlet UIScrollView *scrollimage;
@property (nonatomic ,retain) IBOutlet UIScrollView *scroll;

@property (nonatomic ,retain) UIImage *image;
@property (nonatomic ,retain) IBOutlet UIImageView *captureImage1;
@property (nonatomic ,retain) IBOutlet UIImageView *captureImage2;
@property (nonatomic ,retain) IBOutlet UIImageView *selectedImage;
-(IBAction)ResizeSpect:(id)sender;
@end
