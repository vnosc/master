//
//  FrameSelectionandValidation.h
//  CyberImaging
//
//  Created by Kaushik on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import "MBProgressHUD.h"

@interface PatientList : BackgroundViewController <UIWebViewDelegate, MBProgressHUDDelegate, UINavigationBarDelegate>
{
	MBProgressHUD *HUD;
	
	BOOL suppressPush;
	int webLoads;
	NSString *firstURL;
	
	NSArray *btnLabels;
	NSArray *btnURLs;
	
    IBOutlet UIButton *selectandcontinue;
}
@property (retain, nonatomic) IBOutlet UINavigationBar *fakeNavBar;
@property (retain, nonatomic) IBOutlet UIToolbar *linkBar;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIWebView *webView2;
@property (assign) BOOL suppressPush;
@property (retain, nonatomic) NSString *firstURL;
@property (assign) int webLoads;
@property (retain, nonatomic) NSArray *btnLabels;
@property (retain, nonatomic) NSArray *btnURLs;

-(IBAction) selectandcontinueBtnClick : (id) sender;
- (void)loadPage:(NSString *)pageName wv:(UIWebView *)wv;
- (void)loadPageMobile:(NSString *)pageName wv:(UIWebView *)wv;
- (void)finishContinue:(id)sender;
@end
