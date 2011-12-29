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
extern ServiceObject* patientXML;

@implementation PatientRecord

@synthesize alreadyTriedSearch;
@synthesize didSelectNewPatient;
@synthesize cancelBtn;
@synthesize lblPatientName;
@synthesize lblPatientRelation;
@synthesize lblMemberId;
@synthesize lblMemberName;
@synthesize lblAuthNum;
@synthesize lblEffectiveDate;
@synthesize lblExpireDate;
@synthesize lblBirthDate;
@synthesize lblLastExamDate;
@synthesize lblDiagnosisCodes;
@synthesize lblBenefit;
@synthesize lblGroupName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.didSelectNewPatient = NO;
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
	
	self.alreadyTriedSearch = NO;
	
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	if (patientId == 0)
	{
	}
	else
	{
		[self loadPatientDetails];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	if (patientId == 0)
	{
		if (!alreadyTriedSearch)
		{
			alreadyTriedSearch = YES;
			{
				NSLog(@"trying to present member search...?");
				MemberSearch *patient=[[MemberSearch alloc]init];
				patient.title=@"Member Search";
				//[self.navigationController pushViewController:patient animated:YES];
				
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberSearchDidFinish:) name:@"MemberSearchDidFinish" object:patient];
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberSearchDidCancel:) name:@"MemberSearchDidCancel" object:patient];
				
				[self presentModalViewController:patient animated:YES];
			}
		}
		else
		{
			NSLog(@"cancelled member search");
			[self goBack];
		}
	}
}

- (void)loadPatientDetails
{
	NSLog(@"loadpatientdetails");
	
	NSString *patientName = [patientXML getTextValueByName:@"PatientFullName"];
	NSString *patientRelation = [patientXML getTextValueByName:@"MemberRelation"];
	NSString *memberId = [patientXML getTextValueByName:@"MemberId"];
	NSString *memberName = [patientXML getTextValueByName:@"MemberFullName"];
	
	NSString *authEffDate = [[patientXML getTextValueByName:@"EffectiveDate"] substringToIndex:10];
	NSString *authExpDate = [[patientXML getTextValueByName:@"ExpiredDate"] substringToIndex:10];
	NSString *patientDOB = [[patientXML getTextValueByName:@"DOB"] substringToIndex:10];
	
	self.lblPatientName.text = patientName;
	self.lblPatientRelation.text = patientRelation;
	self.lblMemberId.text = memberId;
	self.lblMemberName.text = memberName;
	
	self.lblEffectiveDate.text = authEffDate;
	self.lblExpireDate.text = authExpDate;
	self.lblBirthDate.text = patientDOB;
}

- (void)memberSearchDidFinish:(NSNotification*)n
{
	self.didSelectNewPatient = YES;
	self.cancelBtn.title = @"Select & Continue";
	[self loadEverything];
}

- (void)memberSearchDidCancel:(NSNotification*)n
{
}

- (void) loadEverything
{
	
}

- (void)viewDidUnload
{
	[self setCancelBtn:nil];
	[self setLblPatientName:nil];
	[self setLblPatientRelation:nil];
	[self setLblMemberId:nil];
	[self setLblMemberName:nil];
	[self setLblAuthNum:nil];
	[self setLblLastExamDate:nil];
	[self setLblDiagnosisCodes:nil];
	[self setLblBenefit:nil];
	[self setLblGroupName:nil];
	[self setLblBirthDate:nil];
	[self setLblEffectiveDate:nil];
	[self setLblExpireDate:nil];
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
	[cancelBtn release];
	[lblPatientName release];
	[lblPatientRelation release];
	[lblMemberId release];
	[lblMemberName release];
	[lblAuthNum release];
	[lblLastExamDate release];
	[lblDiagnosisCodes release];
	[lblBenefit release];
	[lblGroupName release];
	[lblBirthDate release];
	[lblEffectiveDate release];
	[lblExpireDate release];
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
	
	[self goBack];
}

- (void)goBack
{
	NSString *notificationName = @"PatientRecordDidCancel";
	if (self.didSelectNewPatient)
		notificationName = @"PatientRecordDidFinish";
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
	[self dismissModalViewControllerAnimated:YES];
}
@end
