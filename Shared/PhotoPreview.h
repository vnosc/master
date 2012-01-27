//
//  PhotoPreview.h
//  TryOnApp
//
//  Created by nitesh on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FbGraph.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PhotoPreview : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate>
{
    FbGraph *fbGraph;
    
    CGFloat firstX;
	CGFloat firstY;
    CGFloat lastScale;
	CGFloat lastRotation;
    UIView *view;
    NSString *photoTakeType;
    UIImagePickerController *imagePickerController;
    UIPopoverController *popOverController;
    UIImageView *preViewImageView;
    UIImageView *leftEye;
    UIImageView *rightEye;
    
    UIView *preViewBottom;
    UIView *spectTryOnView;
    UIView *DoneTryOnView;
    
    UIView *holderview;
    UIView *holderview1;
    
    UIPanGestureRecognizer *panRecognizer1;
    UIPinchGestureRecognizer *pinchRecognizer;
    UIRotationGestureRecognizer *rotationRecognizer;
}
@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic,retain)UIImageView *rightEye,*leftEye;
@property (nonatomic,retain)IBOutlet UIImageView *preViewImageView;

@property (nonatomic,retain)UIImagePickerController *imagePickerController;
@property (nonatomic,retain)NSString *photoTakeType;
-(void)addLeftCircle;
-(void)addRightCircle:(CGRect )size1 image:(NSString *)imageName;
-(void)addSpectTryOnView;

-(IBAction)mailButtonClick:(id)sender;
-(IBAction)fbButtonClick:(id)sender;
-(IBAction)inButtonClick:(id)sender;
-(IBAction)printButtonClick:(id)sender;
-(IBAction)saveButtonClick:(id)sender;
- (UIImage*)screenshot;
@end
