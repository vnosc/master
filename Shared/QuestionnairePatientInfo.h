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

@interface QuestionnairePatientInfo : BackgroundViewController
@property (retain, nonatomic) IBOutlet UIView *vspAddressView;
@property (retain, nonatomic) IBOutlet UIButton *phoneDDL;
@property (retain, nonatomic) IBOutlet UIButton *altPhoneDDL;
@property (retain, nonatomic) IBOutlet UIButton *hearAboutDDL;

- (IBAction)continueBtnClick:(id)sender;

@end
