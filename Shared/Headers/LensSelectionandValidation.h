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
#import "LensOptionSelection.h"

@interface LensSelectionandValidation : BackgroundViewController <UIActionSheetDelegate> {
 
	ListsTableViewController* ltvc;
	
	NSMutableDictionary* materialColors;
	NSMutableDictionary* materialColorHues;
	
	NSMutableDictionary* materialThicknesses;
	
	int selectedMaterialColorId;
}

- (void) loadMaterialData:(int)lensId;
- (void) loadCoveredOptionData:(int)materialId;

- (void) listsTableSelected:(NSNotification*)n;
- (void) listsTableSelectionCleared:(NSNotification*)n;

- (void) getLatestPatientFromService;
- (void) loadPatientData:(ServiceObject *)patient;

- (void) getLatestPrescriptionFromService;
- (void) loadPrescription:(ServiceObject *)prescription;

- (void) getFrameInfoFromService;
- (void) loadFrameData:(ServiceObject *)frame;

- (void) loadMaterialColors;

- (void) removeMaterials;
- (void) removeCoveredOptions;

- (void) displayMaterialColorPopup;


@property (retain, nonatomic) NSMutableDictionary* materialColors;
@property (retain, nonatomic) NSMutableDictionary* materialColorHues;
@property (retain, nonatomic) NSMutableDictionary* materialThicknesses;

@property (nonatomic) int selectedMaterialColorId;

@property (retain, nonatomic) IBOutlet ListsTableViewController *ltvc;

@property (retain, nonatomic) IBOutlet UIView *materialColorView;
@property (retain, nonatomic) IBOutlet UIImageView *lensThicknessImage;
@property (retain, nonatomic) IBOutlet UIImageView *previewImage;

@property (retain, nonatomic) IBOutlet UILabel *recLabel;
@property (retain, nonatomic) IBOutlet UILabel *thicknessLabel;

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
- (IBAction)changeMaterialColor:(id)sender;
- (IBAction)selectAndContinue:(id)sender;

@end
