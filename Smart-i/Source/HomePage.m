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
#import "Coating.h"
#import "Lenses.h"
#import "RXCustomTabBar.h"
#import "FrameSelectionandValidationNew.h"
#import "LensSelectionandValidation.h"
#import "UnityOpticsVideoView.h"

extern int providerId;
extern ServiceObject* mobileSessionXML;

extern NSString* lensBrandName;
extern NSString* lensDesignName;

extern NSArray* patientImages;
extern NSArray* patientImagesMeasured;

@implementation SmartI_HomePage

@synthesize tbc;
@synthesize mainview;
@synthesize mainTabBar;

@synthesize hackDropDownButton;
@synthesize hackDropDownView;
@synthesize hackAfterDropDownView;
@synthesize hackDropDownView2;
@synthesize sectionBtns;
@synthesize sectionSubmenuViews;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.*/
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"uh...?");
	
	measure=[[PatientList alloc]init];
	measure.title=@"Order Management";
	measure.firstURL=@"Mobile_ListOrder.aspx";
	measure.btnLabels = [NSArray arrayWithObjects:@"View Orders", @"Create Private Order", @"Create Insurance Order", nil];
	measure.btnURLs = [NSArray arrayWithObjects:@"Mobile_ListOrder.aspx", @"Mobile_NewOrder.aspx", @"", nil];
	
	lense=[[PatientList alloc]init];
	lense.title=@"Patient Management";
	lense.firstURL=@"Mobile_ListPatients.aspx";
	lense.btnLabels = [NSArray arrayWithObjects:@"List Patients", @"Search for New Patient", nil];
	lense.btnURLs = [NSArray arrayWithObjects:@"Mobile_ListPatients.aspx", @"Mobile_PatientValidation.aspx", nil];
	
	adjust=[[PatientList alloc]init];
	adjust.title=@"Claim Management";
	adjust.firstURL=@"Mobile_ListClaims.aspx";
	adjust.btnLabels = [NSArray arrayWithObjects:@"List Claims", @"Submit New Claim", nil];
	adjust.btnURLs = [NSArray arrayWithObjects:@"Mobile_ListClaims.aspx", @"Mobile_SubmitClaim.aspx", nil];
	
	[tbc setViewControllers:[NSArray arrayWithObjects:self.navigationController,measure,lense,adjust, nil]];
	self.title = @"Main";
	
		//[self TabBarIncreaseFonts:self.tbc];
	
	[mainview.mainWindow addSubview:tbc.view];
	[self.view removeFromSuperview];
}

-(IBAction) measurementBtnClick:(id)sender
{
	CaptureOverview *h = [[CaptureOverview alloc]init];
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

- (IBAction)visionTestBtnClick:(id)sender {
	VisionTestHomePage *p = [[VisionTestHomePage alloc] init];
	p.title = @"Vision Test";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)orderMgmtBtnClick:(id)sender {
	[tbc setSelectedViewController:measure];
}

- (IBAction)claimMgmtBtnClick:(id)sender {
	[tbc setSelectedViewController:lense];
}

- (IBAction)patientMgmtBtnClick:(id)sender {
	[tbc setSelectedViewController:adjust];
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

-(void)viewDidAppear:(BOOL)animated
{
	//[self.tbc.tabBar setNeedsLayout];
	//[self.tbc.tabBar setNeedsDisplay];
}

- (void) TabBarIncreaseFonts:(UITabBarController*) customTabBarController
{
    for(UIView* controlLevelFirst in [customTabBarController.tabBar subviews])
    {
		
		NSLog(@"%@", controlLevelFirst);
		NSLog(@"%f,%f,%f,%f", controlLevelFirst.layer.frame.origin.x, controlLevelFirst.layer.frame.origin.y, controlLevelFirst.layer.frame.size.width, controlLevelFirst.layer.frame.size.height);
		
        if(![controlLevelFirst isKindOfClass:NSClassFromString(@"UITabBarButton")])
            continue;
		
		[controlLevelFirst setBounds: CGRectMake(0, 0, 200, 48)];
		[controlLevelFirst setFrame: CGRectMake(1, 1, 196, 48)];
		
		NSLog(@"%@", controlLevelFirst);
		NSLog(@"%f,%f,%f,%f", controlLevelFirst.layer.frame.origin.x, controlLevelFirst.layer.frame.origin.y, controlLevelFirst.layer.frame.size.width, controlLevelFirst.layer.frame.size.height);
		
        for(id controlLevelSecond in [controlLevelFirst subviews])
        {
			NSLog(@"-- %@", controlLevelSecond);
            [controlLevelSecond setBounds: CGRectMake(0, 0, 200, 48)];
			[controlLevelSecond setFrame: CGRectMake(0, 0, 196, 48)];
			
            if(![controlLevelSecond isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")])
				continue;
			
			[controlLevelSecond setClipsToBounds:NO];
			[controlLevelSecond setFont: [UIFont boldSystemFontOfSize:20]]; 
			[controlLevelSecond setTextAlignment:UITextAlignmentCenter];
        }
    }
}

- (IBAction)testBtnClick:(id)sender {
	TestsPage *p = [[TestsPage alloc] init];
	p.title = @"Tests Page";
	[self.navigationController pushViewController:p animated:YES];
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
	[self setTbc:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [logoutBtn release];
    [clearSessionBtn release];
	[tbc release];
    [super dealloc];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	NSLog(@"YAY");
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	NSLog(@"YAY");
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	NSLog(@"Index : %i",tabBarController.selectedIndex);

	
	tabBarController.title = viewController.title;
	return YES;
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
	float x = 284;
	float y = 330;
	
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

- (IBAction)triggerDropDownMenu:(id)sender {
	[self toggleDropDown:[sender tag]-1];
}

- (IBAction)logoutBtnClick:(id)sender
{
	providerId = 0;
	[mainview showLogin];
}

- (void) pressTab
{
	
}

@end
