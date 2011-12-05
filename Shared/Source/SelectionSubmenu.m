    //
//  HomePage.m
//  CyberImaging
//
//  Created by jay gurudev on 9/22/11.
//  Copyright 2011 software house. All rights reserved.
//

#import "SelectionSubmenu.h"
#import "HomeView.h"


#import "RXCustomTabBar.h"

extern int providerId;
extern ServiceObject* mobileSessionXML;

extern NSString* lensBrandName;
extern NSString* lensDesignName;

extern NSArray* patientImages;
extern NSArray* patientImagesMeasured;

@implementation SelectionSubmenu

@synthesize mainview;

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
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(IBAction) patientBtnClick:(id)sender
{
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	if (currentPatientId == 0)
	{
		PatientSearch *patient=[[PatientSearch alloc]init];
		patient.title=@"Patient Selection";
		//[self.navigationController pushViewController:patient animated:YES];
		[self presentModalViewController:patient animated:YES];
	}
	currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	if (currentPatientId != 0)
	{
		PatientPrescription *patient=[[PatientPrescription alloc]init];
		patient.title=@"Prescription Information";
		[self.navigationController pushViewController:patient animated:YES];
	}
}

-(IBAction)lensMaterialBtnClick:(id)sender
{
	//int frameId = mobileSessionXML
	LensSelectionandValidation *vc = [[LensSelectionandValidation alloc] init];
    vc.title=@"Lens/Material Selection";
	vc.tabBarItem.title = vc.title;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction) lensOptionBtnClick:(id)sender
{
    LensOptionSelection *vc = [[LensOptionSelection alloc] init];
    vc.title=@"Lens Option Selection";
	vc.tabBarItem.title = vc.title;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction) frameTryonBtnClick:(id)sender
{
}

-(IBAction) frameBtnClick:(id)sender
{
	//FrameSelectionandValidation *frameSelect=[[FrameSelectionandValidation alloc]init];
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
	
	[self.navigationController pushViewController:tabbar animated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {

    [super dealloc];
}


/*- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
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
}*/

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

- (IBAction) backBtnClick:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
