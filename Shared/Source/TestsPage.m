//
//  TestsPage.m
//  CyberImaging
//
//  Created by Troy Potts on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestsPage.h"

@implementation TestsPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)openCVTestingClick:(id)sender {
	OpenCVTesting *p = [[OpenCVTesting alloc] init];
	p.title = @"OpenCVTesting";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)packageSelectionClick:(id)sender {
	PackageSelection *p = [[PackageSelection alloc] init];
	p.title = @"Package Selection";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)billingTypeSelectionClick:(id)sender {
	BillingTypeSelection *p = [[BillingTypeSelection alloc] init];
	p.title = @"Billing Type Selection";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)frameStylingClick:(id)sender {
	FrameStyling *p = [[FrameStyling alloc] init];
	p.title = @"Frame Styling";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)supplyFrameInfo:(id)sender {
	SupplyFrameInfo *p = [[SupplyFrameInfo alloc] init];
	p.title = @"Supply Frame Info";
	[self.navigationController presentModalViewController:p animated:YES];
}

#ifdef OPTISUITE

- (IBAction)patientConsultationClick:(id)sender {
	LensIndexView *p = [[LensIndexView alloc] init];
	p.title = @"Lens Index View";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)mainMenuRecreationClick:(id)sender {
	HomePage *p = [[HomePage alloc] initWithNibName:@"HomePage2.xib" bundle:nil];
	p.title = @"Home Recreation";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)wrapAngleMeasureClick:(id)sender {
	MeasureWrapAngle *p = [[MeasureWrapAngle alloc] init];
	p.title = @"Measure Wrap Angle";
	[self.navigationController pushViewController:p animated:YES];
}

#endif

@end
