//
//  NewUser.m
//  CyberImaging
//
//  Created by Patel on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewUser.h"
#import "TBXML.h"

@implementation NewUser
@synthesize txt_memberid;
@synthesize  txt_firstname, txt_lastname, txt_gender, txt_dob, txt_phone, txt_email, txt_fax, txt_address1, txt_address2, txt_state,txt_city, txt_zip,txt_plan, txt_insurancetype, txt_effectivedate,txt_expireddate, txt_terminationdate,txt_employer,txt_status;

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
	[txt_memberid release];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[self setTxt_memberid:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)saveButtonPress:(id)sender
{
    
	ServiceObject *so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"SavePatientCompleteInfo?firstname=%@&lastName=%@&DOB=%@&Address=%@&address2=%@&City=%@&State=%@&ZIP=%@&Insuranceplan=1&Insurancepaln2=2&Usage=true&UsageDate=01-01-2011&usageLens=true&usageLensDate=01-01-2011&usageFrame=true&usageFrameDate=01-01-2011&UsageEyeexamse=true&UsageEyeexamseDate=01-01-2011&deductable=true&otherbenefit=true&memnberRef=sdsdsdsdsdsdds&frameenbled=true&lensenabled=true&optionenabled=true&lob=sdsdsdsdsd&groupId=1&groupnumber=1&Gender=%@&Email=%@&Phone=%@&Fax=%@&Employer=%@&StatusId=1&EffectiveDate=%@&ExpiredDate=%@&TerminationDate=%@&usageOption=12&usageOptionDate=01-01-2011",txt_firstname.text,txt_lastname.text,txt_dob.text,txt_address1.text,txt_address2.text,txt_city.text,txt_state.text,txt_zip.text, [txt_gender titleForSegmentAtIndex:txt_gender.selectedSegmentIndex],txt_email.text,txt_phone.text,txt_fax.text,txt_employer.text,txt_effectivedate.text,txt_expireddate.text,txt_terminationdate.text]];

	int patientId = [so getIntValueByName:@"patientId"];
	
	if (patientId == 0)
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Unable to create new patient." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
	}
	else
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Patient created successfully." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		
		[alert show];
		[alert release];                
		
		[self dismissModalViewControllerAnimated:YES];
		//[self.navigationController popViewControllerAnimated:YES];
	}
    
}

- (IBAction)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
