//
//  PatientMedicalQuestionnaire.h
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundViewController.h"
#import "HeaderLabel.h"

#import "QuestionnairePrimaryInsurance.h"

@interface QuestionnairePatientInfo : BackgroundViewController <UIActionSheetDelegate>
@property (retain, nonatomic) IBOutlet UIView *vspAddressView;
@property (retain, nonatomic) IBOutlet UIButton *phoneDDL;
@property (retain, nonatomic) IBOutlet UIButton *altPhoneDDL;
@property (retain, nonatomic) IBOutlet UIButton *hearAboutDDL;

@property (retain, nonatomic) IBOutlet UITextField *patientNameField;
@property (retain, nonatomic) IBOutlet UITextField *patientPhoneField;
@property (retain, nonatomic) IBOutlet UITextField *providerNameField;

@property (retain, nonatomic) NSString* patientName;
@property (retain, nonatomic) NSString* patientPhone;

- (IBAction)continueBtnClick:(id)sender;
- (IBAction)phoneDDLClick:(id)sender;
- (IBAction)hearAboutDDLClick:(id)sender;

@end
