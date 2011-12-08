//
//  MemberSearch.m
//  CyberImaging
//
//  Created by Troy Potts on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MemberSearch.h"
#import "PatientPrescription.h"
#import "NewUser.h"

extern ServiceObject* memberXML;
extern ServiceObject* mobileSessionXML;
extern ServiceObject* patientXML;

@implementation MemberSearch

@synthesize memberSSN;
@synthesize memberId;
@synthesize dob;
@synthesize memberFirstName;
@synthesize memberDate;
@synthesize memberNameLbl;
@synthesize memberPlanLbl;
@synthesize memberPlanTypeDescLbl;
@synthesize memberDetailsView;
@synthesize patientListSV;
@synthesize patientListHeaderView;
@synthesize patientListHeader1;
@synthesize patientListHeader2;
@synthesize patientListHeader3;
@synthesize memberLastName;

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
	
	self.patientListSV.bounces = NO;
	self.patientListSV.showsHorizontalScrollIndicator = NO;
}

- (void)viewDidUnload
{
	[self setMemberId:nil];
	[self setDob:nil];
	
	[self setMemberLastName:nil];
	[self setMemberDate:nil];

	[self setMemberFirstName:nil];
	[self setMemberSSN:nil];
	[self setMemberNameLbl:nil];
	[self setMemberDetailsView:nil];
	[self setPatientListSV:nil];
	[self setPatientListHeaderView:nil];
	[self setPatientListHeader1:nil];
	[self setPatientListHeader2:nil];
	[self setPatientListHeader3:nil];
	[self setMemberPlanLbl:nil];
	[self setMemberPlanTypeDescLbl:nil];
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
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MemberSearchDidFinish" object:self];
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
	[memberId release];
	[dob release];
	
	[memberLastName release];
	[memberDate release];
	
	[memberFirstName release];
	[memberSSN release];
	[memberNameLbl release];
	[memberDetailsView release];
	[patientListSV release];
	[patientListHeaderView release];
	[patientListHeader1 release];
	[patientListHeader2 release];
	[patientListHeader3 release];
	[memberPlanLbl release];
	[memberPlanTypeDescLbl release];
	[super dealloc];
}
- (IBAction)search:(id)sender {
		
		if([memberId.text length]==0 || [dob.text length]==0)
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please enter a member ID and a date of birth." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
		else
		{
			ServiceObject* result = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetMemberInfoByMemberIdAndDOB?MemberId=%@&DOB=%@", memberId.text, dob.text]];

			if([result hasData])
			{
				int tempMemberId = [result getIntValueByName:@"MemberID"];
				
				if(tempMemberId==0)
				{
					UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No members found." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
					[alert show];
					[alert release];
				}
				else
				{
					memberXML = result;
					
					[mobileSessionXML setObject:[NSString stringWithFormat:@"%d", tempMemberId] forKey:@"memberId"];
					
					[mobileSessionXML updateMobileSessionData];
					
					NSString* memberFN = [[result getTextValueByName:@"Memberfirstname"] uppercaseString];
					NSString* memberLN = [[result getTextValueByName:@"MemberlastName"] uppercaseString];
					
					NSString* memberPlan = [result getTextValueByName:@"InsPlan"];
					NSString* memberPlanType = [result getTextValueByName:@"Plan"];
					
					self.memberNameLbl.text = [NSString stringWithFormat:@"%@, %@", memberLN, memberFN];
					self.memberPlanLbl.text = memberPlan;
					self.memberPlanTypeDescLbl.text = [NSString stringWithFormat:@"This is a %@ patient.", memberPlanType];
					
					[self showMemberDetails];
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

- (void) showMemberDetails
{
	self.memberDetailsView.hidden = NO;
	
	for (id v in self.patientListSV.subviews)
		[v removeFromSuperview];
	
	NSLog(@"---------------------------------");
	
	ServiceObject* result = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetAllPatientInfoByMemberIdAndDOB?MemberId=%@&DOB=%@", memberId.text, dob.text] categoryKey:@"" startTag:@"Table"];	
	
	BOOL hasObjs = YES;
	
	float ny=0;
	float hx1 = self.patientListHeader1.frame.origin.x;
	float hx2 = self.patientListHeader2.frame.origin.x;
	float hx3 = self.patientListHeader3.frame.origin.x;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [result.dict objectForKey:key];
		
		if (obj)
		{
			int patientId = [result getIntValueByName:[NSString stringWithFormat:@"%@/PatientId", key]];
			
			NSString* patientLastName = [result getTextValueByName:[NSString stringWithFormat:@"%@/LastName", key]];
			NSString* patientFirstName = [result getTextValueByName:[NSString stringWithFormat:@"%@/FirstName", key]];
			NSString* patientRelation = [result getTextValueByName:[NSString stringWithFormat:@"%@/MemberRelation", key]];
			NSString* patientDOB = [[result getTextValueByName:[NSString stringWithFormat:@"%@/DOB", key]] substringToIndex:10];
			
			UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[b setTitle:@"Select" forState:UIControlStateNormal];
			b.titleLabel.textColor = [UIColor blackColor];
			b.titleLabel.font = [UIFont systemFontOfSize:10.0f];
			//[b sizeToFit];
			[self.patientListSV addSubview:b];
			b.frame = CGRectMake(0, ny, 60, 20);
			b.tag = patientId;
			NSLog(@"adding patient %d", patientId);
			[b addTarget:self action:@selector(patientBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			
			UILabel *l = [[UILabel alloc] init];
			l.text = [NSString stringWithFormat:@"%@, %@", patientLastName, patientFirstName];
			l.textColor = [UIColor whiteColor];
			l.backgroundColor = [UIColor clearColor];
			[l sizeToFit];
			l.frame = CGRectMake(hx1, ny, l.frame.size.width, l.frame.size.height);			
			[self.patientListSV addSubview:l];
			
			UILabel *l2 = [[UILabel alloc] init];
			l2.text = patientRelation;
			l2.textColor = [UIColor whiteColor];
			l2.backgroundColor = [UIColor clearColor];
			[l2 sizeToFit];
			l2.frame = CGRectMake(hx2, ny, l2.frame.size.width, l2.frame.size.height);			
			[self.patientListSV addSubview:l2];

			UILabel *l3 = [[UILabel alloc] init];
			l3.text = patientDOB;
			l3.textColor = [UIColor whiteColor];
			l3.backgroundColor = [UIColor clearColor];
			[l3 sizeToFit];
			l3.frame = CGRectMake(hx3, ny, l3.frame.size.width, l3.frame.size.height);			
			[self.patientListSV addSubview:l3];
			
			ny += MAX(b.frame.size.height, l.frame.size.height);
		}
		else
			hasObjs = NO;
	}
	
	[self.patientListSV setContentSize:CGSizeMake(self.patientListSV.frame.size.width, ny)];
}

- (void)patientBtnClick:(id)sender
{
	UIButton *b = (UIButton*) sender;
	int patientId = b.tag;
	
	[mobileSessionXML setObject:[NSNumber numberWithInt:patientId] forKey:@"patientId"];
	[mobileSessionXML updateMobileSessionData];
	
	ServiceObject *p = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientId]];
	patientXML = p;
	
	[self continueToPrescriptionPage];
}

- (IBAction)cancel:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MemberSearchDidCancel" object:self];
	[self dismissModalViewControllerAnimated:YES];
}
@end
