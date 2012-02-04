//
//  PatientMedicalQuestionnaire.h
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundViewController.h"
#import "HeaderLabel.h"

#import "PaintingView.h"

#import "QuestionnaireMedicalHistory.h"

@interface QuestionnairePrimaryInsurance : BackgroundViewController
@property (retain, nonatomic) IBOutlet UIView *vspAddressView;
@property (retain, nonatomic) IBOutlet UIView *vspAddressView2;

@property (retain, nonatomic) IBOutlet UIButton *primaryRelationshipDDL;
@property (retain, nonatomic) IBOutlet UIButton *secondRelationshipDDL;
@property (retain, nonatomic) IBOutlet UIButton *primaryVisionInsuranceDDL;
@property (retain, nonatomic) IBOutlet UIButton *secondVisionInsuranceDDL;

@property (retain, nonatomic) IBOutlet PaintingView *primarySignatureView;
@property (retain, nonatomic) IBOutlet PaintingView *secondSignatureView;

@property (retain, nonatomic) IBOutlet UITextField *primaryDateField;
@property (retain, nonatomic) IBOutlet UITextField *secondDateFild;

@property (retain, nonatomic) IBOutlet UIButton *primaryUnderstandBtn;
@property (retain, nonatomic) IBOutlet UIButton *secondUnderstandBtn;
- (IBAction)continueBtnClick:(id)sender;

- (IBAction)primaryEraseBtnClick:(id)sender;
- (IBAction)secondEraseBtnClick:(id)sender;
- (IBAction)understandBtnClick:(id)sender;
- (IBAction)relationshipDDLClick:(id)sender;
- (IBAction)insuranceTypeDDLClick:(id)sender;

@end
