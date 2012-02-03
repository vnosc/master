//
//  PatientMedicalQuestionnaire.h
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundViewController.h"
#import "HeaderLabel.h"

@interface PatientCoverageSummary : BackgroundViewController <UIAlertViewDelegate>
{
    BOOL _didAuthorize;
}
@property (retain, nonatomic) IBOutlet UIView *vspAddressView;
@property (retain, nonatomic) IBOutlet UIScrollView *planScroll;
@property (retain, nonatomic) IBOutlet UIView *planView1;
@property (retain, nonatomic) IBOutlet UIView *planView2;
@property (retain, nonatomic) IBOutlet UIView *planView3;
@property (retain, nonatomic) IBOutlet UIView *planView4;
@property (retain, nonatomic) IBOutlet UILabel *patientNameLabel;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *serviceBtns1;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *serviceBtns2;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *serviceBtns3;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *serviceBtns4;

- (void)goBack;
- (IBAction)selectServiceBtnClick:(id)sender;
- (IBAction)selectAllServiceBtnClick:(id)sender;
- (IBAction)selectAllServiceBtnClick2:(id)sender;
- (IBAction)selectAllServiceBtnClick3:(id)sender;
- (IBAction)selectAllServiceBtnClick4:(id)sender;

- (IBAction)continueBtnClick:(id)sender;
- (IBAction)authorizeDummy:(id)sender;
- (IBAction)notAuthorizeDummy:(id)sender;
- (IBAction)back:(id)sender;

@end
