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

#import "HeaderLabel.h"

@interface PatientSearch : BackgroundViewController
{
    ServiceObject *_searchResults;
}
@property (retain, nonatomic) IBOutlet UITextField *patientFirstName;
@property (retain, nonatomic) IBOutlet UITextField *patientLastName;
@property (retain, nonatomic) IBOutlet DatePickerTextField *dob;

@property (retain, nonatomic) IBOutlet UILabel *providerNameLbl;
@property (retain, nonatomic) IBOutlet UIView *searchResultsView;
@property (retain, nonatomic) IBOutlet UIView *foundPatientsView;

@property (retain, nonatomic) IBOutlet UIView *searchCriteriaView;
@property (retain, nonatomic) IBOutlet UIView *providerInfoView;
@property (retain, nonatomic) IBOutlet UIView *patientDetailsView;
@property (retain, nonatomic) IBOutlet UIScrollView *patientListSV;
@property (retain, nonatomic) IBOutletCollection(HeaderLabel) NSArray *patientListHeaders;

@property (retain, nonatomic) IBOutlet UIButton *providerDDL;


@property (retain, nonatomic) MBProgressHUD *HUD;

- (IBAction)search:(id)sender;
- (IBAction)cancel:(id)sender;
- (void)loadImagesAndFinish:(id)sender;
- (void)loadPatientImages;
- (void) showPatientList;

- (void)addPatientLabel:(NSString*)text x:(int)x y:(int)y;

-(void) continueToPrescriptionPage;
-(void) continueToNewPatientPage;

@end
