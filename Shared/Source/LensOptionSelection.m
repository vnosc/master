//
//  LensSelectionandValidation.m
//  CyberImaging
//
//  Created by Kaushik on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LensOptionSelection.h"
#import "QuartzCore/QuartzCore.h"

extern ServiceObject* frameXML;
extern ServiceObject* patientXML;
extern ServiceObject* prescriptionXML;
extern ServiceObject* mobileSessionXML;
extern ServiceObject* lensTypeXML;
extern ServiceObject* materialXML;

extern UIImage* patientImage1;

extern UIColor* selectedMaterialColor;

@implementation LensOptionSelection

@synthesize tintColors;
@synthesize tintColorHues;

@synthesize selectedTintColorId;

@synthesize memberId;
@synthesize patientName;

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

@synthesize ltvc;
@synthesize selectedLensType;
@synthesize selectedMaterial;

@synthesize materialColorView;
@synthesize tintColorView;
@synthesize withOptionImage;
@synthesize withoutOptionImage;
@synthesize previewImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
	
	[memberId release];
	
	[patientName release];
	
	[frameMfr release];
	[frameModel release];
	[frameType release];
	[frameColor release];
	[frameABox release];
	[frameBBox release];
	[frameED release];
	[frameDBL release];
	
	[ltvc release];
	[withOptionImage release];
	[withoutOptionImage release];
	[previewImage release];

	[tintColorView release];
	[selectedLensType release];
	[selectedMaterial release];
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
	
	[self addChildViewController:self.ltvc];
	
	self.tintColors = [[NSMutableDictionary alloc] init];
	self.tintColorHues = [[NSMutableDictionary alloc] init];

	self.tintColorView.hidden = YES;
	
	//int si = [self.ltvc addSection:@"Lens Options" options:0];
	
	//[self.ltvc addOptionForSection:si option:@"Single Vision" optionValue:@"24"];
	//[self.ltvc addOptionForSection:si option:@"Bifocal" optionValue:@"37"];
	//[self.ltvc addOptionForSection:si option:@"Trifocal" optionValue:@"26"];
	//[self.ltvc addOptionForSection:si option:@"Progressive >" optionValue:@"43"];

	int materialId = [mobileSessionXML getIntValueByName:@"materialId"];
	
	[self loadLensOptionData:materialId];
	
	CALayer* l3 = [self.tintColorView layer];
	l3.borderWidth = 4;
	l3.cornerRadius = 30;
	
	CALayer* l4 = [self.materialColorView layer];
	l4.borderWidth = 4;
	l4.cornerRadius = 30;
	
	CALayer* l2 = [self.previewImage layer];
	l2.borderWidth = 2;
	l2.cornerRadius = 10;
	
	CALayer* l1 = [self.withOptionImage layer];
	l1.borderWidth = 2;
	l1.cornerRadius = 10;
	
	CALayer* l5 = [self.withoutOptionImage layer];
	l5.borderWidth = 2;
	l5.cornerRadius = 10;
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(listsTableSelected:)
	 name:@"ListsTableViewSelectionDidChangeNotification"
	 object:self.ltvc];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(listsTableSelectionCleared:)
	 name:@"ListsTableViewSelectionDidClearNotification"
	 object:self.ltvc];

	[self getLatestPatientFromService];
	
	[self getLatestPrescriptionFromService];
	
	[self getFrameInfoFromService];
	
	[self getLensAndMaterialInfoFromService];
	
	self.materialColorView.backgroundColor = selectedMaterialColor;
	
	self.previewImage.image = patientImage1;
			//[self.ltvc init];
    // Do any additional setup after loading the view from its nib.
}

- (void) getLatestPatientFromService
{	
	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	patientXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientIdv]];
	
	if ([patientXML hasData])
	{
		[self loadPatientData:patientXML];
	}
	else
	{
		NSLog(@"Invalid response from web service");
	}
}

- (void) loadPatientData:(ServiceObject *)patient
{
	[memberId setText:[patient getTextValueByName:@"memberId"]];
	[patientName setText:[NSString stringWithFormat:@"%@ %@", [patient getTextValueByName:@"firstName"], [patient getTextValueByName:@"lastName"]]];
}

- (void) getLatestPrescriptionFromService
{	
	prescriptionXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPrescriptionInfoByPatientId?patientId=%@&number=1", [patientXML getTextValueByName:@"PatientId"]]];
	
	if ([prescriptionXML hasData])
	{
		[self loadPrescription:prescriptionXML];
	}
	else
	{
		NSLog(@"Invalid response from web service at: %@", prescriptionXML.url);
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

- (void) getLensAndMaterialInfoFromService
{		
	if ([lensTypeXML hasData])
	{
		[self loadLensTypeData:lensTypeXML];
	}
	if ([materialXML hasData])
	{
		[self loadMaterialData:materialXML];
	}
}

- (void) loadLensTypeData:(ServiceObject *)lens
{
	self.selectedLensType.text = [lens getTextValueByName:@"LensType"];
}

- (void) loadMaterialData:(ServiceObject *)material
{
	self.selectedMaterial.text = [material getTextValueByName:@"Material"];
}

- (void)loadLensOptionData:(int)materialId
{	
	int si = [self.ltvc addOrFindSection:@"Lens Options" options:(1<<2)];
	
	[self.ltvc clearSection:si];
	
	ServiceObject* so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetLensOptionInfoByMaterialId?materialId=%d", materialId] categoryKey:@"" startTag:@"Table"];
	
	BOOL hasObjs = YES;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			NSString* option = [so getTextValueByName:[NSString stringWithFormat:@"%@/LensOption", key]];
			NSString* optionId = [so getTextValueByName:[NSString stringWithFormat:@"%@/LensOptionId", key]];
			
			[self.ltvc addOptionForSection:si option:option optionValue:optionId];
		}
		else
			hasObjs = NO;
	}
	
}

- (void)listsTableSelected:(NSNotification*)n
{
	NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);
	
	NSInteger sectionIndex = [[n.userInfo objectForKey:@"sectionIndex"] integerValue];
	NSInteger selectedRow = [[n.userInfo objectForKey:@"row"] integerValue];
	NSLog(@"%d", selectedRow);
	
	if (sectionIndex == 0)
	{
		NSString* value = [self.ltvc getOptionValueForSection:sectionIndex optionIndex:selectedRow];
		
		NSLog(@"Lens option selected %@", value);
		
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowLensOptionImage.aspx?lensOptionId=%@&type=with", value]]];
		self.withOptionImage.image = [UIImage imageWithData:imageData];

		NSData* imageData2 = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowLensOptionImage.aspx?lensOptionId=%@&type=without", value]]];
		self.withoutOptionImage.image = [UIImage imageWithData:imageData2];
		
		[imageData release];
		[imageData2 release];
		
		if ([value intValue] == 25 || [value intValue] == 22)
		{
			[self loadTintColors:value];
			
			if ([self.tintColors count] > 0)
				[self displayTintColorPopup];
		}
		//[self loadCoveredOptionData:[value intValue]];
	}
	
	self.tintColorView.hidden = [self.tintColors count] == 0;
	
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
	
	[self setMemberId:nil];
	
	[self setPatientName:nil];

	[self setFrameMfr:nil];
	[self setFrameModel:nil];
	[self setFrameType:nil];
	[self setFrameColor:nil];
	[self setFrameABox:nil];
	[self setFrameBBox:nil];
	[self setFrameED:nil];
	[self setFrameDBL:nil];
	
	[self setLtvc:nil];

	[self setTintColorView:nil];

	[self setPreviewImage:nil];

	[self setTintColorView:nil];
	[self setSelectedLensType:nil];
	[self setSelectedMaterial:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void) loadTintColors:(NSString*)value
{
	[self.tintColors removeAllObjects];
	[self.tintColorHues removeAllObjects];
	
	self.tintColorView.backgroundColor = [UIColor whiteColor];
	
	if ([self.ltvc numberOfSectionsInTableView:self.ltvc.tableView] > 0)
	{
	
		NSArray* selectOption = [self.ltvc getSelectedForSection:0];

		BOOL shouldChange = YES;
		
		int valueInt = [value intValue];
		
		if ((valueInt == 22 && [selectOption containsObject:@"25"]) || (valueInt == 25 && [selectOption containsObject:@"22"]))
			shouldChange = NO;

		shouldChange = shouldChange && [selectOption containsObject:value];
		
		if(shouldChange)
		{
		
			ServiceObject* mc = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetTintColorsByLensOptionId?lensOptionId=%@", value] categoryKey:@"" startTag:@"Table"];
			
			if ([mc hasData])
			{
				BOOL hasObjs = YES;
				for (int cnt=1; hasObjs; cnt++)
				{
					NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
					id obj = [mc.dict objectForKey:key];
					
					if (obj)
					{
						NSString* pv = [mc getTextValueByName:[NSString stringWithFormat:@"%@/PropertyValue", key]];
						NSString* pvId = [mc getTextValueByName:[NSString stringWithFormat:@"%@/PropertyValueId", key]];
						NSString* pvC = [mc getTextValueByName:[NSString stringWithFormat:@"%@/HexColor", key]];
						[self.tintColors setObject:pvId forKey:pv];
						[self.tintColorHues setObject:pvC forKey:pv];
						NSLog(@"adding tint color %@", pv);
					}
					else
						hasObjs = NO;
				}

			}
		}
		
		self.tintColorView.hidden = [self.tintColors count] == 0;
		
		NSLog(@"tint colors count: %d", [self.tintColors count]);
		NSLog(@"tint colors: %@", self.tintColors);
	}
}

- (IBAction)changeTintColor:(id)sender {
	
	[self displayTintColorPopup];
	
}

- (IBAction)selectAndContinue:(id)sender {
	
	NSArray* selectedLensOptions = [self.ltvc getSelectedForSection:0];
	
	NSMutableString* csvString = [NSMutableString string];
	
	BOOL first = YES;
	for (NSString* str in selectedLensOptions)
	{
		if (first)
			first = NO;
		else
			[csvString appendString:@","];
		[csvString appendString:str];
	}
	
	[mobileSessionXML setObject:csvString forKey:@"lensOptionIds"];
	
	[mobileSessionXML setObject:[NSNumber numberWithInt:self.selectedTintColorId] forKey:@"tintColorId"];
	
	[mobileSessionXML updateMobileSessionData];
	 
	UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Order process completed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	[alert show];
	[alert release];
	
}

- (void) displayTintColorPopup
{
	NSMutableArray* options = [[NSMutableArray alloc] init];
	
	NSEnumerator* enumerator = [self.tintColors keyEnumerator];
	
	id key;
	while ((key = [enumerator nextObject]))
	{
		NSString* pv = key;
		[options addObject:pv];
	}
	
	[options addObject:@"Cancel"];
	
	UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:@"Tint Color" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	for (NSString* title in options)
		[as addButtonWithTitle:title];
	
	//[as setCancelButtonIndex:[options count] - 1];
	
	//[as addButtonWithTitle:@"Test1"];
	//	[as addButtonWithTitle:@"Test2"];
	//	[as addButtonWithTitle:@"Test3"];
	[as showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex >= 0)
	{
	NSString* pv = [actionSheet buttonTitleAtIndex:buttonIndex];
	
	if (pv != @"Cancel")
	{
		NSLog(@"Checking color...");
		NSString* pvId = [self.tintColors objectForKey:pv];
		NSString* pvC = [self.tintColorHues objectForKey:pv];
		
		if (pvId)
		{
			NSLog(@"color hex %@", pvC);
			
			NSRange range;
			range.location = 0;
			range.length = 2;
			NSString* rStr = [pvC substringWithRange:range];		
			range.location = 2;
			NSString* gStr = [pvC substringWithRange:range];
			range.location = 4;		
			NSString* bStr = [pvC substringWithRange:range];
			
			unsigned int r, g, b;
			[[NSScanner scannerWithString:rStr] scanHexInt:&r];
			[[NSScanner scannerWithString:gStr] scanHexInt:&g];
			[[NSScanner scannerWithString:bStr] scanHexInt:&b];
			
			float red = (float) r / 255.0f;
			float blue = (float) b / 255.0f;
			float green = (float) g / 255.0f;
		
			self.tintColorView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
		}
	}
	}
}

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([alertView.title compare:@"Success"] == NSOrderedSame)
		[self.navigationController popToRootViewControllerAnimated:YES];
}
		
@end
