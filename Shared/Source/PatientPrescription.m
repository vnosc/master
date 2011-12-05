//
//  PatientPrescription.m
//  CyberImaging
//
//  Created by Kaushik on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PatientPrescription.h"

extern ServiceObject* mobileSessionXML;

extern ServiceObject* patientXML;
extern ServiceObject* prescriptionXML;
extern ServiceObject* frameXML;

extern UIImage* patientImage1;
extern UIImage* patientImageProg;

@implementation PatientPrescription

@synthesize patientId;
@synthesize patientDOB;
@synthesize patientFirstName;
@synthesize patientLastName;

@synthesize rSphere;
@synthesize rCylinder;
@synthesize rAxis;
@synthesize rAddition;
@synthesize rPrism1;
@synthesize rBase1;
@synthesize rPrism2;
@synthesize rBase2;

@synthesize lSphere;
@synthesize lCylinder;
@synthesize lAxis;
@synthesize lAddition;
@synthesize lPrism1;
@synthesize lBase1;
@synthesize lPrism2;
@synthesize lBase2;

@synthesize frameMfr;
@synthesize frameModel;
@synthesize frameType;
@synthesize frameColor;
@synthesize frameABox;
@synthesize frameBBox;
@synthesize frameED;
@synthesize frameDBL;

@synthesize frameIV;
@synthesize packageType;
@synthesize packageId;
@synthesize packageInfoView;

@synthesize modified;
@synthesize continueToSelection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.modified = NO;
		self.continueToSelection = NO;
    }
    return self;
}

- (void)dealloc
{
	[rSphere release];
	[rCylinder release];
	[rAxis release];
	[rAddition release];
	[rPrism1 release];
	[rBase1 release];
	[rPrism2 release];
	[rBase2 release];
	
	[lSphere release];
	[lCylinder release];
	[lAxis release];
	[lAddition release];
	[lPrism1 release];
	[lBase1 release];
	[lPrism2 release];
	[lBase2 release];
	
	[frameMfr release];
	[frameModel release];
	[frameType release];
	[frameColor release];
	[frameABox release];
	[frameBBox release];
	[frameED release];
	[frameDBL release];
	
	[patientId release];
	
	[patientDOB release];
	[patientFirstName release];
	[patientLastName release];
	[packageId release];
	[packageInfoView release];
	[packageType release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//NSLog(@"PatientXML in PP: %@", patientXML);
	//NSLog(@"PatientXMLRoot in PP: %@", [TBXML textForElement:patientXML.rootXMLElement]);
	
	//TBXMLElement *root = [patientXML rootXMLElement];
	
	//TBXMLElement *idEle = [TBXML childElementNamed:@"memberId" parentElement:patientXML.rootXMLElement];
	//NSString* memberId = [TBXML textForElement:idEle];
	//[patientId setText:memberId];
	
	//[self loadPatientData];
	[self getLatestPatientFromService];
	
	[self getFrameInfoFromService];
	
	patientDOB.title = @"Date of Birth";
	
	[self getLatestPrescriptionFromService];
	
	int pkgId = [mobileSessionXML getIntValueByName:@"packageId"];
	
	if (pkgId == 0)
	{
		self.packageInfoView.hidden = YES;
	}
	else
	{
		ServiceObject* so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetLensTypePackageAssociationInfo?associationId=%d", pkgId] categoryKey:@"" startTag:@"Table"];
		
		if ([so hasData])
		{
			self.packageType.text = [so getTextValueByName:@"Table1/Package"];
			self.packageId.text = [NSString stringWithFormat:@"%d", pkgId];
		}
		self.packageInfoView.hidden = NO;
	}
    // Do any additional setup after loading the view from its nib.
}

- (void) getLatestPatientFromService
{

	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	patientXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientIdv]];
	
	NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowPatientImage.aspx?patientId=%d", patientIdv]]];
	patientImage1 = [[UIImage imageWithData:imageData] retain];
	
	//imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowPatientImage.aspx?patientId=%d&type=prog", patientIdv]]];
	imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowPatientImage.aspx?patientId=10003&type=prog"]]];
	patientImageProg = [[UIImage imageWithData:imageData] retain];
	
	[imageData release];
	
	if ([patientXML hasData])
	{
		[self loadPatientData:patientXML];
	}

}

- (void) loadPatientData:(ServiceObject *)patient
{
	[patientId setText:[patient getTextValueByName:@"memberId"]];
	[patientDOB setText:[patient getTextValueByName:@"dateOfBirth"]];
	[patientFirstName setText:[patient getTextValueByName:@"firstName"]];
	[patientLastName setText:[patient getTextValueByName:@"lastName"]];
}

- (void) getLatestPrescriptionFromService
{
	NSString *url=[[NSString alloc]initWithFormat:@"http://smart-i.ws/mobilewebservice.asmx/GetPrescriptionInfoByPatientId?patientId=%@&number=1", [patientXML getTextValueByName:@"patientId"]];
	
	TBXML *tbxml= [TBXML tbxmlWithURL:[NSURL URLWithString:url]];
	prescriptionXML = [[ServiceObject alloc] initWithTBXML:tbxml];

	if ([prescriptionXML hasData])
	{
		[self loadPrescription:prescriptionXML];
		
		int oldPresId = [mobileSessionXML getIntValueByName:@"prescriptionId"];
		if (oldPresId == 0)
		{
			[mobileSessionXML setObject:[NSNumber numberWithInt:[prescriptionXML getIntValueByName:@"prescriptionId"]] forKey:@"prescriptionId"];
			[mobileSessionXML updateMobileSessionData];
		}
	}
	else
	{
		NSLog(@"Invalid response from web service at: %@", url);
	}

}

- (void) loadPrescription:(ServiceObject *)prescription
{
	self.rSphere.text = [prescription getTextValueByName:@"rSphere"];
	self.rCylinder.text = [prescription getTextValueByName:@"rCylinder"];
	self.rAxis.text = [prescription getTextValueByName:@"rAxis"];
	self.rAddition.text = [prescription getTextValueByName:@"rAddition"];
	self.rPrism1.text = [prescription getTextValueByName:@"rPrism1"];
	self.rBase1.text = [prescription getTextValueByName:@"rBase1"];
	self.rPrism2.text = [prescription getTextValueByName:@"rPrism2"];
	self.rBase2.text = [prescription getTextValueByName:@"rBase2"];
	
	self.lSphere.text = [prescription getTextValueByName:@"lSphere"];
	self.lCylinder.text = [prescription getTextValueByName:@"lCylinder"];
	self.lAxis.text = [prescription getTextValueByName:@"lAxis"];
	self.lAddition.text = [prescription getTextValueByName:@"lAddition"];
	self.lPrism1.text = [prescription getTextValueByName:@"lPrism1"];
	self.lBase1.text = [prescription getTextValueByName:@"lBase1"];
	self.lPrism2.text = [prescription getTextValueByName:@"lPrism2"];
	self.lBase2.text = [prescription getTextValueByName:@"lBase2"];
}

- (void) getFrameInfoFromService
{	
	int frameIdx = [mobileSessionXML getIntValueByName:@"frameId"];
	frameXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetFrameInfoByFrameId?frameId=%d", frameIdx]];
	
	NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowFrameImage.aspx?frameId=%d", frameIdx]]];
	self.frameIV.image = [[UIImage imageWithData:imageData] retain];
	
	if ([frameXML hasData])
	{
		[self loadFrameData:frameXML];
	}
	else
	{
		NSLog(@"Invalid response from web service");
	}
}

- (void) loadFrameData:(ServiceObject *)frame
{
	self.frameMfr.text = [frame getTextValueByName:@"FrameManufacturer"];
	self.frameModel.text = [frame getTextValueByName:@"FrameModel"];
	self.frameType.text = [frame getTextValueByName:@"FrameStyle"];
	self.frameColor.text = [frame getTextValueByName:@"FrameColor"];
	self.frameABox.text = [frame getTextValueByName:@"ABox"];
	self.frameBBox.text = [frame getTextValueByName:@"BBox"];
	self.frameED.text = [frame getTextValueByName:@"ED"];
	self.frameDBL.text = [frame getTextValueByName:@"DBL"];
}

- (void)viewDidUnload
{
	[self setRSphere:nil];
	[self setRCylinder:nil];
	[self setRAxis:nil];
	[self setRAddition:nil];
	[self setRPrism1:nil];
	[self setRBase1:nil];
	[self setRPrism2:nil];
	[self setRBase2:nil];
	
	[self setLSphere:nil];
	[self setLCylinder:nil];
	[self setLAxis:nil];
	[self setLAddition:nil];
	[self setLPrism1:nil];
	[self setLBase1:nil];
	[self setLPrism2:nil];
	[self setLBase2:nil];
	
	[self setFrameMfr:nil];
	[self setFrameModel:nil];
	[self setFrameType:nil];
	[self setFrameColor:nil];
	[self setFrameABox:nil];
	[self setFrameBBox:nil];
	[self setFrameED:nil];
	[self setFrameDBL:nil];
	
	[self setPatientId:nil];
	
	[self setPatientDOB:nil];
	[self setPatientFirstName:nil];
	[self setPatientLastName:nil];

	[self setPackageId:nil];
	[self setPackageInfoView:nil];
	[self setPackageType:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) dateSelected:(id)sender
{
	NSLog(@"Button Down");
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	NSLog(@"textFieldShouldBeginEditing");
	//DatePickerTextField* dttf = (DatePickerTextField *) textField;
	//[dttf displayPopover];
	//return NO;
	return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
	NSLog(@"textFieldShouldEndEditing");

//	BOOL isValid = 
	[self validatePrescriptionValue:textField showAlert:YES];
	
	return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSCharacterSet *numberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.-"] invertedSet];
	
	NSRange matchRange = [string rangeOfCharacterFromSet:numberSet];
	
	BOOL isValid = (matchRange.location != 0 || string.length == 0);
	
	NSLog(@"%d-%d -> %@ (match: %d-%d) %@", range.location, range.location + range.length, string, matchRange.location, matchRange.location + matchRange.length, isValid ? @"YES" : @"NO");
	
	if (isValid)
	{
		textField.textColor = [UIColor blackColor];
	}
	else
	{
		textField.textColor = [UIColor redColor];
	}
	
	return isValid;
	
}

- (IBAction)validatePrescription:(id)sender 
{
		NSLog(@"%@", patientDOB.delegate);
	
	BOOL isValid = YES;
	
	self.modified = NO;
	
	NSLog(@"Validating prescription");
	
	isValid = isValid && [self validatePrescriptionValue:self.rSphere showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.rCylinder showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.rAxis showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.rAddition showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.rPrism1 showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.rBase1 showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.rPrism2 showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.rBase2 showAlert:isValid];
	
	isValid = isValid && [self validatePrescriptionValue:self.lSphere showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.lCylinder showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.lAxis showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.lAddition showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.lPrism1 showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.lBase1 showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.lPrism2 showAlert:isValid];
	isValid = isValid && [self validatePrescriptionValue:self.lBase2 showAlert:isValid];

	if (isValid)
	{
//		NSString* result = 
		
		NSLog(@"Should we insert new prescription? %@", self.modified ? @"YES" : @"NO");
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Validation Successful" message:@"The frame you have selected supports this prescription." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
}

- (BOOL) validatePrescriptionValue:(UITextField *)textField showAlert:(BOOL)showAlert
{	
	NSString* value = textField.text;
	//if ([textField.text length] == 0)
	//	value = nil;
	
	PrescriptionTextField* ptf = (PrescriptionTextField*) textField;
	
	if ([ptf.firstSet floatValue] != [ptf.text floatValue])
	{
		self.modified = YES;
		NSLog(@"Firstset %@ is different from text %@", ptf.firstSet, ptf.text);
	}
	
	NSString* name = ptf.prescriptionType;
	
	NSString* result = [ServiceObject getStringFromServiceMethod:[NSString stringWithFormat:@"ValidateFrameWithPrescriptionSingle?frameId=%d&validationElement=%@&value=%@", [mobileSessionXML getIntValueByName:@"frameId"], name, value]];
	
	BOOL isValid = [result length] == 0;
	
	textField.textColor = isValid ? [UIColor blackColor] : [UIColor redColor];
	
	if (!isValid && showAlert)
	{
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Invalid %@", name] message:[NSString stringWithFormat:@"%@ %@", ptf.eyeName, result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
		//[textField becomeFirstResponder];
	}
	
	return isValid;
}

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([alertView.title hasPrefix:@"Invalid"])
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else
	{
		
		if (self.modified)
		{
			NSString* newPrescriptionId = [ServiceObject getStringFromServiceMethod:[NSString stringWithFormat:
																					 @"CreateNewPrescriptionForPatient?patientId=%@&rSphere=%@&rCylinder=%@&rAxis=%@&rAddition=%@&rPrism1=%@&rBase1=%@&rPrism2=%@&rBase2=%@&lSphere=%@&lCylinder=%@&lAxis=%@&lAddition=%@&lPrism1=%@&lBase1=%@&lPrism2=%@&lBase2=%@", [mobileSessionXML getTextValueByName:@"patientId"], self.rSphere.text, self.rCylinder.text, self.rAxis.text, self.rAddition.text, self.rPrism1.text, self.rBase1.text, self.rPrism2.text, self.rBase2.text, self.lSphere.text, self.lCylinder.text, self.lAxis.text, self.lAddition.text, self.lPrism1.text, self.lBase1.text, self.lPrism2.text, self.lBase2.text]];
			
			[mobileSessionXML setObject:newPrescriptionId forKey:@"prescriptionId"];
			
			[mobileSessionXML updateMobileSessionData];
		}
		
		if (self.continueToSelection)
		{
			LensSelectionandValidation *lensSelect=[[LensSelectionandValidation alloc]init];
			lensSelect.title=@"Lens/Material Selection";
			lensSelect.tabBarItem.title = lensSelect.title;
			[self.navigationController pushViewController:lensSelect animated:YES];
		}
		else
		{
			[self.navigationController popToRootViewControllerAnimated:YES];
		}

	}
}

@end
