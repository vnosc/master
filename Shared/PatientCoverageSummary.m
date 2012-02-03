//
//  PatientMedicalQuestionnaire.m
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PatientCoverageSummary.h"

extern ServiceObject *mobileSessionXML;
extern ServiceObject *patientXML;
extern int providerId;

@implementation PatientCoverageSummary

@synthesize vspAddressView;
@synthesize planScroll;
@synthesize planView1;
@synthesize planView2;
@synthesize planView3;
@synthesize planView4;
@synthesize patientNameLabel;
@synthesize serviceBtns1;
@synthesize serviceBtns2;
@synthesize serviceBtns3;
@synthesize serviceBtns4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _didAuthorize = NO;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getLatestPatientFromService];
    
    /*NSString *pfn = [providerXML getTextValueByName:@"FirstName"];
    NSString *pln = [providerXML getTextValueByName:@"LastName"];
    NSString *pn = [NSString stringWithFormat:"%@ %@", pfn, pln];
    [self.providerNameField setText:pn];*/
    
    [self setBoxBackgroundLarge:self.vspAddressView];
    [self setBoxBackground:self.planView1];
    [self setBoxBackground:self.planView2];
    [self setBoxBackground:self.planView3];
    [self setBoxBackground:self.planView4];
    
    NSString *pfn = [patientXML getTextValueByName:@"FirstName"];
    NSString *pln = [patientXML getTextValueByName:@"LastName"];
    NSString *patientName = [[NSString stringWithFormat:@"%@, %@", pln, pfn] uppercaseString];
    [self.patientNameLabel setText:patientName];
    
    self.planScroll.contentSize = CGSizeMake(self.planScroll.frame.size.width, self.planView1.frame.size.height * 4 + 50);
    
    // Do any additional setup after loading the view from its nib.
}

- (void) getLatestPatientFromService
{
	
	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	patientXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientIdv]];
	
}

- (void)viewDidUnload
{
    [self setVspAddressView:nil];
    [self setPlanView1:nil];
    [self setPatientNameLabel:nil];
    [self setPlanView2:nil];
    [self setPlanView3:nil];
    [self setPlanView4:nil];
    [self setPlanScroll:nil];
    [self setServiceBtns1:nil];
    [self setServiceBtns2:nil];
    [self setServiceBtns3:nil];
    [self setServiceBtns4:nil];
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
    [vspAddressView release];
    [planView1 release];
    [patientNameLabel release];
    [planView2 release];
    [planView3 release];
    [planView4 release];
    [planScroll release];
    [serviceBtns1 release];
    [serviceBtns2 release];
    [serviceBtns3 release];
    [serviceBtns4 release];
    [super dealloc];
}

- (IBAction)continueBtnClick:(id)sender {

}

- (IBAction)authorizeDummy:(id)sender {

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Authorization Successful" message:@"An authorization was\nsuccessfully issued.\n\nYour authorization number is \n78364379."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];    
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _didAuthorize = YES;
    [self goBack];
}
- (IBAction)notAuthorizeDummy:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"The current benefit is not available for this plan."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (IBAction)back:(id)sender {
    _didAuthorize = NO;
    [self goBack];
}

 - (void)goBack
{
    NSString *notificationName;
    if (_didAuthorize)
        notificationName = @"PatientCoverageSummaryDidFinish";
    else
        notificationName = @"PatientCoverageSummaryDidCancel";
    
    NSLog(notificationName);
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectServiceBtnClick:(id)sender {
    UIButton *btn = (UIButton*) sender;
    [btn setSelected:![btn isSelected]];
}

- (IBAction)selectAllServiceBtnClick:(id)sender {
    
    UIButton *allBtn = (UIButton*) sender;
    [allBtn setSelected:![allBtn isSelected]];
    
    for (UIButton *btn in self.serviceBtns1)
    {
        [btn setSelected:[allBtn isSelected]];
    }
}

- (IBAction)selectAllServiceBtnClick2:(id)sender {
    UIButton *allBtn = (UIButton*) sender;
    [allBtn setSelected:![allBtn isSelected]];
    
    for (UIButton *btn in self.serviceBtns2)
    {
        [btn setSelected:[allBtn isSelected]];
    }
}

- (IBAction)selectAllServiceBtnClick3:(id)sender {
    UIButton *allBtn = (UIButton*) sender;
    [allBtn setSelected:![allBtn isSelected]];
    
    for (UIButton *btn in self.serviceBtns3)
    {
        [btn setSelected:[allBtn isSelected]];
    }
}

- (IBAction)selectAllServiceBtnClick4:(id)sender {
    UIButton *allBtn = (UIButton*) sender;
    [allBtn setSelected:![allBtn isSelected]];
    
    for (UIButton *btn in self.serviceBtns4)
    {
        [btn setSelected:[allBtn isSelected]];
    }
}
@end
