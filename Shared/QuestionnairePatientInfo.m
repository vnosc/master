//
//  PatientMedicalQuestionnaire.m
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionnairePatientInfo.h"

extern ServiceObject *mobileSessionXML;
extern ServiceObject *providerXML;
extern int providerId;

@implementation QuestionnairePatientInfo
{
    UIButton *_curBtn;
}
@synthesize vspAddressView;
@synthesize phoneDDL;
@synthesize altPhoneDDL;
@synthesize hearAboutDDL;
@synthesize patientNameField;
@synthesize patientPhoneField;
@synthesize providerNameField;
@synthesize patientName;
@synthesize patientPhone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _curBtn = [UIButton alloc];
        
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.patientNameField setText:self.patientName];
    [self.patientPhoneField setText:self.patientPhone];
    
    NSString* providerFN = [providerXML getTextValueByName:@"ProviderName"];
	NSString* providerLN = [providerXML getTextValueByName:@"ProviderLastName"];
    
	[self.providerNameField setText:[NSString stringWithFormat:@"%@ %@", providerFN, providerLN]];
    
    /*NSString *pfn = [providerXML getTextValueByName:@"FirstName"];
     NSString *pln = [providerXML getTextValueByName:@"LastName"];
     NSString *pn = [NSString stringWithFormat:"%@ %@", pfn, pln];
     [self.providerNameField setText:pn];*/
    
    [self setBoxBackgroundLarge:self.vspAddressView];
    
    [self setDropDownBackground:self.phoneDDL];
    [self setDropDownBackground:self.altPhoneDDL];
    [self setDropDownBackground:self.hearAboutDDL];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setVspAddressView:nil];
    [self setPhoneDDL:nil];
    [self setAltPhoneDDL:nil];
    [self setHearAboutDDL:nil];
    [self setPatientNameField:nil];
    [self setPatientPhoneField:nil];
    [self setProviderNameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) showDropDownFromButton:(UIButton*)btn title:(NSString*)title options:(NSString*)firstArg, ...
{
    _curBtn = btn;
    
    va_list args;
    va_start(args, firstArg);
    
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *arg = firstArg; arg != nil; arg = va_arg(args, NSString*))
    {
        [as addButtonWithTitle:arg];
    }
    va_end(args);
    
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0)
    {
        NSString* pv = [actionSheet buttonTitleAtIndex:buttonIndex];
        [_curBtn setTitle:pv forState:UIControlStateNormal];
    }
    _curBtn = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [vspAddressView release];
    [phoneDDL release];
    [altPhoneDDL release];
    [hearAboutDDL release];
    [patientNameField release];
    [patientPhoneField release];
    [providerNameField release];
    [super dealloc];
}

- (IBAction)continueBtnClick:(id)sender {
    
    QuestionnairePrimaryInsurance *p = [[QuestionnairePrimaryInsurance alloc] init];
    p.title = @"Patient Questionnaire";
    [self.navigationController pushViewController:p animated:YES];
    
}

- (IBAction)phoneDDLClick:(id)sender {
    [self showDropDownFromButton:(UIButton*)sender title:@"Phone Type" options:
     @"Work", 
     @"Cell", 
     @"Pager", nil];
}

- (IBAction)hearAboutDDLClick:(id)sender {
    [self showDropDownFromButton:(UIButton*)sender title:@"How did you hear about us?" options:
     @"Friend/Family", 
     @"Radio/TV", 
     @"Insurance Carrier", 
     @"Internet search engines",
     @"Print ad (phone book, etc.)",
     @"Other", nil];
}

@end