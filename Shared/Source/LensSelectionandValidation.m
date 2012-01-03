//
//  LensSelectionandValidation.m
//  CyberImaging
//
//  Created by Kaushik on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LensSelectionandValidation.h"
#import "QuartzCore/QuartzCore.h"

extern ServiceObject* frameXML;
extern ServiceObject* patientXML;
extern ServiceObject* prescriptionXML;
extern ServiceObject* mobileSessionXML;
extern ServiceObject* lensTypeXML;
extern ServiceObject* materialXML;

extern NSArray* patientImages;

extern NSString* lensBrandName;
extern NSString* lensDesignName;

extern UIColor* selectedMaterialColor;

@implementation LensSelectionandValidation

@synthesize materialColors;
@synthesize materialColorHues;
@synthesize materialThicknesses;

@synthesize selectedMaterialColorId;

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

@synthesize materialColorView;
@synthesize lensThicknessImage;
@synthesize previewImage;

@synthesize recLabel;
@synthesize thicknessLabel;

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
	[lensThicknessImage release];
	[previewImage release];

	[recLabel release];
	[thicknessLabel release];
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
	
	self.materialColors = [[NSMutableDictionary alloc] init];
	self.materialColorHues = [[NSMutableDictionary alloc] init];
	
	self.materialThicknesses = [[NSMutableDictionary alloc] init];

	self.materialColorView.hidden = YES;
	
	int si = [self.ltvc addSection:@"Lens Type" options:0];
	
	[self.ltvc addOptionForSection:si option:@"Single Vision" optionValue:@"24"];
	[self.ltvc addOptionForSection:si option:@"Bifocal" optionValue:@"37"];
	[self.ltvc addOptionForSection:si option:@"Trifocal" optionValue:@"26"];
	[self.ltvc addOptionForSection:si option:@"Progressive >" optionValue:@"43"];

	CALayer* l3 = [self.materialColorView layer];
	l3.borderWidth = 4;
	l3.cornerRadius = 30;
	
	CALayer* l = [self.lensThicknessImage layer];
	l.borderWidth = 2;
	l.cornerRadius = 10;
	
	CALayer* l2 = [self.previewImage layer];
	l2.borderWidth = 2;
	l2.cornerRadius = 10;
	
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
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(viewControllerPopped:)
	 name:@"UINavigationControllerWillShowViewControllerNotification"
	 object:self.navigationController];

	[self getLatestPatientFromService];
	
	[self getLatestPrescriptionFromService];
	
	[self getFrameInfoFromService];
	
	if ([patientImages count] > 0)
		self.previewImage.image = [patientImages objectAtIndex:0];
	
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
		
		int oldPresId = [mobileSessionXML getIntValueByName:@"prescriptionId"];
		if (oldPresId == 0)
		{
			[mobileSessionXML setObject:[NSNumber numberWithInt:[prescriptionXML getIntValueByName:@"prescriptionId"]] forKey:@"prescriptionId"];
			[mobileSessionXML updateMobileSessionData];
		}
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

- (void)loadMaterialData:(int)lensId
{	
	int si = [self.ltvc addOrFindSection:@"Material" options:(1<<0)];
	
	[self.ltvc clearSection:si];
	
	recLabel.hidden = YES;
	
	ServiceObject* so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetLensMaterialInfoByLensTypeIdWithSphere?lensTypeId=%d&rSphere=%@&lSphere=%@", lensId, self.rSphere.text, self.lSphere.text] categoryKey:@"" startTag:@"Table"];
	
	BOOL hasObjs = YES;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			NSString* material = [so getTextValueByName:[NSString stringWithFormat:@"%@/Material", key]];
			NSString* materialId = [so getTextValueByName:[NSString stringWithFormat:@"%@/MaterialId", key]];
			
			int recType = [so getIntValueByName:[NSString stringWithFormat:@"%@/RecommendationType", key]];
			
			NSString* materialRecommendation = [so getTextValueByName:[NSString stringWithFormat:@"%@/Recommendation", key]];

			NSNumber* thickness = [NSNumber numberWithInt:[so getIntValueByName:[NSString stringWithFormat:@"%@/Thickness", key]]];
			
			[self.materialThicknesses setObject:thickness forKey:materialId];
			
			UIColor* c;
			
			if (recType == 0)
				c = [UIColor redColor];
			else if (recType == 1)
				c = [UIColor yellowColor];
			else
				c = [UIColor greenColor];
			
			[self.ltvc addOptionForSection:si option:material optionValue:materialId optionDetail:materialRecommendation detailColor:c];
		}
		else
			hasObjs = NO;
	}
	
}

- (void)loadCoveredOptionData:(int)materialId
{	
	int si = [self.ltvc addOrFindSection:@"Covered Options" options:(1<<1)];
	
	[self.ltvc clearSection:si];
	
	ServiceObject* so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetCoveredOptionInfoByMaterialId?materialId=%d", materialId] categoryKey:@"" startTag:@"Table"];
	
	BOOL hasObjs = YES;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			NSString* covOption = [so getTextValueByName:[NSString stringWithFormat:@"%@/optionname", key]];
			NSString* covOptionId = [so getTextValueByName:[NSString stringWithFormat:@"%@/optionId", key]];
			
			[self.ltvc addOptionForSection:si option:covOption optionValue:covOptionId];
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
		
		if ([value intValue] == 43)
		{
			ProgressiveSelection *p = [[ProgressiveSelection alloc]init];
			p.title=@"Progressive Lens Design Selection";
			[self.navigationController pushViewController:p animated:YES];
		}

		[self removeMaterials];
		
		[self loadMaterialData:[value intValue]];
	}
	else if (sectionIndex == 1)
	{
		NSString* value = [self.ltvc getOptionValueForSection:sectionIndex optionIndex:selectedRow];
		
		NSLog(@"Material selected %@", value);
		
		[self loadMaterialColors];
		
		if ([self.materialColors count] > 0)
			[self displayMaterialColorPopup];
		
		//[self loadCoveredOptionData:[value intValue]];
		
		self.thicknessLabel.text = [NSString stringWithFormat:@"%@", [self.materialThicknesses objectForKey:value]];
	}
	
	self.materialColorView.hidden = [self.materialColors count] == 0;
	
}

- (void)viewControllerPopped:(NSNotification*)n
{
		NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);
	
		NSLog(@"Design name before use: %@", lensDesignName);
	
	if (lensDesignName)
	{
		[self.ltvc setOption:[NSString stringWithFormat:@"Progressive (%@ - %@)", lensBrandName, lensDesignName] section:0 index:3];
	
		[self.ltvc.tableView reloadData];
	}
	
}
- (void)listsTableSelectionCleared:(NSNotification*)n
{
	NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);
	
	NSInteger sectionIndex = [[n.userInfo objectForKey:@"sectionIndex"] integerValue];
	
	if (sectionIndex == 0)
	{
		[self removeMaterials];
	}
	else if (sectionIndex == 1)
	{
		//[self removeCoveredOptions];
	}

	self.materialColorView.hidden = [self.materialColors count] == 0;
}

- (void) removeMaterials
{
	[self removeCoveredOptions];
	
	[self.ltvc removeSection:1];
	
	[self.materialColors removeAllObjects];
	[self.materialColorHues removeAllObjects];
	[self.materialThicknesses removeAllObjects];
}

- (void) removeCoveredOptions
{
	[self.ltvc removeSection:2];
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

	[self setMaterialColorView:nil];
	[self setLensThicknessImage:nil];
	[self setPreviewImage:nil];

	[self setRecLabel:nil];
	[self setThicknessLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void) loadMaterialColors
{
	[self.materialColors removeAllObjects];
	[self.materialColorHues removeAllObjects];
	
	self.materialColorView.backgroundColor = [UIColor whiteColor];
	
	if ([self.ltvc numberOfSectionsInTableView:self.ltvc.tableView] > 1)
	{
	
		NSString* selectedMaterial = [self.ltvc getSelectedForSection:1];
		
		ServiceObject* mc = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetMaterialColorsByMaterialId?materialId=%@", selectedMaterial] categoryKey:@"" startTag:@"Table"];
		
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
					[self.materialColors setObject:pvId forKey:pv];
					[self.materialColorHues setObject:pvC forKey:pv];
					NSLog(@"adding material color %@", pv);
				}
				else
					hasObjs = NO;
			}

		}
		
		self.materialColorView.hidden = [self.materialColors count] == 0;
		
		NSLog(@"material colors count: %d", [self.materialColors count]);
		NSLog(@"material colors: %@", self.materialColors);
	}
}

- (IBAction)changeMaterialColor:(id)sender {
	
	[self displayMaterialColorPopup];
	
}

- (IBAction)selectAndContinue:(id)sender {
	
	id selectedLensId = [self.ltvc getSelectedForSection:0];
	
	if (!selectedLensId)
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please select a lens type." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	id selectedMaterialId = [self.ltvc getSelectedForSection:1];
	
	if (!selectedMaterialId)
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please select a material." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	[mobileSessionXML setObject:selectedLensId forKey:@"lensTypeId"];
	[mobileSessionXML setObject:selectedMaterialId forKey:@"materialId"];
	[mobileSessionXML setObject:[NSNumber numberWithInt:self.selectedMaterialColorId] forKey:@"materialColorId"];
	
	[mobileSessionXML updateMobileSessionData];
	
	int lensTypeIdx = [mobileSessionXML getIntValueByName:@"lensTypeId"];
	lensTypeXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetLensInfoByLensId?lensId=%d", lensTypeIdx]];
	
	int materialIdx = [mobileSessionXML getIntValueByName:@"materialId"];
	materialXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetMaterialInfoByMaterialId?materialId=%d", materialIdx]];
	
	selectedMaterialColor = self.materialColorView.backgroundColor;
	
	LensOptionSelection *p = [[LensOptionSelection alloc]init];
	p.title=@"Lens Option Selection";
	[self.navigationController pushViewController:p animated:YES];
	
}

- (void) displayMaterialColorPopup
{
	NSMutableArray* options = [[NSMutableArray alloc] init];
	
	NSEnumerator* enumerator = [self.materialColors keyEnumerator];
	
	id key;
	while ((key = [enumerator nextObject]))
	{
		NSString* pv = key;
		[options addObject:pv];
	}
	
	[options addObject:@"Cancel"];
	
	UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:@"Material Color" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
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
		NSString* pvId = [self.materialColors objectForKey:pv];
		NSString* pvC = [self.materialColorHues objectForKey:pv];
		
		if (pvId)
		{
			self.selectedMaterialColorId = buttonIndex;
			self.materialColorView.backgroundColor = [self colorFromHex:pvC];
		}
	}
	}
}

- (UIColor*)colorFromHex:(NSString*)pvC
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
	
	UIColor *col = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
	return col;
}

@end
