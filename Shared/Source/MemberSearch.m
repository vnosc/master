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

#import "MemberRecord.h"

extern ServiceObject* memberXML;
extern ServiceObject* mobileSessionXML;
extern ServiceObject* patientXML;
extern NSArray *patientImages;

@implementation MemberSearch

@synthesize memberSSN;
@synthesize memberId;
@synthesize dob;
@synthesize memberFirstName;
@synthesize memberDate;
@synthesize memberNameLbl;
@synthesize memberPlanLbl;
@synthesize memberPlanTypeDescLbl;
@synthesize searchCriteriaView;
@synthesize memberDetailsView;
@synthesize memberListSV;
@synthesize memberListHeaders;
@synthesize memberLastName;

@synthesize HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isFinished = NO;
        _searchResults = [ServiceObject alloc];
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
	
	self.memberListSV.bounces = NO;
	self.memberListSV.showsVerticalScrollIndicator = YES;
	self.memberListSV.showsHorizontalScrollIndicator = NO;
	
    [self setBoxBackgroundLarge:searchCriteriaView];
    [self setBoxBackground:memberDetailsView];
    
	NSString* memberId = [mobileSessionXML getTextValueByName:@"memberId"];
	if ([memberId length] > 0 && [memberXML hasData])
	{
		NSString* memberId = [memberXML getTextValueByName:@"MemberID"];
		NSString* memberDOB = [[memberXML getTextValueByName:@"DOB"] substringToIndex:10];
		
		self.memberId.text = memberId;
		self.dob.text = memberDOB;
		
		[self showMemberDetails];
	}
	
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFinished)
        [self finish];
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
	[self setmemberListSV:nil];
	[self setMemberPlanLbl:nil];
	[self setMemberPlanTypeDescLbl:nil];
    [self setSearchCriteriaView:nil];
    [self setMemberListHeaders:nil];
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
	//[self dismissModalViewControllerAnimated:YES];
	
    NSLog(@"test?");
    
    MemberRecord *patient=[[MemberRecord alloc]init];
    patient.title=@"Authorizations & Coverage";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberRecordDidFinish:) name:@"MemberRecordDidFinish" object:patient];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberRecordDidCancel:) name:@"MemberRecordDidCancel" object:patient];
    
    [self presentModalViewController:patient animated:YES];
}

- (void) memberRecordDidFinish:(NSNotification*)n
{
    NSLog(@"record finished");
    
    isFinished = YES;
}

- (void) finish
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MemberSearchDidFinish" object:self];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) memberRecordDidCancel:(NSNotification*)n
{
    NSLog(@"record cancelled");
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
	[memberListSV release];
	[memberPlanLbl release];
	[memberPlanTypeDescLbl release];
    [searchCriteriaView release];
    [memberListHeaders release];
	[super dealloc];
}
- (IBAction)search:(id)sender {
		
		if([memberId.text length]==0 || [dob.text length]==0)
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please enter a member ID and a date of birth." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
		else
		{
			HUD = [[MBProgressHUD alloc] initWithView:self.view];
			[self.view addSubview:HUD];
			
			HUD.labelText = @"Searching...";
			
			[HUD showWhileExecuting:@selector(doSearch:) onTarget:self withObject:self animated:YES];
			
		}
	
}

- (void) doSearch:(id)sender
{
	ServiceObject* result = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetMemberInfoByMemberIdAndDOB?MemberId=%@&DOB=%@", memberId.text, dob.text] categoryKey:@"" startTag:@"Table"];
	
	if([result hasData])
	{
		NSString* tempMemberId = [result getTextValueByName:@"Table1/MemberID"];
		
		if(!tempMemberId)
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No members found." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
		else
		{
			memberXML = [result retain];
			
			[mobileSessionXML setObject:[NSString stringWithFormat:@"%@", tempMemberId] forKey:@"memberId"];
			
			[mobileSessionXML updateMobileSessionData];
			
            _searchResults = result;
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
- (void) showMemberDetails
{
    
    ServiceObject *result = _searchResults;
    
	for (id v in self.memberListSV.subviews)
		[v removeFromSuperview];
	
	NSLog(@"---------------------------------");
	
	BOOL hasObjs = YES;
	
	float ny=0;
	float hx1 = ((UILabel*) [self.memberListHeaders objectAtIndex:0]).frame.origin.x;
	float hx2 = ((UILabel*) [self.memberListHeaders objectAtIndex:1]).frame.origin.x;
	float hx3 = ((UILabel*) [self.memberListHeaders objectAtIndex:2]).frame.origin.x;
    float hx4 = ((UILabel*) [self.memberListHeaders objectAtIndex:3]).frame.origin.x;
    float hx5 = ((UILabel*) [self.memberListHeaders objectAtIndex:4]).frame.origin.x;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [result.dict objectForKey:key];
		
		if (obj)
		{
			int rowId = [result getIntValueByName:[NSString stringWithFormat:@"%@/RowId", key]];			
			NSString* memberLN = [result getTextValueByName:[NSString stringWithFormat:@"%@/MemberlastName", key]];
			NSString* memberFN = [result getTextValueByName:[NSString stringWithFormat:@"%@/Memberfirstname", key]];
			NSString* memberDOB = [[result getTextValueByName:[NSString stringWithFormat:@"%@/DOB", key]] substringToIndex:10];
			//NSString* memberSSN = [[result getTextValueByName:[NSString stringWithFormat:@"%@/DOB", key]] substringToIndex:10];
            NSString *memberSSN4 = @"";
            NSString *memberCity = [result getTextValueByName:[NSString stringWithFormat:@"%@/memberCity", key]];
            NSString *memberState = [result getTextValueByName:[NSString stringWithFormat:@"%@/memberState", key]];
			
			UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
			[b setTitle:@"Select" forState:UIControlStateNormal];
			b.titleLabel.textColor = [UIColor blackColor];
			b.titleLabel.font = [UIFont systemFontOfSize:10.0f];
			//[b sizeToFit];
			[self.memberListSV addSubview:b];
			b.frame = CGRectMake(0, ny, 60, 20);
			b.tag = cnt;
            
			NSLog(@"adding member %d", cnt);
			[b addTarget:self action:@selector(memberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			
            [self addMemberLabel:[NSString stringWithFormat:@"%@, %@", memberLN, memberFN] x:hx1 y:ny];

            [self addMemberLabel:memberDOB x:hx2 y:ny];
			
            [self addMemberLabel:memberSSN4 x:hx3 y:ny];		

            [self addMemberLabel:[NSString stringWithFormat:@"%@, %@", memberCity, memberState] x:hx4 y:ny];
            
            [self addMemberLabel:@"ACTIVES BUY-UP" x:hx5 y:ny];
            
			ny += MAX(b.frame.size.height, 20);
		}
		else
			hasObjs = NO;
	}
	
	[self.memberListSV setContentSize:CGSizeMake(self.memberListSV.frame.size.width, ny)];
	
    [self applyChangesToSubviews:self.view];
    
	self.memberDetailsView.hidden = NO;
}

- (void)addMemberLabel:(NSString*)text x:(int)x y:(int)y
{
    UILabel *l = [[UILabel alloc] init];
    l.text = text;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor clearColor];
    [l sizeToFit];
    l.frame = CGRectMake(x - self.memberListSV.frame.origin.x, y, l.frame.size.width, l.frame.size.height);			
    [self.memberListSV addSubview:l];
}
- (void)memberBtnClick:(id)sender
{
	UIButton *b = (UIButton*) sender;	
	int memberRowId = b.tag;
	
    NSString *memberID = [_searchResults getTextValueByName:[NSString stringWithFormat:@"Table%d/MemberID", memberRowId]];
    NSString *memberDOB = [[_searchResults getTextValueByName:[NSString stringWithFormat:@"Table%d/DOB", memberRowId]] substringToIndex:10];
    
    ServiceObject* result = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetMemberInfoByMemberIdAndDOB?MemberId=%@&DOB=%@", memberID, memberDOB]];
    
	[mobileSessionXML setObject:[NSString stringWithFormat:@"%@", memberID] forKey:@"memberId"];
	[mobileSessionXML updateMobileSessionData];
    
    memberXML = [result retain];
    
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.labelText = @"Getting patient info...";
	
	[HUD showWhileExecuting:@selector(loadImagesAndFinish:) onTarget:self withObject:sender animated:YES];
}

- (void)loadImagesAndFinish:(id)sender
{
	UIButton *b = (UIButton*) sender;
	int patientId = b.tag;
	
	//[mobileSessionXML setObject:[NSString stringWithFormat:@"%d", patientId] forKey:@"patientId"];
	//[mobileSessionXML updateMobileSessionData];
	
	ServiceObject *p = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientId]];
	patientXML = p;
	
	//[self loadPatientImages];
	
	[self continueToPrescriptionPage];
}

- (void)loadPatientImages
{
	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	int cnt=0;
	
	cnt=0;
	
			NSArray *suffixes = [NSArray arrayWithObjects:@"dist", @"near", @"side", @"tryon", nil];
	
	NSMutableArray *tempImages = [NSMutableArray array];
	
	for (NSString *suffix in suffixes)
	{
		
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[ServiceObject urlOfWebPage:[NSString stringWithFormat:@"ShowPatientImage.aspx?patientId=%d&type=%@&ignore=true", patientId, suffix]]]];
		UIImage *img = [[UIImage imageWithData:imageData] retain];
		id imgG = img ? img : [NSNull null];
		[tempImages addObject:imgG];
		cnt++;
	}
	
	patientImages = [[NSArray arrayWithArray:tempImages] retain];
	
}

- (IBAction)cancel:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MemberSearchDidCancel" object:self];
	[self dismissModalViewControllerAnimated:YES];
}
@end
