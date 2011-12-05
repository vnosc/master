//
//  PatientSearch.m
//  CyberImaging
//
//  Created by Troy Potts on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PatientSearch.h"
#import "PatientPrescription.h"
#import "NewUser.h"

extern ServiceObject* patientXML;
extern ServiceObject* mobileSessionXML;

@implementation PatientSearch

@synthesize patientId;
@synthesize dob1;

@synthesize patientLastName;
@synthesize dob2;

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
	[self setPatientId:nil];
	[self setDob1:nil];
	
	[self setPatientLastName:nil];
	[self setDob2:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void) continueToPrescriptionPage
{
	//[self.navigationController popViewControllerAnimated:YES];
	
	//[self dismissModalViewControllerAnimated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PatientSearchDidFinish" object:self];
	[self dismissModalViewControllerAnimated:YES];
	
    /*PatientPrescription *patient=[[PatientPrescription alloc]init];
    patient.title=@"Prescription Information";
    [self.navigationController pushViewController:patient animated:YES];*/
}

-(void) continueToNewPatientPage
{
    NewUser *newuser=[[NewUser alloc]init];
    newuser.title=@"Create New Patient";
    //[self.navigationController pushViewController:newuser animated:YES];	
	[self presentModalViewController:newuser animated:YES];
	
	//[self dismissViewControllerAnimated:YES];
}

- (void)dealloc {
	[patientId release];
	[dob1 release];
	
	[patientLastName release];
	[dob2 release];
	
	[super dealloc];
}
- (IBAction)searchByPatientId:(id)sender {
		
		if([patientId.text length]==0 || [dob1.text length]==0)
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please enter a patient ID and a date of birth." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
		else
		{
			ServiceObject* result = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfoByMemberIdAndDOB?MemberId=%@&DOB=%@", patientId.text, dob1.text]];

			if([result hasData])
			{
				int tempPatientId = [result getIntValueByName:@"patientId"];
				
				if(tempPatientId==0)
				{
					UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No patients found." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
					[alert show];
					[alert release];
				}
				else
				{
					patientXML = result;
					
					[mobileSessionXML setObject:[NSString stringWithFormat:@"%d", tempPatientId] forKey:@"patientId"];
					
					[mobileSessionXML updateMobileSessionData];
					
					[self continueToPrescriptionPage];
				}
			}
			else
			{
				//NSLog(@"Invalid response from web service at: %@", url);
				
				UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid response from server" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				[alert show];
				[alert release];
			}
		}
		
		//[mainView showHome]; 
	
}

- (IBAction)searchByLastName:(id)sender {
}

- (IBAction)newPatient:(id)sender {
	[self continueToNewPatientPage];
}

- (IBAction)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}
@end
