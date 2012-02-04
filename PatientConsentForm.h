//
//  PatientConsentForm.h
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundViewController.h"
#import "PaintingView.h"
#import "HeaderLabel.h"

#import "QuestionnairePatientInfo.h"

@interface PatientConsentForm : BackgroundViewController
@property (retain, nonatomic) IBOutlet UIView *vspAddressView;
@property (retain, nonatomic) IBOutlet UIWebView *consentTextWebView;
@property (retain, nonatomic) IBOutlet PaintingView *signatureView;
@property (retain, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (retain, nonatomic) IBOutlet UITextField *dateField;
@property (retain, nonatomic) IBOutlet HeaderLabel *providerNameField;
@property (retain, nonatomic) IBOutlet UIButton *understandBtn;
@property (retain, nonatomic) IBOutlet UITextField *patientNameField;
@property (retain, nonatomic) IBOutlet UITextField *patientPhoneField;
@property (retain, nonatomic) IBOutlet UITextView *patientAddressField;
- (IBAction)testRenderSignature:(id)sender;
- (IBAction)understandBtnClick:(id)sender;
- (IBAction)clearSignatureBtnClick:(id)sender;
- (IBAction)continueBtnClick:(id)sender;

@end
