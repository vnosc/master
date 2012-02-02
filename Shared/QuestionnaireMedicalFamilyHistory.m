//
//  PatientMedicalQuestionnaire.m
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionnaireMedicalFamilyHistory.h"

extern ServiceObject *mobileSessionXML;
extern ServiceObject *providerXML;
extern int providerId;

@implementation QuestionnaireMedicalFamilyHistory

@synthesize vspAddressView;
@synthesize phoneDDL;
@synthesize altPhoneDDL;
@synthesize contactLensTypeDDL;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*NSString *pfn = [providerXML getTextValueByName:@"FirstName"];
    NSString *pln = [providerXML getTextValueByName:@"LastName"];
    NSString *pn = [NSString stringWithFormat:"%@ %@", pfn, pln];
    [self.providerNameField setText:pn];*/
    
    [self setBoxBackground:self.vspAddressView];
    
    [self setDropDownBackground:self.phoneDDL];
    [self setDropDownBackground:self.altPhoneDDL];
    [self setDropDownBackground:self.contactLensTypeDDL];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setVspAddressView:nil];
    [self setPhoneDDL:nil];
    [self setAltPhoneDDL:nil];
    [self setContactLensTypeDDL:nil];
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
    [phoneDDL release];
    [altPhoneDDL release];
    [contactLensTypeDDL release];
    [super dealloc];
}

- (IBAction)continueBtnClick:(id)sender {

}

@end
