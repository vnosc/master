//
//  LensSelectionandValidation.h
//  CyberImaging
//
//  Created by Kaushik on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListsTableViewController.h"
#import "DatePickerTextField.h"
#import "ProgressiveSelection.h"

@interface LensOptionSelection : BackgroundViewController <UIActionSheetDelegate, UIAlertViewDelegate> {
	
	ListsTableViewController* ltvc;
	
	NSMutableDictionary* tintColors;
	NSMutableDictionary* tintColorHues;
	
	int selectedTintColorId;
}

- (void) loadLensTypeData:(ServiceObject *)lens;
- (void) loadMaterialData:(ServiceObject *)material;
- (void) loadLensOptionData:(int)materialId;

- (void) listsTableSelected:(NSNotification*)n;
- (void) listsTableSelectionCleared:(NSNotification*)n;

- (void) getLatestPatientFromService;
- (void) loadPatientData:(ServiceObject *)patient;

- (void) getLatestPrescriptionFromService;
- (void) loadPrescription:(ServiceObject *)prescription;

- (void) getFrameInfoFromService;
- (void) loadFrameData:(ServiceObject *)frame;

- (void) loadTintColors:(NSString*)value;

- (void) displayTintColorPopup;


@property (retain, nonatomic) NSMutableDictionary* tintColors;
@property (retain, nonatomic) NSMutableDictionary* tintColorHues;

@property (nonatomic) int selectedTintColorId;

@property (retain, nonatomic) IBOutlet ListsTableViewController *ltvc;
@property (retain, nonatomic) IBOutlet UITextField *selectedLensType;
@property (retain, nonatomic) IBOutlet UITextField *selectedMaterial;

@property (retain, nonatomic) IBOutlet UIView *materialColorView;
@property (retain, nonatomic) IBOutlet UIView *tintColorView;
@property (retain, nonatomic) IBOutlet UIImageView *withOptionImage;
@property (retain, nonatomic) IBOutlet UIImageView *withoutOptionImage;
@property (retain, nonatomic) IBOutlet UIImageView *previewImage;

@property (retain, nonatomic) IBOutlet UITextField *memberId;
@property (retain, nonatomic) IBOutlet UITextField *patientName;

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

- (IBAction)changeTintColor:(id)sender;

- (IBAction)selectAndContinue:(id)sender;

@end
