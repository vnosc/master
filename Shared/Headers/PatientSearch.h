//
//  PatientSearch.h
//  CyberImaging
//
//  Created by Troy Potts on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TBXML.h"
#import "ServiceObject.h"
#import "DatePickerTextField.h"

@interface PatientSearch : BackgroundViewController

@property (retain, nonatomic) IBOutlet UITextField *patientId;
@property (retain, nonatomic) IBOutlet DatePickerTextField *dob1;

@property (retain, nonatomic) IBOutlet UITextField *patientLastName;
@property (retain, nonatomic) IBOutlet DatePickerTextField *dob2;

- (IBAction)searchByPatientId:(id)sender;
- (IBAction)searchByLastName:(id)sender;
- (IBAction)newPatient:(id)sender;
- (IBAction)cancel:(id)sender;

-(void) continueToPrescriptionPage;
-(void) continueToNewPatientPage;

@end
