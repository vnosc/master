//
//  PatientMedicalQuestionnaire.m
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionnairePrimaryInsurance.h"

extern ServiceObject *mobileSessionXML;
extern ServiceObject *providerXML;
extern int providerId;

@implementation QuestionnairePrimaryInsurance

@synthesize vspAddressView;
@synthesize vspAddressView2;
@synthesize primaryRelationshipDDL;
@synthesize primaryVisionInsuranceDDL;
@synthesize secondRelationshipDDL;
@synthesize secondVisionInsuranceDDL;
@synthesize primaryUnderstandBtn;
@synthesize secondUnderstandBtn;
@synthesize primarySignatureView;
@synthesize secondSignatureView;
@synthesize primaryDateField;
@synthesize secondDateFild;

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
    
    [self setBoxBackgroundLarge:self.vspAddressView];
    [self setBoxBackgroundLarge:self.vspAddressView2];
    
    [self setDropDownBackground:self.primaryRelationshipDDL];
    [self setDropDownBackground:self.secondRelationshipDDL];
    [self setDropDownBackground:self.primaryVisionInsuranceDDL];
    [self setDropDownBackground:self.secondVisionInsuranceDDL];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setVspAddressView:nil];
    [self setPrimarySignatureView:nil];
    [self setSecondSignatureView:nil];
    [self setVspAddressView2:nil];
    [self setPrimaryUnderstandBtn:nil];
    [self setSecondUnderstandBtn:nil];
    [self setPrimaryDateField:nil];
    [self setSecondDateFild:nil];
    [self setPrimaryRelationshipDDL:nil];
    [self setPrimaryVisionInsuranceDDL:nil];
    [self setSecondRelationshipDDL:nil];
    [self setSecondVisionInsuranceDDL:nil];
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
    [primarySignatureView release];
    [secondSignatureView release];
    [vspAddressView2 release];
    [primaryUnderstandBtn release];
    [secondUnderstandBtn release];
    [primaryDateField release];
    [secondDateFild release];
    [primaryRelationshipDDL release];
    [primaryVisionInsuranceDDL release];
    [secondRelationshipDDL release];
    [secondVisionInsuranceDDL release];
    [super dealloc];
}

- (IBAction)primaryEraseBtnClick:(id)sender {
    [self.primarySignatureView erase];
}

- (IBAction)secondEraseBtnClick:(id)sender {
    [self.secondSignatureView erase];
}

- (IBAction)understandBtnClick:(id)sender {
    UIButton *btn = (UIButton*) sender;
    [btn setSelected:![btn isSelected]];
}

- (IBAction)continueBtnClick:(id)sender {
    
    if (primaryUnderstandBtn.selected)
    {
        QuestionnaireMedicalHistory *p = [[QuestionnaireMedicalHistory alloc] init];
        p.title = @"Patient Questionnaire";
        [self.navigationController pushViewController:p animated:YES];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please review the document and indicate your consent by checking the buttons above." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
    }
    
}

@end
