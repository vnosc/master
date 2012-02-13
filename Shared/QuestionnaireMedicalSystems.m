//
//  PatientMedicalQuestionnaire.m
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionnaireMedicalSystems.h"

extern ServiceObject *mobileSessionXML;
extern ServiceObject *providerXML;
extern int providerId;

@implementation QuestionnaireMedicalSystems
{
    UIButton *_curBtn;
}

@synthesize vspAddressView;
@synthesize initialSigView;
@synthesize noBtns;
@synthesize yesBtns;
@synthesize yesNoPanels;
@synthesize relationDDLs;
@synthesize systemsSV;
@synthesize systemsContainerView;

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
    
    [self.systemsSV setContentSize:self.systemsSV.bounds.size];
    [self.systemsSV setClipsToBounds:YES];
    
    [self.vspAddressView addSubview:self.systemsSV];
    [self.systemsSV setFrame:self.systemsContainerView.frame];
    
    for (UIButton *btn in self.yesBtns)
        [btn addTarget:self action:@selector(yesNoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    for (UIButton *btn in self.noBtns)
        [btn addTarget:self action:@selector(yesNoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /*NSString *pfn = [providerXML getTextValueByName:@"FirstName"];
    NSString *pln = [providerXML getTextValueByName:@"LastName"];
    NSString *pn = [NSString stringWithFormat:"%@ %@", pfn, pln];
    [self.providerNameField setText:pn];*/
    
    [self setBoxBackgroundLarge:self.vspAddressView];
    
    for (UIButton *ddl in self.relationDDLs)
        [self setDropDownBackground:ddl];
    
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
    [self setNoBtns:nil];
    [self setYesBtns:nil];
    [self setYesNoPanels:nil];
    [self setInitialSigView:nil];
    [self setRelationDDLs:nil];
    [self setSystemsSV:nil];
    [self setSystemsContainerView:nil];
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
    [noBtns release];
    [yesBtns release];
    [yesNoPanels release];
    [initialSigView release];
    [relationDDLs release];
    [systemsSV release];
    [systemsContainerView release];
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

    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionnairePageDidFinish" object:self];
    
}

- (IBAction)relationDDLClick:(id)sender {
    [self showDropDownFromButton:(UIButton*)sender title:@"Relationship to Patient" options:    
     @"Not specified", 
     @"Self", 
     @"Father", 
     @"Mother", 
     @"Grandfather",
     @"Grandmother",        
     @"Brother", 
     @"Sister", 
     @"Son",
     @"Daughter",     
     nil];
}

- (IBAction)sigEraseBtnClick:(id)sender {
    [self.initialSigView erase];
}

@end
