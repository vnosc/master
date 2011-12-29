//
//  PatientPrescription.h
//  CyberImaging
//
//  Created by Kaushik on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerTextField.h"
#import "PrescriptionTextField.h"
#import "TBXML.h"
#import "ServiceObject.h"
#import "LensSelectionandValidation.h"

@interface PatientPrescription : BackgroundViewController <UITextFieldDelegate, UIAlertViewDelegate> 
{
 
	BOOL modified;
}

- (void) getLatestPrescriptionFromService;
- (void) loadPrescription:(ServiceObject *)prescription;

- (void) getLatestPatientFromService;
- (void) loadPatientData:(ServiceObject *)patient;

- (BOOL) validatePrescriptionValue:(UITextField *)textField showAlert:(BOOL)showAlert;

@property (assign) BOOL continueToSelection;

@property (retain, nonatomic) IBOutlet UITextField *patientId;
@property (retain, nonatomic) IBOutlet DatePickerTextField *patientDOB;
@property (retain, nonatomic) IBOutlet UITextField *patientFirstName;
@property (retain, nonatomic) IBOutlet UITextField *patientLastName;
@property (retain, nonatomic) IBOutlet UIView *prescriptionInfo;
@property (retain, nonatomic) IBOutlet UIView *frameInfo;

@property (retain, nonatomic) IBOutlet UITextField *rSphere;
@property (retain, nonatomic) IBOutlet UITextField *rCylinder;
@property (retain, nonatomic) IBOutlet UITextField *rAxis;
@property (retain, nonatomic) IBOutlet UITextField *rAddition;
@property (retain, nonatomic) IBOutlet UITextField *rPrism1;
@property (retain, nonatomic) IBOutlet UITextField *rBase1;
@property (retain, nonatomic) IBOutlet UITextField *rPrism2;
@property (retain, nonatomic) IBOutlet UITextField *rBase2;

@property (retain, nonatomic) IBOutlet UITextField *lSphere;
@property (retain, nonatomic) IBOutlet UITextField *lCylinder;
@property (retain, nonatomic) IBOutlet UITextField *lAxis;
@property (retain, nonatomic) IBOutlet UITextField *lAddition;
@property (retain, nonatomic) IBOutlet UITextField *lPrism1;
@property (retain, nonatomic) IBOutlet UITextField *lBase1;
@property (retain, nonatomic) IBOutlet UITextField *lPrism2;
@property (retain, nonatomic) IBOutlet UITextField *lBase2;

@property (retain, nonatomic) IBOutlet UITextField *frameMfr;
@property (retain, nonatomic) IBOutlet UITextField *frameModel;
@property (retain, nonatomic) IBOutlet UITextField *frameType;
@property (retain, nonatomic) IBOutlet UITextField *frameColor;
@property (retain, nonatomic) IBOutlet UITextField *frameABox;
@property (retain, nonatomic) IBOutlet UITextField *frameBBox;
@property (retain, nonatomic) IBOutlet UITextField *frameED;
@property (retain, nonatomic) IBOutlet UITextField *frameDBL;
@property (retain, nonatomic) IBOutlet UIImageView *frameIV;
@property (retain, nonatomic) IBOutlet UITextField *packageType;
@property (retain, nonatomic) IBOutlet UITextField *packageId;
@property (retain, nonatomic) IBOutlet UIView *packageInfoView;
@property (nonatomic) BOOL modified;

- (IBAction)validatePrescription:(id)sender;

@end
