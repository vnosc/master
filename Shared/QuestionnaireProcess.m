//
//  QuestionnaireProcess.m
//  Smart-i
//
//  Created by Troy Potts on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionnaireProcess.h"

@implementation QuestionnaireProcess
{
    int processStep;
}

@synthesize navigationController;

@synthesize patientName;
@synthesize patientDOB;
@synthesize patientPhone;

- (id) init
{
    if (self = [super init])
    {
        processStep = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionnairePageFinished:) name:@"QuestionnairePageDidFinish" object:nil];
    }
    return self;
}

- (void) questionnairePageFinished:(NSNotification*)n
{
    if (processStep == 1)
    {
        QuestionnairePatientInfo *p = [n object];
        
        self.patientDOB = p.patientDOBField.datePicker.date;
        
        /*[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        [dateFormatter setDateFormat:@"YYYY-MM-DD"];
        
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:];
        
        [NSDate p.patientDOBField.text
        self.patientDOB = */
        
        NSLog(@"patientDOB %@", patientDOB);
    }
    [self nextStep];
}

- (void) nextStep
{
    
    if (processStep == 0)
    {
        QuestionnairePatientInfo *p = [[QuestionnairePatientInfo alloc] init];
        p.title = @"Patient Questionnaire";
        p.patientName = self.patientName;
        p.patientPhone = self.patientPhone;
        [self.navigationController pushViewController:p animated:YES];
    }
    else if (processStep == 1)
    {
        QuestionnairePrimaryInsurance *p = [[QuestionnairePrimaryInsurance alloc] init];
        p.title = @"Patient Questionnaire";
        [self.navigationController pushViewController:p animated:YES];
    }
    else if (processStep == 2)
    {
        QuestionnaireMedicalHistory *p = [[QuestionnaireMedicalHistory alloc] init];
        p.title = @"Patient Questionnaire";
        [self.navigationController pushViewController:p animated:YES];
    }
    else if (processStep == 3)
    {
        QuestionnaireMedicalFamilyHistory *p = [[QuestionnaireMedicalFamilyHistory alloc] init];
        p.title = @"Patient Questionnaire";
        [self.navigationController pushViewController:p animated:YES];
    }
    else if (processStep == 4)
    {
        QuestionnaireSocialHistory *p = [[QuestionnaireSocialHistory alloc] init];
        p.title = @"Patient Questionnaire";
        [self.navigationController pushViewController:p animated:YES];
    }
    else if (processStep == 5)
    {
        QuestionnaireMedicalSystems *p = [[QuestionnaireMedicalSystems alloc] init];
        p.title = @"Patient Questionnaire";
        [self.navigationController pushViewController:p animated:YES];
    }
    else if (processStep == 6)
    {
        NSDate *today = [NSDate date];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        int years = [[gregorian components:NSYearCalendarUnit fromDate:self.patientDOB toDate:[NSDate date] options:0] year];
        [gregorian release];
        
        if (years < 18)
        {
            QuestionnaireChildDevelopment *p = [[QuestionnaireChildDevelopment alloc] init];
            p.title = @"Patient Questionnaire";
            [self.navigationController pushViewController:p animated:YES];
        }
        else
        {        
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (processStep == 7)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    processStep++;
    

    
}

@end
