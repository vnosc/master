//
//  PatientMedicalQuestionnaire.m
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionnaireMedicalHistory.h"

extern ServiceObject *mobileSessionXML;
extern ServiceObject *providerXML;
extern int providerId;

@implementation QuestionnaireMedicalHistory
{
    UIButton *_curBtn;
}

@synthesize vspAddressView;
@synthesize phoneDDL;
@synthesize altPhoneDDL;
@synthesize contactLensTypeDDL;
@synthesize noBtns;
@synthesize yesBtns;
@synthesize yesNoPanels;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _curBtn = [UIButton alloc];
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
    
    [self setDropDownBackground:self.phoneDDL];
    [self setDropDownBackground:self.altPhoneDDL];
    [self setDropDownBackground:self.contactLensTypeDDL];
    
    int cnt=0;
    for (id obj in self.yesNoPanels)
    {
        [self setPanel:cnt enabled:NO];
        cnt++;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setVspAddressView:nil];
    [self setPhoneDDL:nil];
    [self setAltPhoneDDL:nil];
    [self setContactLensTypeDDL:nil];
    [self setNoBtns:nil];
    [self setYesBtns:nil];
    [self setYesNoPanels:nil];
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
    [noBtns release];
    [yesBtns release];
    [yesNoPanels release];
    [super dealloc];
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

- (IBAction)yesNoBtnClick:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    BOOL isYesBtn = [self.yesBtns containsObject:btn];
    
    int idx = 0;
    if (isYesBtn)
        idx = [self.yesBtns indexOfObject:btn];
    else
        idx = [self.noBtns indexOfObject:btn];
 
    [[self.yesBtns objectAtIndex:idx] setSelected:isYesBtn];
    [[self.noBtns objectAtIndex:idx] setSelected:!isYesBtn];
    
    if (btn.tag > 0)
    {
        [self setPanel:btn.tag-1 enabled:isYesBtn];
    }
}

- (void) setPanel:(int)idx enabled:(BOOL)enabled
{
    UIView *pnl = [self.yesNoPanels objectAtIndex:idx];
    [pnl setUserInteractionEnabled:enabled];
    [pnl setAlpha:enabled ? 1.0 : 0.1];
}

- (IBAction)continueBtnClick:(id)sender {

}

- (IBAction)contactLensTypeDDLClick:(id)sender {
    [self showDropDownFromButton:(UIButton*)sender title:@"Type of Contact" options:
     @"Soft", 
     @"Gas Perm.", 
     @"Extended Wear", nil];
}

@end
