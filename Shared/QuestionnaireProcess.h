//
//  QuestionnaireProcess.h
//  Smart-i
//
//  Created by Troy Potts on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QuestionnairePatientInfo.h"
#import "QuestionnairePrimaryInsurance.h"
#import "QuestionnaireMedicalHistory.h" 
#import "QuestionnaireMedicalFamilyHistory.h"
#import "QuestionnaireSocialHistory.h"
#import "QuestionnaireMedicalSystems.h"
#import "QuestionnaireChildDevelopment.h"

@interface QuestionnaireProcess : NSObject

@property (retain, nonatomic) UINavigationController *navigationController;

@property (retain, nonatomic) NSString *patientName;
@property (retain, nonatomic) NSString *patientPhone;
@property (retain, nonatomic) NSDate *patientDOB;

- (void) nextStep;

@end
