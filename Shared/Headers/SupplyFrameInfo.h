//
//  SupplyFrameInfo.h
//  CyberImaging
//
//  Created by Troy Potts on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplyFrameInfo : BackgroundViewController
{
    int _frameId;
}
@property (retain, nonatomic) IBOutlet UITextField *txtSKU;
@property (retain, nonatomic) IBOutlet UITextField *txtModelNumber;

@property (retain, nonatomic) IBOutlet UITextField *frameMfr;
@property (retain, nonatomic) IBOutlet UITextField *frameModel;
@property (retain, nonatomic) IBOutlet UITextField *frameType;
@property (retain, nonatomic) IBOutlet UITextField *frameColor;
@property (retain, nonatomic) IBOutlet UITextField *frameABox;
@property (retain, nonatomic) IBOutlet UITextField *frameBBox;
@property (retain, nonatomic) IBOutlet UITextField *frameED;
@property (retain, nonatomic) IBOutlet UITextField *frameDBL;

@property (assign) BOOL updateFrame;

- (IBAction)btnSearchSKUClick:(id)sender;
- (IBAction)btnSearchModelNumberClick:(id)sender;

- (IBAction)cancelBtnClick:(id)sender;
- (void)selectFrame:(int)frameId;
- (IBAction)continueWithoutSelectingBtnClick:(id)sender;
- (void) finish;
- (void) cancel;

@end
