//
//  PatientMedicalQuestionnaire.h
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundViewController.h"
#import "HeaderLabel.h"

@interface QuestionnaireMedicalHistory : BackgroundViewController
@property (retain, nonatomic) IBOutlet UIView *vspAddressView;
@property (retain, nonatomic) IBOutlet UIButton *phoneDDL;
@property (retain, nonatomic) IBOutlet UIButton *altPhoneDDL;
@property (retain, nonatomic) IBOutlet UIButton *contactLensTypeDDL;

- (IBAction)continueBtnClick:(id)sender;

@end
