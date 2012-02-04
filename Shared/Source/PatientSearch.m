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

extern ServiceObject* providerXML;
extern ServiceObject* mobileSessionXML;
extern ServiceObject* patientXML;
extern ServiceObject* providerId;
extern NSArray *patientImages;

@implementation PatientSearch

@synthesize dob;
@synthesize patientFirstName;
@synthesize patientLastName;
@synthesize providerNameLbl;
@synthesize searchResultsView;
@synthesize foundPatientsView;
@synthesize searchCriteriaView;
@synthesize providerInfoView;
@synthesize patientDetailsView;
@synthesize patientListSV;
@synthesize patientListHeaders;
@synthesize providerDDL;

@synthesize HUD;

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
	self.patientListSV.showsVerticalScrollIndicator = YES;
	self.patientListSV.showsHorizontalScrollIndicator = NO;
	
    [self setBoxBackgroundLarge:self.searchCriteriaView];
    [self setBoxBackgroundLarge:self.providerInfoView];
    [self setBoxBackgroundLarge:self.foundPatientsView];
    
    [self setBoxBackground:self.patientDetailsView];
    
    [self setDropDownBackground:self.providerDDL];
    
    [self loadProviderList];
    
    //[self showPatientList];
	
}

- (void)loadProviderList
{
    //temp hack
    NSString* providerFN = [providerXML getTextValueByName:@"ProviderName"];
	NSString* providerLN = [providerXML getTextValueByName:@"ProviderLastName"];
    
	[self.providerDDL setTitle:[NSString stringWithFormat:@"%@, %@", providerLN, providerFN] forState:UIControlStateNormal];
}
- (void)viewDidUnload
{
	[self setDob:nil];
    
	[self setPatientDetailsView:nil];
	[self setPatientListSV:nil];

    [self setPatientListHeaders:nil];
    [self setProviderInfoView:nil];
    [self setSearchCriteriaView:nil];
    [self setSearchResultsView:nil];
    [self setFoundPatientsView:nil];
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

	[dob release];

	[patientListSV release];
    [patientListHeaders release];
    [providerInfoView release];
    [searchCriteriaView release];
    [searchResultsView release];
    [foundPatientsView release];
	[super dealloc];
}
- (IBAction)search:(id)sender {

    NSLog(@"1");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"Searching...";
    
    NSLog(@"1.5");
    [HUD showWhileExecuting:@selector(doSearch:) onTarget:self withObject:self animated:YES];
    
}

- (void) doSearch:(id)sender
{
    NSLog(@"1.75");
    
    int providerIdParam = [providerXML getIntValueByName:@"ProviderId"];
    NSString *patientFNParam = self.patientFirstName.text;
    NSString *patientLNParam = self.patientLastName.text;
    
    NSLog(@"2");
    
	ServiceObject* result = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"SearchPatientInfoByProviderId?providerId=%d&firstName=%@&lastName=%@", providerIdParam, patientFNParam, patientLNParam] categoryKey:@"" startTag:@"Table"];
	
    NSLog(@"3");
    
	if([result hasData])
	{
		NSString* tempPatientId = [result getTextValueByName:@"Table1/PatientId"];
		
		if(!tempPatientId)
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No patients found.\n\nCreate a new patient?" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			[alert show];
			[alert release];
		}
		else
		{
            
            _searchResults = result;
			
			[self showPatientList];
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
- (void) showPatientList
{
    ServiceObject *result = _searchResults;
    
	NSString* providerFN = [[providerXML getTextValueByName:@"ProviderName"] uppercaseString];
	NSString* providerLN = [[providerXML getTextValueByName:@"ProviderLastName"] uppercaseString];
	
	self.providerNameLbl.text = [NSString stringWithFormat:@"%@, %@", providerLN, providerFN];
	
	for (id v in self.patientListSV.subviews)
		[v removeFromSuperview];
	
	NSLog(@"---------------------------------");
	
	BOOL hasObjs = YES;
	
	float ny=0;
	float hx1 = ((UILabel*)[self.patientListHeaders objectAtIndex:0]).frame.origin.x;
	float hx2 = ((UILabel*)[self.patientListHeaders objectAtIndex:1]).frame.origin.x;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [result.dict objectForKey:key];
		
		if (obj)
		{
			int patientId = [result getIntValueByName:[NSString stringWithFormat:@"%@/PatientId", key]];
			
			NSString* patientLN = [result getTextValueByName:[NSString stringWithFormat:@"%@/LastName", key]];
			NSString* patientFN = [result getTextValueByName:[NSString stringWithFormat:@"%@/FirstName", key]];
			NSString* patientDOB = [[result getTextValueByName:[NSString stringWithFormat:@"%@/DOB", key]] substringToIndex:10];
			
			UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
			[b setTitle:@"Select" forState:UIControlStateNormal];
			b.titleLabel.textColor = [UIColor blackColor];
			b.titleLabel.font = [UIFont systemFontOfSize:10.0f];
			//[b sizeToFit];
			[self.patientListSV addSubview:b];
			b.frame = CGRectMake(0, ny, 60, 20);
			b.tag = patientId;
			NSLog(@"adding patient %d", patientId);
			[b addTarget:self action:@selector(patientBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			
            [self addPatientLabel:[NSString stringWithFormat:@"%@, %@", patientLN, patientFN] x:hx1 y:ny];
            
            [self addPatientLabel:patientDOB x:hx2 y:ny];
			
			ny += MAX(b.frame.size.height, 20);
		}
		else
			hasObjs = NO;
	}
	
	[self.patientListSV setContentSize:CGSizeMake(self.patientListSV.frame.size.width, ny)];
	
    [self applyChangesToSubviews:self.view];
    
    self.searchResultsView.hidden = NO;
	self.patientDetailsView.hidden = NO;
}

- (void)addPatientLabel:(NSString*)text x:(int)x y:(int)y
{
    UILabel *l = [[UILabel alloc] init];
    l.text = text;
    l.textColor = [UIColor whiteColor];
    l.backgroundColor = [UIColor clearColor];
    [l sizeToFit];
    l.frame = CGRectMake(x - self.patientListSV.frame.origin.x, y, l.frame.size.width, l.frame.size.height);			
    [self.patientListSV addSubview:l];
}

- (void)patientBtnClick:(id)sender
{
	UIButton *b = (UIButton*) sender;	
	int patientId = b.tag;
	
	[mobileSessionXML setObject:[NSString stringWithFormat:@"%d", patientId] forKey:@"patientId"];
	[mobileSessionXML updateMobileSessionData];
	
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
	
	[self loadPatientImages];
	
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
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PatientSearchDidCancel" object:self];
	[self dismissModalViewControllerAnimated:YES];
}

@end
