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

@property (retain, nonatomic) IBOutlet UITextField *patientFirstName;
@property (retain, nonatomic) IBOutlet UITextField *patientLastName;
@property (retain, nonatomic) IBOutlet DatePickerTextField *dob;

@property (retain, nonatomic) IBOutlet UILabel *providerNameLbl;

@property (retain, nonatomic) IBOutlet UIView *memberDetailsView;
@property (retain, nonatomic) IBOutlet UIScrollView *patientListSV;
@property (retain, nonatomic) IBOutlet UILabel *patientListHeader1;
@property (retain, nonatomic) IBOutlet UILabel *patientListHeader2;
@property (retain, nonatomic) IBOutlet UILabel *patientListHeader3;

@property (retain, nonatomic) MBProgressHUD *HUD;

- (IBAction)search:(id)sender;
- (IBAction)cancel:(id)sender;
- (void)loadImagesAndFinish:(id)sender;
- (void)loadPatientImages;
- (void) showMemberDetails;

-(void) continueToPrescriptionPage;
-(void) continueToNewPatientPage;

@end
