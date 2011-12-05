//
//  BillingTypeSelection.m
//  CyberImaging
//
//  Created by Troy Potts on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BillingTypeSelection.h"

@implementation BillingTypeSelection
@synthesize ltvc;
@synthesize btn;

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
	
	int si = [self.ltvc addSection:@"Billing Type" options:0];
	
	NSArray* billingTypes = [NSArray arrayWithObjects:@"VSP - Std 1st", @"VSP - Std 2nd", @"VSP - Std VDT", @"VSP - Select", @"Medical", @"EyeMed", @"VSP - Advant", @"VSP - Value", @"Mesc", @"AVP", @"Cash", @"Superior", nil];

	int cnt=0;
	for (id str in billingTypes)
	{
		[self.ltvc addOptionForSection:si option:str optionValue:[NSString stringWithFormat:@"%d", cnt]];
		cnt++;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientSearchDidFinish:) name:@"PatientSearchDidFinish" object:nil];
}

- (void)viewDidUnload
{
	[self setLtvc:nil];
	[self setBtn:nil];
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
	[ltvc release];
	[btn release];
	[super dealloc];
}

- (void)patientSearchDidFinish:(id)sender
{
	PackageSelection *p = [[PackageSelection alloc] init];
	p.title = @"Package Selection";
	[self.navigationController pushViewController:p animated:YES];
}
@end
