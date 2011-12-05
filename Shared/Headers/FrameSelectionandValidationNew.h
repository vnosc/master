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

@interface FrameSelectionandValidationNew : BackgroundViewController <UIWebViewDelegate, MBProgressHUDDelegate>
{
	MBProgressHUD *HUD;
	
    IBOutlet UIButton *selectandcontinue;
}
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIWebView *webView2;

-(IBAction) selectandcontinueBtnClick : (id) sender;
- (void)loadPage:(NSString *)pageName wv:(UIWebView *)wv;
- (void)loadPageMobile:(NSString *)pageName wv:(UIWebView *)wv;
- (void)finishContinue:(id)sender;
@end
