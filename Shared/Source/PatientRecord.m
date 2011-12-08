//
//  PatientRecord.m
//  Smart-i
//
//  Created by Troy Potts on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PatientRecord.h"
#import "MemberSearch.h"

extern ServiceObject* mobileSessionXML;

@implementation PatientRecord

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
	
	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	if (patientId == 0)
	{
		MemberSearch *patient=[[MemberSearch alloc]init];
		patient.title=@"Member Search";
		//[self.navigationController pushViewController:patient animated:YES];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberSearchDidFinish:) name:@"MemberSearchDidFinish" object:patient];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberSearchDidCancel:) name:@"MemberSearchDidCancel" object:patient];
		
		[self presentModalViewController:patient animated:YES];
		return;
	}
    // Do any additional setup after loading the view from its nib.
}

- (void)memberSearchDidFinish:(NSNotification*)n
{
	[self loadEverything];
}

- (void)memberSearchDidCancel:(NSNotification*)n
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void) loadEverything
{
	
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

- (void)dealloc {
	[super dealloc];
}
- (IBAction)searchForDifferentPatient:(id)sender {
	MemberSearch *patient=[[MemberSearch alloc]init];
	patient.title=@"Member Search";
	//[self.navigationController pushViewController:patient animated:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberSearchDidFinish:) name:@"MemberSearchDidFinish" object:patient];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberSearchDidCancel:) name:@"MemberSearchDidCancel" object:patient];
	
	[self presentModalViewController:patient animated:YES];
}

- (IBAction)back:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PatientRecordDidCancel" object:self];
	[self dismissModalViewControllerAnimated:YES];
}
@end
