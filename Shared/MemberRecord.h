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

@interface MemberRecord : BackgroundViewController

@property (retain, nonatomic) IBOutlet UITextField *memberSSN;
@property (retain, nonatomic) IBOutlet UITextField *memberId;
@property (retain, nonatomic) IBOutlet DatePickerTextField *dob;

@property (retain, nonatomic) IBOutlet UITextField *memberFirstName;
@property (retain, nonatomic) IBOutlet UITextField *memberLastName;
@property (retain, nonatomic) IBOutlet DatePickerTextField *memberDate;

@property (retain, nonatomic) IBOutlet UILabel *memberNameLbl;
@property (retain, nonatomic) IBOutlet UILabel *memberPlanLbl;
@property (retain, nonatomic) IBOutlet UILabel *memberPlanTypeDescLbl;

@property (retain, nonatomic) IBOutlet UIView *memberInfoView;
@property (retain, nonatomic) IBOutlet UIView *authView;
@property (retain, nonatomic) IBOutlet UIView *authSubView;
@property (retain, nonatomic) IBOutlet UIView *patientListView;
@property (retain, nonatomic) IBOutlet UIView *patientListSubview;

@property (retain, nonatomic) IBOutlet UIView *memberDetailsView;
@property (retain, nonatomic) IBOutlet UIScrollView *patientListSV;
@property (retain, nonatomic) IBOutlet UIView *patientListHeaderView;
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
