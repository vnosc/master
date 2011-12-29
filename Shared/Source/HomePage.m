    //
//  HomePage.m
//  CyberImaging
//
//  Created by jay gurudev on 9/22/11.
//  Copyright 2011 software house. All rights reserved.
//

#import "HomePage.h"
#import "HomeView.h"
#import "CaptureOverview.h"
#import "Lenses.h"
#import "RXCustomTabBar.h"
#import "FrameSelectionandValidationNew.h"
#import "LensSelectionandValidation.h"
#import "UnityOpticsVideoView.h"
#import "Coating.h"
#import "VisionTestHomePage.h"

extern int providerId;
extern ServiceObject* mobileSessionXML;
extern ServiceObject* memberXML;
extern ServiceObject* patientXML;
extern ServiceObject* prescriptionXML;
extern ServiceObject* frameXML;
extern ServiceObject* lensTypeXML;
extern ServiceObject* materialXML;

extern NSString* lensBrandName;
extern NSString* lensDesignName;

extern NSArray* patientImages;
extern NSArray* patientImagesMeasured;

@implementation HomePage
@synthesize hackDropDownButton;
@synthesize hackDropDownView;
@synthesize hackAfterDropDownView;
@synthesize hackDropDownView2;
@synthesize sectionBtns;
@synthesize sectionSubmenuViews;
@synthesize testsBtn;
@synthesize mainview;
@synthesize adjust,lense,createuser,selectspect;
@synthesize frameselect,framevalidate,lensselect,lensvalidate;
@synthesize h;

- (NSString*) backgroundImageName { return @"MenuBackground.png"; }
- (NSString*) buttonImageName { return @"MenuButton.png"; }
- (NSString*) buttonHighlightedImageName { return @"MenuButtonTouch.png"; }
- (int) buttonImageLeftCap { return 20; }
- (int) buttonImageTopCap { return 6; }

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
#ifdef DEBUG
	self.testsBtn.hidden = NO;
#endif
	
	[self layoutSections];
}

-(IBAction) patientImageBtnClick:(id)sender
{
	h=[[CaptureOverview alloc]init];
	h.title=@"Capture Patient Image";
	//[self.navigationController pushViewController:h animated:YES];
	lense=[[Lenses alloc]init];
	lense.title=@"Measurement & lens Rules";

	
	adjust=[[Adjust alloc]init];
	adjust.title=@"Adjust";
	//adjust.tabBarItem.image=[UIImage imageNamed:@"save-property.png"];
	
	createuser=[[CreateUser alloc]init];
	createuser.title=@"CreateUser";
	//adjust.tabBarItem.image=[UIImage imageNamed:@"save-property.png"];
	
	selectspect=[[SelectSpech alloc]init];
	selectspect.title=@"SelectSpech";
	selectspect.tabBarItem.image=[UIImage imageNamed:@"specticon.png"];
	//adjust.tabBarItem.image=[UIImage imageNamed:@"save-property.png"];
	
	
	tabbar=[[UITabBarController alloc]init];

	//RXCustomTabBar *rx=[[RXCustomTabBar alloc]init];
	//tabbar=rx;
	//rx.delegate=self;
	//[rx	setViewControllers:[NSArray arrayWithObjects:h,lense,selectspect,adjust,createuser,nil]];
	
	tabbar.delegate=self;	
	[tabbar setViewControllers:[NSArray arrayWithObjects:h,lense,selectspect,adjust,createuser,nil]];
	
	
	[self.navigationController pushViewController:tabbar animated:YES];
	
	
	
}

- (IBAction)clearSessionBtnClick:(id)sender 
{
	[mobileSessionXML setObject:@"0" forKey:@"frameId"];
	[mobileSessionXML setObject:@"0" forKey:@"memberId"];
	[mobileSessionXML setObject:@"0" forKey:@"patientId"];
	[mobileSessionXML setObject:@"0" forKey:@"prescriptionId"];
	[mobileSessionXML setObject:@"0" forKey:@"lensTypeId"];
	[mobileSessionXML setObject:@"0" forKey:@"materialId"];
	[mobileSessionXML setObject:@"" forKey:@"lensOptionIds"];
	[mobileSessionXML setObject:@"0" forKey:@"materialColorId"];
	[mobileSessionXML setObject:@"0" forKey:@"tintColorId"];
	[mobileSessionXML setObject:@"0" forKey:@"lensBrandId"];
	[mobileSessionXML setObject:@"0" forKey:@"lensDesignId"];
	
	[mobileSessionXML updateMobileSessionData];
	
	[self clearCachedData];
	
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Session cleared." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
	
}

- (void)clearCachedData
{
	memberXML = nil;
	patientXML = nil;
	prescriptionXML = nil;
	frameXML = nil;
	lensTypeXML = nil;
	materialXML = nil;
	
	lensBrandName = nil;
	lensDesignName = nil;
	
	patientImages = nil;
	patientImagesMeasured = nil;
}

- (IBAction)unityBtnClick:(id)sender {
	UnityOpticsVideoView *v=[[UnityOpticsVideoView alloc]init];
    v.title=@"Unity Performance Optics";
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)testBtnClick:(id)sender {
	TestsPage *p = [[TestsPage alloc] init];
	p.title = @"Tests Page";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)packageSelectBtnClick:(id)sender {
	PackageSelection *p = [[PackageSelection alloc] init];
	p.title = @"Package Selection";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)frameStylingBtnClick:(id)sender {
	FrameStyling *p = [[FrameStyling alloc] init];
	p.title = @"Frame Styling";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)privatePatientBtnClick:(id)sender {
	FrameSelectionandValidationNew *p = [[FrameSelectionandValidationNew alloc] init];
	p.title = @"Frame Selection";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)productSelectDropDownClick:(id)sender {
	
	[self toggleDropDown:[sender tag]-1];
}

- (IBAction)visualAcuityBtnClick:(id)sender {
	VisionTestHomePage *p = [[VisionTestHomePage alloc] init];
	p.title = @"Vision Test";
	[self.navigationController pushViewController:p animated:YES];
}

- (void) toggleDropDown:(int)idx
{
	if (idx < [self.sectionSubmenuViews count])
	{
		UIView *v = [self.sectionSubmenuViews objectAtIndex:idx];
		v.hidden = !v.hidden;
		[self layoutSections];
	}
}

- (void) layoutSections
{
	float x = 20;
	float y = 20;
	
	float ypad = 5;
	
	for (UIButton *b in self.sectionBtns)
	{
		b.frame = CGRectMake(x, y, b.frame.size.width, b.frame.size.height);
		y += b.frame.size.height;
		
		int submenuIdx = [b tag] - 1;
		if (submenuIdx >= 0 && [self.sectionSubmenuViews count] > submenuIdx)
		{
			UIView *v = [self.sectionSubmenuViews objectAtIndex:submenuIdx];
			if (!v.hidden)
			{
				v.frame = CGRectMake(x + b.frame.size.width - v.frame.size.width, y, v.frame.size.width, v.frame.size.height);
				y += v.frame.size.height;
			}
		}
		y += ypad;
	}
	
	/*self.hackDropDownView.hidden = hide;
	self.hackDropDownView.frame = CGRectMake(self.hackDropDownButton.frame.origin.x + self.hackDropDownButton.frame.size.width - self.hackDropDownView.frame.size.width, self.hackDropDownButton.frame.origin.y + self.hackDropDownButton.frame.size.height, self.hackDropDownView.frame.size.width, self.hackDropDownView.frame.size.height);
	
	float y = self.hackDropDownButton.frame.origin.y + self.hackDropDownButton.frame.size.height;
	if (!self.hackDropDownView.hidden)
	{
		y += self.hackDropDownView.frame.size.height;
	}
	
	self.hackAfterDropDownView.frame = CGRectMake(self.hackAfterDropDownView.frame.origin.x, y, self.hackAfterDropDownView.frame.size.width, self.hackAfterDropDownView.frame.size.height);*/
}

-(IBAction) measurementBtnClick:(id)sender
{
	h=[[CaptureOverview alloc]init];
	h.title=@"Capture Image";
	[self.navigationController pushViewController:h animated:YES];		
}
-(IBAction) patientBtnClick:(id)sender
{
	
    LensIndexView *lensindex=[[LensIndexView alloc]init];
    lensindex.title=@"Lens Index";
	// lensIndexView.mainViewController=self;
    //UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:lensindex];
    
    Coating *coating=[[Coating alloc]init];
    coating.title=@"Coating";
    //UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:coating];
    
    UITabBarController *tabbar3=[[UITabBarController alloc]init];
	tabbar3.title = @"Lens Index";
	tabbar3.delegate = self;
    [tabbar3 setViewControllers:[NSArray arrayWithObjects:lensindex,coating,nil]];
    
    //[mainWindow addSubview:tabbar.view];
	[self.navigationController pushViewController:tabbar3 animated:YES];

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	NSLog(@"pring");
}
- (IBAction)lifeStyleBtnClick:(id)sender {
	PackageSelection *p = [[PackageSelection alloc] init];
	p.title = @"Package Selection";
	p.hackAltLifeStyleMode = YES;
	[self.navigationController pushViewController:p animated:YES];
}
-(IBAction) lensOptionBtnClick:(id)sender
{
    LensSelectionandValidation *lensSelect=[[LensSelectionandValidation alloc]init];
    lensSelect.title=@"Lens/Material Selection";
	lensSelect.tabBarItem.title = lensSelect.title;
    [self.navigationController pushViewController:lensSelect animated:YES];
}
-(IBAction) frameOptionBtnClick:(id)sender
{
    /*//FrameSelectionandValidation *frameSelect=[[FrameSelectionandValidation alloc]init];
	//FrameSelectionandValidationNew *frameSelect=[[FrameSelectionandValidationNew alloc]init];
    //frameSelect.title=@"Frame Selection/Validation";
    //[self.navigationController pushViewController:frameSelect animated:YES];
	
	frameselect=[[FrameSelectionandValidationNew alloc]init];
	frameselect.title=@"Frame Selection";
	frameselect.tabBarItem.title = frameselect.title;
	frameselect.tabBarItem.image=[UIImage imageNamed:@"camera1.png"];
	
	//[self.navigationController pushViewController:h animated:YES];
	framevalidate=[[Lenses alloc]init];
	framevalidate.title=@"Frame Validation";
	framevalidate.tabBarItem.image=[UIImage imageNamed:@"measurement.png"];
	
	lensselect=[[Adjust alloc]init];
	lensselect.title=@"Lens Selection";
	lensselect.tabBarItem.image=[UIImage imageNamed:@"advance1.png"];
	
	lensvalidate=[[CreateUser alloc]init];
	lensvalidate.title=@"Lens Validation";
	lensvalidate.tabBarItem.image=[UIImage imageNamed:@"useradd.png"];
	
	
	tabbar=[[UITabBarController alloc]init];
	
	//RXCustomTabBar *rx=[[RXCustomTabBar alloc]init];
	//tabbar=rx;
	//rx.delegate=self;
	//[rx	setViewControllers:[NSArray arrayWithObjects:h,lense,selectspect,adjust,createuser,nil]];
	
	tabbar.delegate=self;	

	[tabbar setViewControllers:[NSArray arrayWithObjects:frameselect,framevalidate,lensselect,lensvalidate,nil]];
	
	tabbar.title = [[[tabbar viewControllers] objectAtIndex:0] title];
	[self.navigationController pushViewController:tabbar animated:YES];*/
	
	SelectionSubmenu *vc = [[SelectionSubmenu alloc] init];
	vc.title = @"Frame/Lens/Material Selection";
	[self.navigationController pushViewController:vc animated:YES];

}
-(IBAction) framesTryoutBtnClick:(id)sender
{
}
-(IBAction) contactLensSelectionBtnClick:(id)sender
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [logoutBtn release];
    logoutBtn = nil;
    [clearSessionBtn release];
    clearSessionBtn = nil;
    [unityBtn release];
    unityBtn = nil;
	[self setHackAfterDropDownView:nil];
	[self setHackDropDownView:nil];
	[self setHackDropDownButton:nil];
	[self setHackDropDownView2:nil];
	[self setSectionBtns:nil];
	[self setSectionSubmenuViews:nil];
    [self setTestsBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [logoutBtn release];
    [clearSessionBtn release];
    [unityBtn release];
	[hackAfterDropDownView release];
	[hackDropDownView release];
	[hackDropDownButton release];
	[hackDropDownView2 release];
	[sectionBtns release];
	[sectionSubmenuViews release];
    [testsBtn release];
    [super dealloc];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	NSLog(@"Index : %i",tabBarController.selectedIndex);
	if(tabBarController.selectedIndex==0)
	{
		adjust.image=h.imageView3.image;
		selectspect.image=h.imageView1.image;
		createuser.image=h.imageView1.image;
		lense.image=h.imageView1.image;
        lense.image_1=h.imageView2.image;
        lense.image_2=h.imageView3.image;
		
	}
	
	tabBarController.title = viewController.title;
	return YES;
}

/*
- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
	if(theTabBarController.selectedIndex==2)
	{
		adjust.image=h.smallImage.image;
		
	}
	if (theTabBarController.selectedIndex==4)
	{
		createuser.image=h.smallImage2.image;
	}
	
}*/

- (IBAction)logoutBtnClick:(id)sender
{
	providerId = 0;
	[self clearCachedData];
	[mainview showLogin];
}

- (void) pressTab
{
	
}

@end
