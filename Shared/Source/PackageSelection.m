//
//  PackageSelection.m
//  CyberImaging
//
//  Created by Troy Potts on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PackageSelection.h"
#import "MemberSearch.h"

#import "CaptureOverview.h"

extern ServiceObject* mobileSessionXML;
extern NSArray* patientImages;

extern ServiceObject* patientXML;
extern ServiceObject* prescriptionXML;

@implementation PackageSelection
@synthesize packageSelectorView;
@synthesize packageSelectorTestView;
@synthesize toolbar;
@synthesize frameView;
@synthesize patientPreview;
@synthesize frameSelectorView;
@synthesize frameSelectorContent;
@synthesize frameInfoView;
@synthesize packageInfoView;
@synthesize patientInfoView;
@synthesize priceView;
@synthesize txtPatientName;
@synthesize txtMemberId;
@synthesize colorView;
@synthesize colorBtn;
@synthesize frameNameLabel;
@synthesize mainSectionView;
@synthesize lensTypeBar;
@synthesize packageBar;

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
@synthesize frameABox;
@synthesize frameBBox;
@synthesize frameED;
@synthesize frameDBL;
@synthesize frameTemple;
@synthesize frameMfr;
@synthesize frameTypeLabel;
@synthesize frameCollection;
@synthesize frameGender;
@synthesize frameColorLabel;
@synthesize materialList;

@synthesize fontName;
@synthesize smallFont;

@synthesize frmNames;
@synthesize frmIds;
@synthesize lensTypeIds;
@synthesize packageIds;
@synthesize lensTypeNames;
@synthesize packageNames;

@synthesize packageInfo;
@synthesize frameInfo;
@synthesize lensTypeInfo;
@synthesize lensMaterialInfo;
@synthesize lensOptionInfo;

@synthesize selectedFrameIndex;
@synthesize selectedFrameId;
@synthesize selectedPackageId;
@synthesize selectedMaterialId;
@synthesize selectedOptionIds;

@synthesize hasSelectedLensType;
@synthesize hasSelectedPackageType;
@synthesize hackAltLifeStyleMode;
@synthesize hasLoaded;

@synthesize HUD;
@synthesize retailPriceLbl;
@synthesize vspPriceLbl;
@synthesize savingsLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        nextPopup = [UIViewController alloc];
        doSummonPopup = NO;
        
		self.toolbar.bounds = CGRectMake(self.toolbar.bounds.origin.x, self.navigationController.view.bounds.origin.y + self.navigationController.view.bounds.size.height, self.toolbar.bounds.size.width, self.toolbar.bounds.size.height);
		
		self.selectedFrameIndex = -1;
		
		self.frmNames = [NSMutableArray array];
		self.frmIds = [NSMutableArray array];
		
		
		self.selectedOptionIds = [NSMutableArray array];
		
		self.hasSelectedLensType = NO;
		self.hasSelectedPackageType = NO;
		self.hackAltLifeStyleMode = NO;
		
		/*UIBarButtonItem* button1 = [self.toolbar.items objectAtIndex:0];
		
		button1 = [[UIBarButtonItem alloc] initWithTitle:@"Single Vision" style:UIBarButtonItemStylePlain target:self action:@selector(clickSingleVision:)];*/
        // Custom initialization
    }
    return self;
}

- (IBAction)clickSingleVision:(id)sender
{
	UIViewController *vc = [[[UIViewController alloc] init] retain];
	vc.view = self.packageSelectorTestView;
	UIPopoverController* pc = [[UIPopoverController alloc] initWithContentViewController:vc];
	
	float height = self.packageSelectorView.frame.size.height;
	vc.contentSizeForViewInPopover = CGSizeMake(1000,height);
	self.packageSelectorView.contentSize = CGSizeMake(2100, height);
	pc.popoverContentSize = CGSizeMake(1000,height-100);
	[pc presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)frameImagePopup:(id)sender {
	UIViewController *vc = [[UIViewController alloc] init];
	vc.contentSizeForViewInPopover = CGSizeMake(768,1024);
	UIImageView *iv = [[UIImageView alloc] initWithImage:self.frameView.image];
	iv.contentMode = UIViewContentModeScaleAspectFit;
	vc.view = iv;
	vc.view.backgroundColor = [UIColor whiteColor];
	CGPoint p = [self.frameInfoView convertPoint:self.frameView.frame.origin toView:self.view];
	CGRect r = CGRectMake(p.x, p.y, self.frameView.frame.size.width, self.frameView.frame.size.height);
	UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:vc];
	[pc presentPopoverFromRect:r inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)patientNameClicked:(NSNotification *)n {	
	
	UITextField *tf = (UITextField*) n.object;
	
	[tf resignFirstResponder];
	[tf endEditing:YES];
	
	PatientRecord *patient=[[PatientRecord alloc]init];
	patient.title=@"Patient Record";
	//[self.navigationController pushViewController:patient animated:YES];
	[self presentModalViewController:patient animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	NSLog(@"we're outta here");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.hasLoaded = NO;
	
	if (!self.hackAltLifeStyleMode)
	{
		self.lensTypeIds = [NSMutableArray arrayWithObjects:
							[NSNumber numberWithInt:24],
							[NSNumber numberWithInt:44], 
							[NSNumber numberWithInt:30],
							[NSNumber numberWithInt:43], nil];
		
		self.packageIds = [NSMutableArray arrayWithObjects:
						   [NSNumber numberWithInt:3],
						   [NSNumber numberWithInt:5], 
						   [NSNumber numberWithInt:7],
						   [NSNumber numberWithInt:0], nil];
		
		self.lensTypeNames = [NSMutableArray arrayWithObjects:
							  @"Single Vision",
							  @"Digital Single Vision",
							  @"Progressive",
							  @"Digital Progressive", nil];
		
		self.packageNames = [NSMutableArray arrayWithObjects:
							 @"Signature Vision",
							 @"Gold Vision",
							 @"Platinum",
							 @"Custom", nil];
	}
	else
	{
		self.lensTypeIds = [NSMutableArray arrayWithObjects:
							[NSNumber numberWithInt:46], nil];
		
		self.packageIds = [NSMutableArray arrayWithObjects:
						   [NSNumber numberWithInt:0],
						   [NSNumber numberWithInt:0], 
						   [NSNumber numberWithInt:0],
						   [NSNumber numberWithInt:0], 
						   [NSNumber numberWithInt:0],
						   [NSNumber numberWithInt:0], 
						   nil];
		
		self.lensTypeNames = [NSMutableArray arrayWithObjects:
							  @"Sport",
							  nil];
		
		self.packageNames = [NSMutableArray arrayWithObjects:
							 @"Golf",
							 @"Baseball/Training",
							 @"Running",
							 @"Snow/Water", 
							 @"Tennis",
							 @"Cycling", 							
							 nil];		
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (!self.hasLoaded)
	{
		[self setupView];
	}
	
	[self loadPatientData:patientXML];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSString* memberId = [mobileSessionXML getTextValueByName:@"memberId"];
	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	if (memberId == @"0" || patientId == 0)
	{
        [self beginPatientSearch];

		return;
	}
	
	if (!self.hasLoaded)
	{
 
        [self beginAuthorization];
    
        
		[self loadEverything];
	}
    
    if (doSummonPopup)
    {
        NSLog(@"summoning nextpopup");
        [self presentModalViewController:nextPopup animated:YES]; 
        nextPopup = nil;
        doSummonPopup = NO;
    }
}

- (void)beginPatientSearch
{
    MemberSearch *patient=[[MemberSearch alloc]init];
    patient.title=@"Member Search";
    //[self.navigationController pushViewController:patient animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberSearchDidFinish:) name:@"MemberSearchDidFinish" object:patient];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberSearchDidCancel:) name:@"MemberSearchDidCancel" object:patient];
    
    [self presentModalViewController:patient animated:YES];
}

- (void)beginAuthorization
{
    PatientCoverageSummary *patient=[[PatientCoverageSummary alloc]init];
    patient.title=@"Patient Coverage";
    //[self.navigationController pushViewController:patient animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientCoverageSummaryDidFinish:) name:@"PatientCoverageSummaryDidFinish" object:patient];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientCoverageSummaryDidCancel:) name:@"PatientCoverageSummaryDidCancel" object:patient];
    
    nextPopup = patient;
    doSummonPopup = YES;
}

- (void)showPatientRecord
{
    PatientRecord *patient=[[PatientRecord alloc]init];
    patient.title=@"Patient Record";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientRecordDidFinish:) name:@"PatientRecordDidFinish" object:patient];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientRecordDidCancel:) name:@"PatientRecordDidCancel" object:patient];
    
    nextPopup = patient;
    doSummonPopup = YES;
}

- (void)askFrameType
{
    OrderFrameChoice *patient=[[OrderFrameChoice alloc]init];
    patient.title=@"Choose Frame Method";
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientRecordDidFinish:) name:@"OrderFrameChoiceDidFinish" object:patient];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientRecordDidCancel:) name:@"OrderFrameChoiceDidCancel" object:patient];
    
    nextPopup = patient;
    doSummonPopup = YES;
}

- (void)memberSearchDidFinish:(NSNotification*)n
{
    
    [self beginAuthorization];
	[self loadEverything];
}

- (void)memberSearchDidCancel:(NSNotification*)n
{
	NSLog(@"cancelled member search in package selection");
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) patientCoverageSummaryDidFinish:(NSNotification*)n
{
	NSLog(@"found coverage");
    [self showPatientRecord];
}

- (void) patientCoverageSummaryDidCancel:(NSNotification*)n
{
	NSLog(@"cancelled patient coverage summary in package selection");
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) patientRecordDidFinish:(NSNotification*)n
{
	NSLog(@"patient record continued");
    [self askFrameType];
}

- (void) patientRecordDidCancel:(NSNotification*)n
{
	NSLog(@"cancelled patient record in package selection");
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) setupView
{
	NSLog(@"View load");
	
	self.fontName = @"Verdana";
	
	self.smallFont = [UIFont fontWithName:@"Verdana" size:11.0f];
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"MainBackground.png"]];
		
	self.materialList.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.materialList.tableView.backgroundColor = [UIColor clearColor];
	self.materialList.font = self.smallFont;
	self.materialList.showHeaders = YES;
	self.materialList.simpleHeaders = YES;
	self.materialList.changeText = @"Upgrade";

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(listsTableSelected:)
	 name:@"ListsTableViewSelectionDidChangeNotification"
	 object:self.materialList];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(listsTableSelectionCleared:)
	 name:@"ListsTableViewSelectionDidClearNotification"
	 object:self.materialList];
	
	[self setUpLensTypeBar];
	
	self.frameSelectorView.contentSize = CGSizeMake(1500, self.frameSelectorView.frame.size.height);
	
	[self createGradientForLayer:self.frameInfoView.layer];
    [self createGradientForLayer:self.frameSelectorView.layer];
    [self createGradientForLayer:self.packageInfoView.layer];
	[self createGradientForLayer:self.patientInfoView.layer];
}

- (void) loadEverything
{
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.labelText = @"Downloading info...";
	
	[HUD showWhileExecuting:@selector(doLoadEverything) onTarget:self withObject:self animated:YES];
}

- (void) doLoadEverything
{
	ServiceObject* fso = [ServiceObject fromServiceMethod:@"GetAllFrameInfo" categoryKey:@"" startTag:@"Table"];
	
	self.frameInfo = fso;
	
	CALayer* layer;
	
	/*layer = self.frameView.layer;
	[layer setBorderWidth:1.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	layer = self.patientPreview.layer;
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	layer = self.frameSelectorView.layer;
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	layer = self.frameInfoView.layer;
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	layer = self.packageInfoView.layer;
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	layer = self.priceView.layer;
	[layer setCornerRadius:25];
	[layer setBorderWidth:3.0f];
	[layer setMasksToBounds:YES];*/
	
	[self getLatestPatientFromService];
	
	[self loadPatientImages];
	
	//NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"3.png" ofType:nil];
	//NSURL *url = [NSURL fileURLWithPath:urlStr];
	
	//self.frameView.image = [UIImage imageWithContentsOfFile:urlStr];
	
	id img = [patientImages objectAtIndex:0];
	if (img != [NSNull null])
		self.patientPreview.image = [patientImages objectAtIndex:0];
	
	/*float height = self.packageSelectorView.frame.size.height;
	self.packageSelectorView.contentSize = CGSizeMake(2100, height);
	
	UIViewController *vc1 = [[[UIViewController alloc] init] autorelease];
	vc1.title = @"Single Vision";
	vc1.view = self.packageSelectorTestView;
	
	UIViewController *vc2 = [[[UIViewController alloc] init] autorelease];
	vc2.title = @"Digital Single Vision";
	vc2.view = self.packageSelectorTestView;
	
	UIViewController *vc3 = [[[UIViewController alloc] init] autorelease];
	vc3.title = @"Progressive";
	vc3.view = self.packageSelectorTestView;	
	
	UIViewController *vc4 = [[[UIViewController alloc] init] autorelease];
	vc4.title = @"Digital Progressive";
	vc4.view = self.packageSelectorTestView;
	
	BHTabsViewController* btvc = [[BHTabsViewController alloc] initWithViewControllers:[NSArray arrayWithObjects:vc1, vc2, vc3, vc4, nil] style:[BHTabStyle defaultStyle]];
	
	[btvc loadView];
	
	[self.view addSubview:btvc.view];
	btvc.view.frame = CGRectMake(btvc.view.frame.origin.x, btvc.view.frame.origin.y+200, btvc.view.frame.size.width, btvc.view.frame.size.height);
	
	self.packageSelectorView.backgroundColor = btvc.style.selectedTabColor;*/
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientNameClicked:) name:@"UITextFieldTextDidBeginEditingNotification" object:self.txtPatientName];
	
	[self getLatestPrescriptionFromService];
	
	[self loadPatientData:patientXML];
	
	self.hasLoaded = YES;
	
    // Do any additional setup after loading the view from its nib.
}

- (void)listsTableSelected:(NSNotification*)n
{
	//NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);
	
	NSInteger sectionIndex = [[n.userInfo objectForKey:@"sectionIndex"] integerValue];
	NSInteger selectedRow = [[n.userInfo objectForKey:@"row"] integerValue];
	NSInteger isSelected = [[n.userInfo objectForKey:@"isSelected"] integerValue];
	//NSLog(@"%d", selectedRow);

	NSString* value = [self.materialList getOptionValueForSection:sectionIndex optionIndex:selectedRow];
	
	if (sectionIndex == 0)
	{
		self.selectedMaterialId = [value intValue];
		
		[self setUpOptionListForMaterial:[value intValue]];
	}
	else if (sectionIndex == 1)
	{
		if (isSelected)
			[self.selectedOptionIds addObject:value];
		else if ([self.selectedOptionIds containsObject:value])
			[self.selectedOptionIds removeObject:value];
		
		//NSLog(@"selected options: %@", self.selectedOptionIds);
	}
	else
	{
		return;
	}
	
	[self updatePrice];
}

- (void)createGradientForLayer:(CALayer*)layerArg
{
	[layerArg setBorderColor:[UIColor whiteColor].CGColor];
	[layerArg setCornerRadius:10.0f];
	[layerArg setBorderWidth:3.0f];
	[layerArg setMasksToBounds:YES];
	
	UIColor *veryLightGray = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
	CAGradientLayer *l = [CAGradientLayer layer];
	//l.colors = [NSArray arrayWithObjects:[UIColor, nil
	l.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.0f], nil];
	l.colors = [NSArray arrayWithObjects:veryLightGray.CGColor, [UIColor whiteColor].CGColor, veryLightGray.CGColor, nil];
	l.frame = layerArg.bounds;
	[layerArg insertSublayer:l atIndex:0];
}

- (void)listsTableSelectionCleared:(NSNotification*)n
{
	//NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);
	
	NSInteger sectionIndex = [[n.userInfo objectForKey:@"sectionIndex"] integerValue];
		
	if (sectionIndex == 0)
	{
		self.selectedMaterialId = -1;
		[self.selectedOptionIds removeAllObjects];
		[self.materialList removeSection:1];
	}
	
	[self updatePrice];
	
}

- (void) setUpMaterialListForLensType:(int)lensTypeId package:(int)packageId
{	
	[self.materialList removeSection:1];
	[self.materialList removeSection:0];
	
	self.selectedMaterialId = -1;
	
	int si = [self.materialList addOrFindSection:@"Material" options:(1<<1)];
	
	//ServiceObject* mso = [ServiceObject fromServiceMethod:@"GetLensPlanMaterialAssociationInfoByLensPackageId?lensPackageId=0" categoryKey:@"" startTag:@"Table"];
	
	//ServiceObject* mso = [ServiceObject fromServiceMethod:@"GetMaterialInfoByMaterialId?materialId=0" categoryKey:@"" startTag:@"Table"];
	
	ServiceObject* mso = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetLensMaterialInfoByLensTypeId?lensTypeId=%d", lensTypeId] categoryKey:@"" startTag:@"Table"];
	
	self.lensMaterialInfo = mso;
	
	BOOL hasObjs = YES;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [mso.dict objectForKey:key];
		
		if (obj)
		{
			NSString* materialName = [mso getTextValueByName:[NSString stringWithFormat:@"%@/Material", key]];
			NSString* materialId = [mso getTextValueByName:[NSString stringWithFormat:@"%@/MaterialId", key]];
			[self.materialList addOptionForSection:si option:materialName optionValue:materialId];
		}
		else
			hasObjs = NO;
	}
	
	[self.materialList.tableView reloadData];
	//[self.materialList setSelectedForSection:si row:0];
}

- (void) setSelectedMaterial:(int)materialId
{
	[self.materialList setSelectedForSection:0 optionValue:[NSString stringWithFormat:@"%d", materialId]];
	
	[self setUpOptionListForMaterial:materialId];
}

- (void) setUpOptionListForMaterial:(int)materialId
{
	if ([self.materialList numberOfSectionsInTableView:self.materialList.tableView] > 1)
		[self.materialList removeSection:1];
	
	ServiceObject* mso = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetCoveredOptionInfoByMaterialId?materialId=%d", materialId] categoryKey:@"" startTag:@"Table"];
	
	self.lensOptionInfo = mso;
	
	int si = [self.materialList addOrFindSection:@"Lens Options" options:(1<<1)|(1<<2)];
	
	BOOL hasObjs = YES;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [mso.dict objectForKey:key];
		
		if (obj)
		{
			NSString* optionName = [mso getTextValueByName:[NSString stringWithFormat:@"%@/optionname", key]];
			NSString* optionId = [mso getTextValueByName:[NSString stringWithFormat:@"%@/optionId", key]];
			[self.materialList addOptionForSection:si option:optionName optionValue:optionId];
		}
		else
			hasObjs = NO;
	}
	
	[self.materialList.tableView reloadData];
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

- (void) setUpColorsForFrame:(int)frameId
{	
	NSString *cptCode = [self getFrameField:@"CPTCode" forId:frameId];
	//NSLog(@"cptCode %@", cptCode);
	BOOL hasObjs = YES;
	
	int numColors = 0;
	float x = 0;
	UIImage *cbimg = [UIImage imageNamed:@"PackageSelectionColorButton.png"];
	
	for (UIView *v in self.colorView.subviews)
		[v removeFromSuperview];
	
	int lensTypeId = [[self.lensTypeIds objectAtIndex:self.lensTypeBar.selectedIndex] intValue];
	int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
	NSMutableArray *tempFrmIds = [[NSMutableArray alloc] init];
	
	ServiceObject *so;
	
	if (packageId != 0)
		so = self.packageInfo;
	else
		so = self.frameInfo;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			NSString* frameCode = [so getTextValueByName:[NSString stringWithFormat:@"%@/CPTCode", key]];
			
			int cmpLensTypeId = lensTypeId;
			int cmpPackageId = packageId;
			
			NSString* cmpFrameId = [so getTextValueByName:[NSString stringWithFormat:@"%@/FrameTypeId", key]];
			
			if (packageId != 0)
			{
				cmpLensTypeId = [so getIntValueByName:[NSString stringWithFormat:@"%@/LensTypeId", key]];
				cmpPackageId = [so getIntValueByName:[NSString stringWithFormat:@"%@/LensPackageId", key]];
			}
			
			//NSLog(@"frameCode compare: %@ vs %@", frameCode, cptCode);
			if ([frameCode isEqualToString:cptCode] && cmpLensTypeId == lensTypeId && cmpPackageId == packageId && ![tempFrmIds containsObject:cmpFrameId])
			{
				[tempFrmIds addObject:cmpFrameId];
				
				NSString *colorStr = [so getTextValueByName:[NSString stringWithFormat:@"%@/FrameColor", key]];
				//NSLog(@"color: %@", colorStr);
				
				UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
				[b setBackgroundImage:cbimg forState:UIControlStateNormal];
				//UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,50,50)];
				[b addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchDown];
				
				if (packageId != 0)
				{
					int assocId = 0;
					assocId = [so getIntValueByName:[NSString stringWithFormat:@"%@/AssociationId", key]];
					self.selectedPackageId = assocId;
					b.tag = assocId;
				}
				else
				{
					b.tag = [cmpFrameId intValue];
				}
				
				[self.colorView addSubview:b];
				
				[b sizeToFit];
				b.frame = CGRectMake(x, 0, b.frame.size.width, b.frame.size.height);

				CAGradientLayer *gl = [CAGradientLayer layer];
				
				/*UIColor *baseColor = [UIColor whiteColor];
				
				if ([colorStr hasSuffix:@"Hot"])
					baseColor = [UIColor redColor];
				if ([colorStr hasPrefix:@"Brown"])
					baseColor = [UIColor brownColor];
				if ([colorStr hasPrefix:@"Green"])
					baseColor = [UIColor greenColor];
				if ([colorStr hasPrefix:@"Yellow"])
					baseColor = [UIColor yellowColor];
				if ([colorStr hasPrefix:@"Red"])
					baseColor = [UIColor redColor];
				if ([colorStr hasPrefix:@"Black"])
					baseColor = [UIColor blackColor];
				if ([colorStr hasPrefix:@"Olive"])
					baseColor = [UIColor colorWithRed:0.6f green:0.9f blue:0.3f alpha:1.0f];
				if ([colorStr hasPrefix:@"Blue"])
					baseColor = [UIColor blueColor];
				if ([colorStr hasPrefix:@"Purple"])
					baseColor = [UIColor purpleColor];
				if ([colorStr hasSuffix:@"Sky"])
					baseColor = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];*/
				
				NSString* hexColor = [so getTextValueByName:[NSString stringWithFormat:@"%@/HexColorCode", key]];
				NSString* hexColor2 = [so getTextValueByName:[NSString stringWithFormat:@"%@/HexColorCode2", key]];				
				
				UIColor *baseColor = [self colorFromHex:hexColor];
				UIColor *baseColor2 = [self colorFromHex:hexColor2];
				
				if (baseColor != [UIColor whiteColor])
				{
					const CGFloat* ptr = CGColorGetComponents(baseColor.CGColor);
					UIColor *col1 = [UIColor colorWithRed:ptr[0] green:ptr[1] blue:ptr[2] alpha:0.5f];
					
					const CGFloat* ptr2 = CGColorGetComponents(baseColor2.CGColor);
					UIColor *col2 = [UIColor colorWithRed:ptr2[0] green:ptr2[1] blue:ptr2[2] alpha:0.5f];
					
					gl.colors = [NSArray arrayWithObjects:col1.CGColor, col2.CGColor, nil];
					gl.frame = b.bounds;
					[b.layer addSublayer:gl];
				}
				
				//NSLog(@"added color btn; number of subviews: %d", [self.colorView.subviews count]);
				numColors++;
				x += b.frame.size.width;
			}
		}
		else
			hasObjs = NO;
	}
	
	CGPoint c = [self.colorView center];
	self.colorView.frame = CGRectMake(0,0, numColors * cbimg.size.width, cbimg.size.height);
	self.colorView.center = c;
	
	//[self.materialList addOptionForSection:si option:@"AR Coat" optionValue:@"37"];
	
	//[self.materialList setSelectedForSection:si row:0];	
}

- (void)colorButtonClick:(id)sender
{
	UIButton *b = (UIButton*)sender;
	
	int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
	
	int frameId;
	
	if (packageId != 0)
	{
		int assocId = b.tag;
		frameId = [[self getPackageField:@"FrameTypeId" forId:assocId] intValue];
		
		self.selectedPackageId = assocId;
	}
	else
	{
		frameId = b.tag;
	}

	[self selectFrame:frameId];
}

- (void) setSelectedOption:(int)optionId inSection:(int)sectionId
{
	[self.materialList setSelectedForSection:sectionId optionValue:[NSString stringWithFormat:@"%d", optionId]];
}

- (void) setUpLensTypeBar
{
	SVSegmentedControl *svsc = [[SVSegmentedControl alloc] initWithSectionTitles:self.lensTypeNames];
	svsc.selectedIndex = -1;
	svsc.font = [UIFont fontWithName:self.fontName size:17.0f];
	//svsc.crossFadeLabelsOnDrag = YES;
	svsc.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 10, 5);
	
	if (!self.hackAltLifeStyleMode)
	svsc.thumbEdgeInset = UIEdgeInsetsMake(0, 0, 8, 0);		
	else
	svsc.thumbEdgeInset = UIEdgeInsetsMake(0, 10, 8, 10);
	//svsc.thumbEdgeInset = UIEdgeInsetsMake(5, 5, 10, 5);
	svsc.shadowOffset = CGSizeZero;
	svsc.layer.anchorPoint = CGPointZero;
	svsc.backgroundImage = [UIImage imageNamed:@"PackageSelectionLensTypeBar.png"];
	svsc.height = svsc.backgroundImage.size.height;
	svsc.thumb.tintColor = [UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:0.8f];
	svsc.thumb.shadowOffset = CGSizeZero;
	svsc.thumb.backgroundImage = [UIImage imageNamed:@"PackageSelectionLensTypeBarHighlight.png"];
	svsc.thumb.highlightedBackgroundImage = svsc.thumb.backgroundImage;
	
	////NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Euphemia UCAS"]);
	
	self.lensTypeBar = svsc;
	
	[self.mainSectionView addSubview:self.lensTypeBar];
	[svsc setFrame:CGRectMake(0, 70, 768, svsc.frame.size.height)];

	[svsc addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void) setUpPackageBar:(int)packageIdx
{
	SVSegmentedControl *svsc = [[SVSegmentedControl alloc] initWithSectionTitles:self.packageNames];
	
	svsc.selectedIndex = -1;
	svsc.font = [UIFont fontWithName:self.fontName size:13.0f];
	//svsc.crossFadeLabelsOnDrag = YES;
	svsc.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 8, 8);
	svsc.thumbEdgeInset = UIEdgeInsetsMake(0, 0, 8, 8);
	//svsc.thumbEdgeInset = UIEdgeInsetsMake(5, 5, 10, 5);
	//svsc.shadowOffset = CGSizeZero;
	svsc.layer.anchorPoint = CGPointZero;
	UIImage *bar = [UIImage imageNamed:@"PackageSelectionPackageBar.png"];
	UIImage *bar2 = [bar stretchableImageWithLeftCapWidth:8 topCapHeight:8];
	svsc.backgroundImage = bar2;
	//svsc.height = svsc.backgroundImage.size.height;
	svsc.textColor = [UIColor blackColor];
	//svsc.backgroundColor = [UIColor whiteColor];
	svsc.thumb.tintColor = [UIColor blackColor];
	//svsc.thumb.backgroundImage = [UIImage imageNamed:@"PackageSelectionLensTypeBarHighlight.png"];
	//svsc.thumb.highlightedBackgroundImage = svsc.thumb.backgroundImage;
	
	////NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Euphemia UCAS"]);
	
	//[svsc setFrame:CGRectMake(0, 0, 768, svsc.frame.size.height)];
	
	self.packageBar = svsc;
	
	[self.mainSectionView addSubview:self.packageBar];	
	
	if (!self.hackAltLifeStyleMode)
		[svsc setFrame:CGRectMake(40, self.lensTypeBar.frame.origin.y+self.lensTypeBar.frame.size.height-6, self.packageInfoView.frame.origin.x-30, svsc.frame.size.height)];
	else
		[svsc setFrame:CGRectMake(-10, self.lensTypeBar.frame.origin.y+self.lensTypeBar.frame.size.height-6, svsc.frame.size.width, svsc.frame.size.height)];

	[svsc addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl
{
	if (segmentedControl == self.lensTypeBar)
	{
		self.hasSelectedLensType = YES;
		if (!self.hasSelectedPackageType)
			[self setUpPackageBar:nil];
		else
		{
			/*int lensTypeId = [[self.lensTypeIds objectAtIndex:self.lensTypeBar.selectedIndex] intValue];
			int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
			[self setUpMaterialListForLensType:lensTypeId package:packageId];*/
			[self updateAllPackageInfo];
		}
	}
	if (segmentedControl == self.packageBar)
	{
		self.hasSelectedPackageType = YES;
		[self updateAllPackageInfo];
	}
}

- (void) updateAllPackageInfo
{
	if (self.hasSelectedLensType && self.hasSelectedPackageType)
	{
		HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
		[self.navigationController.view addSubview:HUD];
		
		HUD.labelText = @"Updating package info...";
		
		[HUD showWhileExecuting:@selector(loadAllDataByPackage) onTarget:self withObject:self animated:YES];
	}
	//[self loadFramesByPackage:1];
}

- (void)loadAllDataByPackage
{
	int lensTypeId = [[self.lensTypeIds objectAtIndex:self.lensTypeBar.selectedIndex] intValue];
	int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
	
	[self setUpMaterialListForLensType:lensTypeId package:packageId];
	
	[self loadFramesByPackage:packageId];
	
}

- (void)loadFramesByPackage:(int)packageId
{	
	//int packageId = 1;
	
	for (UIView *subview in [[[self.frameSelectorContent subviews] copy] autorelease])
	{
		[subview removeFromSuperview];
	}
	
	//CGRect f = self.frameSelectorView.frame;
	//[self.frameSelectorView release];
	//self.frameSelectorView = [[UIScrollView alloc] initWithFrame:f];
	
	ServiceObject* so;
	
	if (packageId != 0)
	{
		so = [ServiceObject fromServiceMethod:@"GetLensTypePackageAssociationInfo?associationId=0" categoryKey:@"" startTag:@"Table"];
		
		self.packageInfo = so;
	}
	else
	{
		so = self.frameInfo;
	}
	
	BOOL hasObjs = YES;
	
	[self.frmNames removeAllObjects];
	[self.frmIds removeAllObjects];

	int lensTypeId = [[self.lensTypeIds objectAtIndex:self.lensTypeBar.selectedIndex] intValue];
	
	int fcnt=1;
	for (int cnt=1; hasObjs; cnt++)
	{
		//NSLog(@"cnt %d", cnt);
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			//NSString* frameName = [so getTextValueByName:[NSString stringWithFormat:@"%@/FrameType", key]];
			NSString* frameCode = [so getTextValueByName:[NSString stringWithFormat:@"%@/CPTCode", key]];
			NSString* frameId = [so getTextValueByName:[NSString stringWithFormat:@"%@/FrameTypeId", key]];
			
			int cmpLensTypeId = lensTypeId;
			int cmpPackageId = packageId; 
			NSString* assocId = @"0";
			
			if (packageId != 0)
			{
				cmpLensTypeId = [so getIntValueByName:[NSString stringWithFormat:@"%@/LensTypeId", key]];
				cmpPackageId = [so getIntValueByName:[NSString stringWithFormat:@"%@/LensPackageId", key]];
				assocId = [so getTextValueByName:[NSString stringWithFormat:@"%@/AssociationId", key]];
			}
			
			BOOL extraComp = ![frameCode hasPrefix:@"EVO"];
			if (self.hackAltLifeStyleMode)
			{
				extraComp = !extraComp;
			}
			
			if ([frameCode length] > 0 && ![self.frmNames containsObject:frameCode] && cmpLensTypeId == lensTypeId && cmpPackageId == packageId && extraComp)
			{
				
				UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,90,60)];
				//iv.image = [UIImage imageNamed:@"3.png"];
				iv.image = [self getFrameImage:[frameId intValue]];
				iv.contentMode = UIViewContentModeScaleAspectFit;
				//iv.layer.anchorPoint = CGPointMake(0.5, 0.5);
				
				UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 60,25)];
				lbl.font = self.smallFont;
				lbl.backgroundColor = [UIColor clearColor];
				//lbl.layer.anchorPoint = CGPointMake(0.5, 0.5);
				lbl.text = frameCode;
				[lbl sizeToFit];

				UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,80)];
				[self.frameSelectorContent addSubview:cv];
				cv.center = CGPointMake(fcnt*100-50, 45);
				[cv addSubview:iv];
				[cv addSubview:lbl];
				
				iv.center = CGPointMake(50, 35);
				lbl.center = CGPointMake(50, 65);
				
				UIButton *cb = [[UIButton alloc] initWithFrame:cv.frame];
				[self.frameSelectorContent addSubview:cb];
				[cb addTarget:self action:@selector(frameViewClicked:) forControlEvents:UIControlEventTouchUpInside];
				cb.tag = fcnt-1;
				//NSLog(@"label added");
				
				[self.frmNames addObject:frameCode];
				
				if (packageId != 0)
					[self.frmIds addObject:assocId];
				else
					[self.frmIds addObject:frameId];
				
				fcnt++;
			}
		}
		else
			hasObjs = NO;
	}
	
	self.frameSelectorContent.frame = CGRectMake(0, 0, (fcnt-1)*100, self.frameSelectorContent.frame.size.height);
	[self.frameSelectorView setContentSize:self.frameSelectorContent.frame.size];
	
	/*int currentFrameId = [mobileSessionXML getIntValueByName:@"frameId"];
	if (currentFrameId != 0)
		[self selectFrame:currentFrameId];
	else*/
		[self selectFrameAtIndex:0];
	
	//NSLog(@"views: %d", [self.frameSelectorView.subviews count]);
	
}

- (UIImage*)getFrameImage:(int)frameId
{
	NSString* url = [ServiceObject urlOfWebPage:[NSString stringWithFormat:@"ShowFrameImage.aspx?frameId=%d", frameId]];
	//NSLog(@"%@", url);
	NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	
	return [UIImage imageWithData:imageData];
}

- (NSString*) getKey:(int)itemId fromObject:(ServiceObject*)so forFieldName:(NSString*)cmpFieldName
{
	BOOL hasObjs = [so hasData];
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			NSString* cmpFrameId = [so getTextValueByName:[NSString stringWithFormat:@"%@/%@", key, cmpFieldName]];
			
			if ([cmpFrameId isEqualToString:[NSString stringWithFormat:@"%d", itemId]])
			{
				return key;
			}
		}
		else
			hasObjs = NO;
	}
	
	return nil;
}

- (NSString*) getField:(NSString*)fieldName fromObject:(ServiceObject*)so forId:(int)itemId cmpFieldName:(NSString*)cmpFieldName
{
	NSString* key = [self getKey:itemId fromObject:so forFieldName:cmpFieldName];
	
	if (key)
	{
		NSString* fieldValue = [so getTextValueByName:[NSString stringWithFormat:@"%@/%@", key, fieldName]];
		return fieldValue;
	}
	
	return nil;
}

- (NSString*) getPackageField:(NSString*)fieldName forId:(int)frameId
{
	return [self getField:fieldName fromObject:self.packageInfo forId:frameId cmpFieldName:@"AssociationId"];
}

- (NSString*) getFrameField:(NSString*)fieldName forId:(int)frameId
{
	return [self getField:fieldName fromObject:self.frameInfo forId:frameId cmpFieldName:@"FrameTypeId"];
}

- (NSString*) getMaterialField:(NSString*)fieldName forId:(int)materialId
{
	return [self getField:fieldName fromObject:self.lensMaterialInfo forId:materialId cmpFieldName:@"MaterialId"];
}

- (NSString*) getOptionField:(NSString*)fieldName forId:(int)optionId
{
	return [self getField:fieldName fromObject:self.lensOptionInfo forId:optionId cmpFieldName:@"LensOptionId"];
}

- (void) frameViewClicked:(id)sender
{
	int frameNum = [sender tag];
	//NSLog(@"clicked %d", frameNum);
	
	[self selectFrameAtIndex:frameNum];
}

- (void) selectFrameAtIndex:(int)frameIdx
{
	int frameId = 0;
	
	if (frameIdx < [self.frmIds count])
	{
		int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
		
		if (packageId != 0)
		{
			int assocId = [[self.frmIds objectAtIndex:frameIdx] intValue];
			frameId = [[self getPackageField:@"FrameTypeId" forId:assocId] intValue];
			
			self.selectedPackageId = assocId;
		}
		else
		{
			frameId = [[self.frmIds objectAtIndex:frameIdx] intValue];
		}
		
		if (self.selectedFrameIndex != -1)
		{
			[[self.frameSelectorContent.subviews objectAtIndex:self.selectedFrameIndex*2] setBackgroundColor:[UIColor clearColor]];
		}
		
		self.selectedFrameIndex = frameIdx;
		
	}
	else
	{
		self.selectedFrameIndex = -1;
	}
	
	[self selectFrame:frameId];
}
- (void) selectFrame:(int)frameId
{
	//NSLog(@"selecting %d", frameId);
	
	self.selectedFrameId = frameId;

	if (self.selectedFrameIndex != -1)
	{
		UIView *sv = [self.frameSelectorContent.subviews objectAtIndex:self.selectedFrameIndex*2];
		[sv setBackgroundColor:[UIColor lightGrayColor]];
		
		//self.frameView.image = [[sv.subviews objectAtIndex:0] image];
		self.frameView.image = [self getFrameImage:frameId];
		
		self.frameNameLabel.text = [self getFrameField:@"CPTCode" forId:self.selectedFrameId];
		self.frameABox.text = [NSString stringWithFormat:@"%g", [[self getFrameField:@"ABox" forId:self.selectedFrameId] floatValue]];
		self.frameBBox.text = [NSString stringWithFormat:@"%g", [[self getFrameField:@"BBox" forId:self.selectedFrameId] floatValue]];
		self.frameED.text = [NSString stringWithFormat:@"%g", [[self getFrameField:@"ED" forId:self.selectedFrameId] floatValue]];
		self.frameDBL.text = [NSString stringWithFormat:@"%g", [[self getFrameField:@"DBL" forId:self.selectedFrameId] floatValue]];
		self.frameTemple.text = [NSString stringWithFormat:@"%g", [[self getFrameField:@"TempleSize" forId:self.selectedFrameId] floatValue]];
		self.frameMfr.text = [self getFrameField:@"FrameManufacturer" forId:self.selectedFrameId];
		self.frameTypeLabel.text = [self getFrameField:@"Property_Frame_x0020_Type" forId:self.selectedFrameId];
		self.frameCollection.text = [self getFrameField:@"Property_Collection" forId:self.selectedFrameId];
		self.frameGender.text = [self getFrameField:@"Property_Gender" forId:self.selectedFrameId];
		
		self.frameColorLabel.text = [self getFrameField:@"FrameColor" forId:self.selectedFrameId];
	}
	else
	{
		self.frameView.image = nil;
		
		self.frameNameLabel.text = @"";
		self.frameABox.text = @"";
		self.frameBBox.text = @"";
		self.frameED.text = @"";
		self.frameDBL.text = @"";
		self.frameTemple.text = @"";
		
		self.frameMfr.text = @"";
		self.frameTypeLabel.text = @"";
		self.frameCollection.text = @"";
		self.frameGender.text = @"";		
		self.frameColorLabel.text = @"";
	}
	
	int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
	
	if (packageId > 0)
	{
		int materialId = [[self getPackageField:@"MaterialId" forId:self.selectedPackageId] intValue];
		//NSLog(@"materialId: %d", materialId);
		[self setSelectedMaterial:materialId];
		
		int optionId = [[self getPackageField:@"OptionId" forId:self.selectedPackageId] intValue];
		//NSLog(@"optionId: %d", optionId);
		[self setSelectedOption:optionId inSection:1];
		
		int optionId2 = [[self getPackageField:@"OptionIdtwo" forId:self.selectedPackageId] intValue];
		//NSLog(@"optionId2: %d", optionId);
		[self setSelectedOption:optionId2 inSection:1];
	}
	[self updatePrice];
	
	[self setUpColorsForFrame:frameId];
}

- (void) updatePrice
{
	int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
	
	if (packageId > 0)
	{
		float retailPrice = [[self getPackageField:@"Price" forId:self.selectedPackageId] floatValue];
		self.retailPriceLbl.text = [NSString stringWithFormat:@"%.2f", retailPrice];

		float vspPrice = [[self getPackageField:@"VSPPrice" forId:self.selectedPackageId] floatValue];
		self.vspPriceLbl.text = [NSString stringWithFormat:@"%.2f", vspPrice];
		
		float savings = retailPrice - vspPrice;
		self.savingsLbl.text = [NSString stringWithFormat:@"%.2f", savings];
	}
	else if (packageId == 0)
	{
		float retailPrice = [self getCompleteCustomPrice];
		self.retailPriceLbl.text = [NSString stringWithFormat:@"%.2f", retailPrice];
		
		float vspPrice = 0.0f;
		self.vspPriceLbl.text = [NSString stringWithFormat:@"%.2f", vspPrice];
		
		float savings = retailPrice - vspPrice;
		self.savingsLbl.text = [NSString stringWithFormat:@"%.2f", savings];
	}
	else
	{
		self.retailPriceLbl.text = @"";
		self.vspPriceLbl.text = @"";
		self.savingsLbl.text = @"";
	}
}

- (float) getCompleteCustomPrice
{
	float totalPrice = 0.0f;
	
	totalPrice += [[self getFrameField:@"Price" forId:self.selectedFrameId] floatValue];
	
	totalPrice += [[self getMaterialField:@"Price" forId:self.selectedMaterialId] floatValue];
	
	for (NSString *oid in self.selectedOptionIds)
	{
		totalPrice += [[self getOptionField:@"Price" forId:[oid intValue]] floatValue];
	}
	
	return totalPrice;
	
}

- (void) getLatestPatientFromService
{
	
	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	patientXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientIdv]];
	
}

- (void) loadPatientData:(ServiceObject *)patient
{
	if ([patientXML hasData] && [patientXML.dict objectForKey:@"FirstName"])
	{
		[self.txtMemberId setText:[patient getTextValueByName:@"MemberId"]];
		[self.txtPatientName setText:[patient getTextValueByName:@"PatientFullName"]];
	}
}

- (void)loadPatientImages
{
	CaptureOverview* co = [[CaptureOverview alloc] init];
	
	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	int cnt=0;
	
	cnt=0;
	
	NSMutableArray *mi = [[NSMutableArray alloc] init];
	
	for (NSString* suffix in co.suffixes)
	{
		
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[ServiceObject urlOfWebPage:[NSString stringWithFormat:@"ShowPatientImage.aspx?patientId=%d&type=%@&ignore=true", patientId, suffix]]]];
		UIImage *uiimg = [[UIImage imageWithData:imageData] retain];
		id img = uiimg ? uiimg : [NSNull null];
		
		[mi addObject:img];
		
		cnt++;
	}
	
	patientImages = [[NSArray arrayWithArray:mi] retain];
	
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

- (void)viewDidUnload
{
	[self setPackageSelectorView:nil];
	[self setToolbar:nil];
	[self setPackageSelectorTestView:nil];
	[self setFrameView:nil];
	[self setPatientPreview:nil];
	[self setFrameSelectorView:nil];
	[self setPackageInfoView:nil];
	[self setPriceView:nil];
	[self setTxtPatientName:nil];
	[self setTxtMemberId:nil];
	[self setFrameInfoView:nil];
	[self setColorBtn:nil];
	
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
	
    [self setLensTypeBar:nil];
    [self setMainSectionView:nil];
	[self setFrameSelectorContent:nil];
    [self setMaterialList:nil];
	[self setFrameNameLabel:nil];
	[self setFrameABox:nil];
	[self setFrameBBox:nil];
	[self setFrameED:nil];
	[self setFrameDBL:nil];
	[self setFrameMfr:nil];
	[self setFrameTypeLabel:nil];
	[self setRetailPriceLbl:nil];
	[self setVspPriceLbl:nil];
	[self setSavingsLbl:nil];
	[self setColorView:nil];
	[self setFrameCollection:nil];
	[self setFrameGender:nil];
	[self setFrameTemple:nil];
	[self setFrameColorLabel:nil];
    [self setPatientInfoView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
	[packageSelectorView release];
	[toolbar release];
	[packageSelectorTestView release];
	[frameView release];
	[patientPreview release];
	[frameSelectorView release];
	[packageInfoView release];
	[priceView release];
	[txtPatientName release];
	[txtMemberId release];
	[frameInfoView release];
	[colorBtn release];
	
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
	
    [lensTypeBar release];
    [mainSectionView release];
	[frameSelectorContent release];
    [materialList release];
	[frameNameLabel release];
	[frameABox release];
	[frameBBox release];
	[frameED release];
	[frameDBL release];
	[frameMfr release];
	[frameTypeLabel release];
	[retailPriceLbl release];
	[vspPriceLbl release];
	[savingsLbl release];
	[colorView release];
	[frameCollection release];
	[frameGender release];
	[frameTemple release];
	[frameColorLabel release];
    [patientInfoView release];
	[super dealloc];
}

- (IBAction)selectAndContinue:(id)sender {
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	NSString* returnedFrame = [NSString stringWithFormat:@"%d", self.selectedFrameId];
	
	NSLog(@"returnedFrame %@", returnedFrame);
	if ([returnedFrame length] > 0 && [returnedFrame intValue] > 0)
	{
		//NSLog(@"Updating selected FrameId to %@", returnedFrame);
		[mobileSessionXML setObject:returnedFrame forKey:@"frameId"];
		
		[mobileSessionXML updateMobileSessionData];
	}
	else
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please select a frame." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	//int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
	//if (self.selectedPackageId >= 0 || packageId==0)
	{
		NSString *str = [NSString stringWithFormat:@"%d", self.selectedPackageId];
		[mobileSessionXML setObject:str forKey:@"packageId"];
		 
		[mobileSessionXML updateMobileSessionData];
	}
	//else
	//{
		
	//}
	
	if (currentPatientId == 0)
	{
		PatientRecord *patient=[[PatientRecord alloc]init];
		patient.title=@"Patient Record";
		//[self.navigationController pushViewController:patient animated:YES];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishContinue:) name:@"PatientRecordDidFinish" object:nil];
		
		[self presentModalViewController:patient animated:YES];
	}
	else
		[self finishContinue:self];
}

- (void)finishContinue:(id)sender
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"PatientRecordDidFinish" object:nil];
	
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	if (currentPatientId != 0)
	{
		PatientPrescription *patient=[[PatientPrescription alloc]init];
		patient.title=@"Prescription Information";
		[self.navigationController pushViewController:patient animated:YES];
	}
}

@end
