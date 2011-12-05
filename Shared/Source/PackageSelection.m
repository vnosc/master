//
//  PackageSelection.m
//  CyberImaging
//
//  Created by Troy Potts on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PackageSelection.h"

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
@synthesize frameMfr;
@synthesize frameTypeLabel;
@synthesize materialList;

@synthesize fontName;
@synthesize smallFont;

@synthesize frmNames;
@synthesize frmIds;
@synthesize lensTypeIds;
@synthesize packageIds;

@synthesize packageInfo;
@synthesize selectedFrameIndex;
@synthesize selectedFrameId;
@synthesize selectedPackageId;

@synthesize hasSelectedLensType;
@synthesize hasSelectedPackageType;

@synthesize HUD;
@synthesize retailPriceLbl;
@synthesize vspPriceLbl;
@synthesize savingsLbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

		self.toolbar.bounds = CGRectMake(self.toolbar.bounds.origin.x, self.navigationController.view.bounds.origin.y + self.navigationController.view.bounds.size.height, self.toolbar.bounds.size.width, self.toolbar.bounds.size.height);
		
		self.selectedFrameIndex = -1;
		
		self.frmNames = [[NSMutableArray alloc] init];
		self.frmIds = [[NSMutableArray alloc] init];

		self.lensTypeIds = [[NSMutableArray alloc]
						   initWithObjects:
						   [NSNumber numberWithInt:24],
						   [NSNumber numberWithInt:44], 
						   [NSNumber numberWithInt:30],
						   [NSNumber numberWithInt:43], nil];
		
		self.packageIds = [[NSMutableArray alloc]
			initWithObjects:
				[NSNumber numberWithInt:3],
				[NSNumber numberWithInt:5], 
				[NSNumber numberWithInt:7],
				[NSNumber numberWithInt:0], nil];
		
		self.hasSelectedLensType = NO;
		self.hasSelectedPackageType = NO;
		
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
	
	self.fontName = @"Verdana";
	
	self.smallFont = [UIFont fontWithName:@"Verdana" size:11.0f];
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"PackageSelectionBackground.png"]];
		
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
	
	for (UIButton *btn in self.colorBtn)
	{
		layer = btn.layer;
		[layer setCornerRadius:10];
		[layer setBorderWidth:1.0f];
		[layer setMasksToBounds:YES];		
	}
	
	[self getLatestPatientFromService];
	
	[self loadPatientImages];
	
	//NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"3.png" ofType:nil];
	//NSURL *url = [NSURL fileURLWithPath:urlStr];
	
	//self.frameView.image = [UIImage imageWithContentsOfFile:urlStr];
	
	id img = [patientImages objectAtIndex:0];
	if (img != [NSNull null])
		self.patientPreview.image = [patientImages objectAtIndex:0];
	
	self.frameSelectorView.contentSize = CGSizeMake(1500, self.frameSelectorView.frame.size.height);
	
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedPatientName:) name:@"UITextFieldTextDidBeginEditingNotification" object:self.txtPatientName];
	
		[self getLatestPrescriptionFromService];
	
    // Do any additional setup after loading the view from its nib.
}

- (void)listsTableSelected:(NSNotification*)n
{
	NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);
	
	NSInteger sectionIndex = [[n.userInfo objectForKey:@"sectionIndex"] integerValue];
	NSInteger selectedRow = [[n.userInfo objectForKey:@"row"] integerValue];
	NSLog(@"%d", selectedRow);
	
	if (sectionIndex == 0)
	{
		NSString* value = [self.materialList getOptionValueForSection:sectionIndex optionIndex:selectedRow];
		
		[self setUpOptionListForMaterial:[value intValue]];
	}
	
}

- (void)listsTableSelectionCleared:(NSNotification*)n
{
	NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);
	
	NSInteger sectionIndex = [[n.userInfo objectForKey:@"sectionIndex"] integerValue];
		
	if (sectionIndex == 0)
	{
		[self.materialList removeSection:1];
	}
	
}

- (void) setUpMaterialListForLensType:(int)lensTypeId package:(int)packageId
{	
	[self.materialList removeSection:1];
	[self.materialList removeSection:0];
	
	int si = [self.materialList addOrFindSection:@"Material" options:(1<<1)];
	
	//ServiceObject* mso = [ServiceObject fromServiceMethod:@"GetLensPlanMaterialAssociationInfoByLensPackageId?lensPackageId=0" categoryKey:@"" startTag:@"Table"];
	
	//ServiceObject* mso = [ServiceObject fromServiceMethod:@"GetMaterialInfoByMaterialId?materialId=0" categoryKey:@"" startTag:@"Table"];
	
	ServiceObject* mso = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetLensMaterialInfoByLensTypeId?lensTypeId=%d", lensTypeId] categoryKey:@"" startTag:@"Table"];
	
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

- (void) setUpColorsForFrame:(int)frameId
{	
	NSString *cptCode = [self getField:@"CPTCode" forFrameId:frameId];
	NSLog(@"cptCode %@", cptCode);
	BOOL hasObjs = YES;
	
	int numColors = 0;
	float x = 0;
	UIImage *cbimg = [UIImage imageNamed:@"PackageSelectionColorButton.png"];
	
	for (UIView *v in self.colorView.subviews)
		[v removeFromSuperview];
	
	int lensTypeId = [[self.lensTypeIds objectAtIndex:self.lensTypeBar.selectedIndex] intValue];
	int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
	NSMutableArray *tempFrmIds = [[NSMutableArray alloc] init];
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [self.packageInfo.dict objectForKey:key];
		
		if (obj)
		{
			NSString* frameCode = [self.packageInfo getTextValueByName:[NSString stringWithFormat:@"%@/CPTCode", key]];
			int cmpLensTypeId = [self.packageInfo getIntValueByName:[NSString stringWithFormat:@"%@/LensTypeId", key]];
			int cmpPackageId = [self.packageInfo getIntValueByName:[NSString stringWithFormat:@"%@/LensPackageId", key]];
			NSString* cmpFrameId = [self.packageInfo getTextValueByName:[NSString stringWithFormat:@"%@/FrameTypeId", key]];
			
			if (packageId == 0)
				cmpPackageId = 0;
			
			NSLog(@"frameCode compare: %@ vs %@", frameCode, cptCode);
			if ([frameCode isEqualToString:cptCode] && cmpLensTypeId == lensTypeId && cmpPackageId == packageId && ![tempFrmIds containsObject:cmpFrameId])
			{
				[tempFrmIds addObject:cmpFrameId];
				int assocId = [self.packageInfo getIntValueByName:[NSString stringWithFormat:@"%@/AssociationId", key]];
				NSString *colorStr = [self.packageInfo getTextValueByName:[NSString stringWithFormat:@"%@/FrameColor", key]];
				NSLog(@"color: %@", colorStr);
				self.selectedPackageId = assocId;
				
				UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
				[b setBackgroundImage:cbimg forState:UIControlStateNormal];
				//UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,50,50)];
				b.tag = [cmpFrameId intValue];
				[b addTarget:self action:@selector(colorButtonClick:) forControlEvents:UIControlEventTouchDown];
				
				[self.colorView addSubview:b];
				
				[b sizeToFit];
				b.frame = CGRectMake(x, 0, b.frame.size.width, b.frame.size.height);

				CAGradientLayer *gl = [CAGradientLayer layer];
				
				UIColor *baseColor = [UIColor whiteColor];
				
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
					baseColor = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
				
				if (baseColor != [UIColor whiteColor])
				{
					const CGFloat* ptr = CGColorGetComponents(baseColor.CGColor);
					UIColor *col1 = [UIColor colorWithRed:ptr[0] green:ptr[1] blue:ptr[2] alpha:0.5f];
					//UIColor *col2 = [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:0.5f];
					UIColor *col2 = col1;
					gl.colors = [NSArray arrayWithObjects:col1.CGColor, col2.CGColor, nil];
					gl.frame = b.bounds;
					[b.layer addSublayer:gl];
				}
				
				NSLog(@"added color btn; number of subviews: %d", [self.colorView.subviews count]);
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
	int frameId = b.tag;
	[self selectFrame:frameId];
}

- (void) setSelectedOption:(int)optionId inSection:(int)sectionId
{
	[self.materialList setSelectedForSection:sectionId optionValue:[NSString stringWithFormat:@"%d", optionId]];
}

- (void) setUpLensTypeBar
{
	SVSegmentedControl *svsc = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Single Vision", @"Digital Single Vision", @"Progressive", @"Digital Progressive", nil]];
	svsc.selectedIndex = -1;
	svsc.font = [UIFont fontWithName:self.fontName size:17.0f];
	//svsc.crossFadeLabelsOnDrag = YES;
	svsc.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 10, 5);
	svsc.thumbEdgeInset = UIEdgeInsetsMake(0, 0, 8, 0);
	//svsc.thumbEdgeInset = UIEdgeInsetsMake(5, 5, 10, 5);
	svsc.shadowOffset = CGSizeZero;
	svsc.layer.anchorPoint = CGPointZero;
	svsc.backgroundImage = [UIImage imageNamed:@"PackageSelectionLensTypeBar.png"];
	svsc.height = svsc.backgroundImage.size.height;
	svsc.thumb.tintColor = [UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:0.8f];
	svsc.thumb.shadowOffset = CGSizeZero;
	svsc.thumb.backgroundImage = [UIImage imageNamed:@"PackageSelectionLensTypeBarHighlight.png"];
	svsc.thumb.highlightedBackgroundImage = svsc.thumb.backgroundImage;
	
	//NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Euphemia UCAS"]);
	
	self.lensTypeBar = svsc;
	
	[self.mainSectionView addSubview:self.lensTypeBar];
	[svsc setFrame:CGRectMake(0, 70, 768, svsc.frame.size.height)];

	[svsc addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void) setUpPackageBar:(int)packageIdx
{
	SVSegmentedControl *svsc = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Signature Vision", @"Gold Vision", @"Platinum", @"Custom", nil]];
	
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
	
	//NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Euphemia UCAS"]);
	
	//[svsc setFrame:CGRectMake(0, 0, 768, svsc.frame.size.height)];
	
	self.packageBar = svsc;
	
	[self.mainSectionView addSubview:self.packageBar];	
	
	[svsc setFrame:CGRectMake(40, self.lensTypeBar.frame.origin.y+self.lensTypeBar.frame.size.height-6, self.packageInfoView.frame.origin.x-30, svsc.frame.size.height)];

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
		
		HUD.labelText = @"Downloading package info...";
		
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
	
	ServiceObject* so = [ServiceObject fromServiceMethod:@"GetLensTypePackageAssociationInfo?associationId=0" categoryKey:@"" startTag:@"Table"];
	
	self.packageInfo = so;
	
	BOOL hasObjs = YES;
	
	[self.frmNames removeAllObjects];
	[self.frmIds removeAllObjects];

	int lensTypeId = [[self.lensTypeIds objectAtIndex:self.lensTypeBar.selectedIndex] intValue];
	
	int fcnt=1;
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			//NSString* frameName = [so getTextValueByName:[NSString stringWithFormat:@"%@/FrameType", key]];
			NSString* frameCode = [so getTextValueByName:[NSString stringWithFormat:@"%@/CPTCode", key]];
			NSString* frameId = [so getTextValueByName:[NSString stringWithFormat:@"%@/FrameTypeId", key]];
			
			int cmpLensTypeId = [self.packageInfo getIntValueByName:[NSString stringWithFormat:@"%@/LensTypeId", key]];
			int cmpPackageId = [self.packageInfo getIntValueByName:[NSString stringWithFormat:@"%@/LensPackageId", key]];
			
			if (packageId == 0)
				cmpPackageId = 0;
			
			if ([frameCode length] > 0 && ![self.frmNames containsObject:frameCode] && cmpLensTypeId == lensTypeId && cmpPackageId == packageId)
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
				NSLog(@"label added");
				
				[self.frmNames addObject:frameCode];
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
	
	NSLog(@"views: %d", [self.frameSelectorView.subviews count]);
	
}

- (UIImage*)getFrameImage:(int)frameId
{
	NSString* url = [NSString stringWithFormat:@"http://smart-i.mobi/ShowFrameImage.aspx?frameId=%d", frameId];
	NSLog(@"%@", url);
	NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	
	return [UIImage imageWithData:imageData];
}

- (NSString*) getPackageKey:(int)frameId
{
	BOOL hasObjs = [self.packageInfo hasData];
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [self.packageInfo.dict objectForKey:key];
		
		if (obj)
		{
			NSString* cmpFrameId = [self.packageInfo getTextValueByName:[NSString stringWithFormat:@"%@/FrameTypeId", key]];
			
			if ([cmpFrameId isEqualToString:[NSString stringWithFormat:@"%d", frameId]])
			{
				return key;
			}
		}
		else
			hasObjs = NO;
	}
	
	return nil;
}

- (NSString*) getField:(NSString*)fieldName forFrameId:(int)frameId
{
	NSString* key = [self getPackageKey:frameId];
	
	if (key)
	{
		NSString* fieldValue = [self.packageInfo getTextValueByName:[NSString stringWithFormat:@"%@/%@", key, fieldName]];
		return fieldValue;
	}
	
	return nil;
}

- (void) frameViewClicked:(id)sender
{
	int frameNum = [sender tag];
	NSLog(@"clicked %d", frameNum);
	
	[self selectFrameAtIndex:frameNum];
}

- (void) selectFrameAtIndex:(int)frameIdx
{
	int frameId = 0;
	
	if (frameIdx < [self.frmIds count])
	{
		frameId = [[self.frmIds objectAtIndex:frameIdx] intValue];
		
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
	NSLog(@"selecting %d", frameId);
	
	self.selectedFrameId = frameId;

	if (self.selectedFrameIndex != -1)
	{
		UIView *sv = [self.frameSelectorContent.subviews objectAtIndex:self.selectedFrameIndex*2];
		[sv setBackgroundColor:[UIColor lightGrayColor]];
		
		//self.frameView.image = [[sv.subviews objectAtIndex:0] image];
		self.frameView.image = [self getFrameImage:frameId];
		
		self.frameNameLabel.text = [self getField:@"CPTCode" forFrameId:self.selectedFrameId];
		self.frameABox.text = [NSString stringWithFormat:@"%g", [[self getField:@"ABox" forFrameId:self.selectedFrameId] floatValue]];
		self.frameBBox.text = [NSString stringWithFormat:@"%g", [[self getField:@"BBox" forFrameId:self.selectedFrameId] floatValue]];
		self.frameED.text = [NSString stringWithFormat:@"%g", [[self getField:@"ED" forFrameId:self.selectedFrameId] floatValue]];
		self.frameDBL.text = [NSString stringWithFormat:@"%g", [[self getField:@"DBL" forFrameId:self.selectedFrameId] floatValue]];
		self.frameMfr.text = [self getField:@"FrameManufacturer" forFrameId:self.selectedFrameId];
		self.frameTypeLabel.text = [self getField:@"FrameStyle" forFrameId:self.selectedFrameId];
	}
	else
	{
		self.frameView.image = nil;
		
		self.frameNameLabel.text = @"";
		self.frameABox.text = @"";
		self.frameBBox.text = @"";
		self.frameED.text = @"";
		self.frameDBL.text = @"";
		
		self.frameMfr.text = @"";
		self.frameTypeLabel.text = @"";
	}
	
	int packageId = [[self.packageIds objectAtIndex:self.packageBar.selectedIndex] intValue];
	
	if (packageId > 0)
	{
		int materialId = [[self getField:@"MaterialId" forFrameId:self.selectedFrameId] intValue];
		NSLog(@"materialId: %d", materialId);
		[self setSelectedMaterial:materialId];
		
		int optionId = [[self getField:@"OptionId" forFrameId:self.selectedFrameId] intValue];
		NSLog(@"optionId: %d", optionId);
		[self setSelectedOption:optionId inSection:1];
		
		int optionId2 = [[self getField:@"OptionIdtwo" forFrameId:self.selectedFrameId] intValue];
		NSLog(@"optionId2: %d", optionId);
		[self setSelectedOption:optionId2 inSection:1];
		
		float retailPrice = [[self getField:@"Price" forFrameId:self.selectedFrameId] intValue];
		self.retailPriceLbl.text = [NSString stringWithFormat:@"%.2f", retailPrice];

		float vspPrice = [[self getField:@"VSPPrice" forFrameId:self.selectedFrameId] intValue];
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
	
	[self setUpColorsForFrame:frameId];
}

- (void) viewWillAppear:(BOOL)animated
{
	[self loadPatientData:patientXML];
	
	[super viewWillAppear:animated];
}

- (void) getLatestPatientFromService
{
	
	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	patientXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientIdv]];
	
}

- (void) loadPatientData:(ServiceObject *)patient
{
	if ([patientXML hasData] && [patientXML.dict objectForKey:@"firstName"])
	{
		[self.txtMemberId setText:[patient getTextValueByName:@"memberId"]];
		[self.txtPatientName setText:[NSString stringWithFormat:@"%@ %@", [patient getTextValueByName:@"firstName"], [patient getTextValueByName:@"lastName"]]];
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
		
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowPatientImage.aspx?patientId=%d&type=%@&ignore=true", patientId, suffix]]];
		UIImage *uiimg = [[UIImage imageWithData:imageData] retain];
		id img = uiimg ? uiimg : [NSNull null];
		
		[mi addObject:img];
		
		cnt++;
	}
	
	patientImages = [[NSArray arrayWithArray:mi] retain];
	
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
	[super dealloc];
}

-(void)clickedPatientName:(NSNotification*)n
{
	UITextField *tf = (UITextField*) n.object;
	
	[tf resignFirstResponder];
	[tf endEditing:YES];
	NSLog(@"SPROING");
	
	NSLog(@"%@ -> %@ -> %@", n.name, n.object, n.userInfo);
	
	PatientSearch *patient=[[PatientSearch alloc]init];
	patient.title=@"Patient Selection";
	//[self.navigationController pushViewController:patient animated:YES];
	[self presentModalViewController:patient animated:YES];
}

- (IBAction)selectAndContinue:(id)sender {
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	NSString* returnedFrame = [NSString stringWithFormat:@"%d", self.selectedFrameId];
	
	if ([returnedFrame length] > 0)
	{
		NSLog(@"Updating selected FrameId to %@", returnedFrame);
		[mobileSessionXML setObject:returnedFrame forKey:@"frameId"];
		
		[mobileSessionXML updateMobileSessionData];
	}
	else
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please select a frame." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	if (self.selectedPackageId >= 0)
	{
		NSString *str = [NSString stringWithFormat:@"%d", self.selectedPackageId];
		[mobileSessionXML setObject:str forKey:@"packageId"];
		 
		[mobileSessionXML updateMobileSessionData];
	}
	else
	{
		
	}
	
	if (currentPatientId == 0)
	{
		PatientSearch *patient=[[PatientSearch alloc]init];
		patient.title=@"Patient Selection";
		//[self.navigationController pushViewController:patient animated:YES];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishContinue:) name:@"PatientSearchDidFinish" object:nil];
		
		[self presentModalViewController:patient animated:YES];
	}
	else
		[self finishContinue:self];
}

- (void)finishContinue:(id)sender
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"PatientSearchDidFinish" object:nil];
	
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	if (currentPatientId != 0)
	{
		PatientPrescription *patient=[[PatientPrescription alloc]init];
		patient.title=@"Prescription Information";
		[self.navigationController pushViewController:patient animated:YES];
	}
}

@end
