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
#import "PatientSearch.h"

@class FrameCollectionView;
@interface FrameCatelogs : BackgroundViewController <MBProgressHUDDelegate>
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
    
    UIButton *selectedCollectionBtn;
    
    IBOutlet UILabel *EyeLbl;
    IBOutlet UILabel *ALbl;
    IBOutlet UILabel *BLbl;
    IBOutlet UILabel *EDLbl;
    IBOutlet UILabel *DBLLbl;
    IBOutlet UILabel *templeLbl;
    
    IBOutlet UIButton *titelButton;
    IBOutlet UIButton *collectionButton;
    
    IBOutlet UIView *frameView;
    
    UIImage *brandImage;
    
    int _selectedFrameIdx;
    
}
@property (nonatomic,retain)IBOutlet UILabel *EyeLbl;
@property (nonatomic,retain)IBOutlet UILabel *ALbl;
@property (nonatomic,retain)IBOutlet UILabel *BLbl;
@property (nonatomic,retain)IBOutlet UILabel *EDLbl;
@property (nonatomic,retain)IBOutlet UILabel *DBLLbl;
@property (nonatomic,retain)IBOutlet UILabel *templeLbl;
@property (nonatomic,retain) IBOutlet UIButton *titelButton;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain)NSMutableArray *manName;
@property (nonatomic,retain)NSMutableArray *frameIdArray;
@property (nonatomic,retain)NSMutableArray *frameTypeArray;
@property (nonatomic,retain)AsyncImageView *asyncImage;
@property (nonatomic,retain)IBOutlet UIScrollView *imageScrollView;
@property (nonatomic,retain)UIImageView *selectMainFrameImage;
@property (nonatomic,retain)UIScrollView *frameCatScrollView;
@property (retain, nonatomic) IBOutlet UILabel *frameNameLabel;

@property (nonatomic, retain) NSString *selectedBrand;

-(void)selectCatelogsButton:(id)sender;
-(void)clickCatelogsButton:(id)sender;
-(void)indicaterMethodForCatButton:(id)sender;
-(void)fillImageScrollView;
- (IBAction)addToFavoritesBtnClick:(id)sender;
- (IBAction)brandSelectBtnClick:(id)sender;
-(IBAction)saveButtonClickOnCatelogsView:(id)sender;
@end
