//
//  PatientRecord.h
//  Smart-i
//
//  Created by Troy Potts on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientRecord : BackgroundViewController

@property (assign) BOOL alreadyTriedSearch;
@property (assign) BOOL didSelectNewPatient;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;

@property (retain, nonatomic) IBOutlet UILabel *lblPatientName;
@property (retain, nonatomic) IBOutlet UILabel *lblPatientRelation;
@property (retain, nonatomic) IBOutlet UILabel *lblMemberId;
@property (retain, nonatomic) IBOutlet UILabel *lblMemberName;
@property (retain, nonatomic) IBOutlet UILabel *lblAuthNum;
@property (retain, nonatomic) IBOutlet UILabel *lblEffectiveDate;
@property (retain, nonatomic) IBOutlet UILabel *lblExpireDate;
@property (retain, nonatomic) IBOutlet UILabel *lblBirthDate;

@property (retain, nonatomic) IBOutlet UILabel *lblLastExamDate;
@property (retain, nonatomic) IBOutlet UILabel *lblDiagnosisCodes;
@property (retain, nonatomic) IBOutlet UILabel *lblBenefit;
@property (retain, nonatomic) IBOutlet UILabel *lblGroupName;

- (IBAction)searchForDifferentPatient:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)continueBtnClick:(id)sender;

@end
