//
//  FrameCatelogs.h
//  TryOnApp
//
//  Created by nitesh on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameCollectionView.h"
#import "asyncimageview.h"
@class FrameCollectionView;
@interface FrameCatelogs : UIViewController <MBProgressHUDDelegate>
{
    IBOutlet UIScrollView *frameCatScrollView;
    IBOutlet UIImageView *selectMainFrameImage;
    UIScrollView *imageScrollView;
    AsyncImageView *asyncImage;
    
    NSMutableArray *frameIdArray;
    NSMutableArray *frameTypeArray;
    NSMutableArray *manName;
   // MBProgressHUD *HUD;
    
    UIActivityIndicatorView *indicator;
    
    IBOutlet UILabel *frameColorLbl;
    IBOutlet UILabel *sizeLbl;
    IBOutlet UILabel *frameNameLbl;
    
    IBOutlet UIButton *titelButton;
   
    
}
@property (nonatomic,retain) IBOutlet UIButton *titelButton;
@property (nonatomic,retain)IBOutlet UILabel *frameNameLbl;
@property (nonatomic,retain)IBOutlet UILabel *frameColorLbl;
@property (nonatomic,retain)IBOutlet UILabel *sizeLbl;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain)NSMutableArray *manName;
@property (nonatomic,retain)NSMutableArray *frameIdArray;
@property (nonatomic,retain)NSMutableArray *frameTypeArray;
@property (nonatomic,retain)AsyncImageView *asyncImage;
@property (nonatomic,retain)IBOutlet UIScrollView *imageScrollView;
@property (nonatomic,retain)UIImageView *selectMainFrameImage;
@property (nonatomic,retain)UIScrollView *frameCatScrollView;
-(void)selectCatelogsButton:(id)sender;
-(void)clickCatelogsButton:(id)sender;
-(void)indicaterMethodForCatButton:(id)sender;
-(void)fillImageScrollView;
-(IBAction)saveButtonClickOnCatelogsView:(id)sender;
@end
