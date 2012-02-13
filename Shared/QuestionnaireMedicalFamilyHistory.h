//
//  PatientMedicalQuestionnaire.h
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundViewController.h"
#import "HeaderLabel.h"
#import "PaintingView.h"

#import "QuestionnaireSocialHistory.h"

@interface QuestionnaireMedicalFamilyHistory : BackgroundViewController
@property (retain, nonatomic) IBOutlet UIView *vspAddressView;
@property (retain, nonatomic) IBOutlet PaintingView *initialSigView;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *noBtns;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *yesBtns;
@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *yesNoPanels;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *relationDDLs;

- (IBAction)yesNoBtnClick:(id)sender;

- (IBAction)continueBtnClick:(id)sender;
- (IBAction)relationDDLClick:(id)sender;
- (IBAction)sigEraseBtnClick:(id)sender;

@end
