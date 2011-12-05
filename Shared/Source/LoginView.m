//
//  LoginView.m
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"
#import "TBXML.h"
#import "ServiceObject.h"

int a=0;

extern int providerId;
extern ServiceObject* patientXML;
extern ServiceObject* mobileSessionXML;

@implementation LoginView
@synthesize username,password;
@synthesize npi;
@synthesize mainView;
@synthesize usernameImage;
@synthesize passwordImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{

    [npi release];
	[usernameImage release];
	[passwordImage release];
    [super dealloc];
    [username release];
    [password release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSString*) buttonImageName { return @"LoginButton.png"; }
- (NSString*) buttonHighlightedImageName { return @"LoginButtonTouch.png"; }
- (int) buttonImageLeftCap { return 25; }
- (int) buttonImageTopCap { return 9; }

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [btnRemember setSelected:YES];
    
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBackground.png"]];
	
	UIImage *loginBG = [UIImage imageNamed:@"LoginButton.png"];
	UIImage *loginBGS = [loginBG stretchableImageWithLeftCapWidth:25 topCapHeight:20];
	self.usernameImage.image = loginBGS;
	self.passwordImage.image = loginBGS;
	
    username.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"one"];
    password.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"two"];
	
	if (self.npi != nil)
		self.npi.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"npi"];		
	
   // a=1;
    // Do any additional setup after loading the view from its nib.
}
-(IBAction) rememberButtonClick : (id)sender
{
    if(a==0)
    {
        [btnRemember setSelected:YES];
        a=1;
    }
    else
    {
        [btnRemember setSelected:NO];
        a=0;
    }
}
-(IBAction) loginButtonClick :(id)sender{
    
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	
	HUD.labelText = @"Logging in...";
	
	[HUD showWhileExecuting:@selector(login) onTarget:self withObject:self animated:YES];
}

- (void)login
{
   if([username.text length]==0 || [password.text length]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter your username and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
		NSString *npitxt = @"shishir";
		if (self.npi != nil)
			npitxt = self.npi.text;
		
#ifdef SMARTI
        NSString *url=[[NSString alloc]initWithFormat:@"http://smart-i.ws/mobilewebserviceadv.asmx/ValidateProvider?provideremail=%@&password=%@&npi=%@",username.text,password.text,npitxt];
#else
		NSString *url=[[NSString alloc]initWithFormat:@"http://smart-i.ws/mobilewebservice.asmx/ValidateProvider?provideremail=%@&password=%@&npi=%@",username.text,password.text,npitxt];
#endif
        
		// look into dispatch for loading request in background
		//HUD = [[MBProgressHUD alloc] initWithView:self.view];
		//[self.view addSubview:HUD];
		
		//HUD.delegate = self;
		//HUD.labelText = @"Logging in...";
		//HUD.areAnimationsEnabled = NO;
		//[HUD show:YES];
		TBXML *tbxml=[TBXML tbxmlWithURL:[NSURL URLWithString:url]];
		//[HUD hide:YES];
		
        TBXMLElement *root = tbxml.rootXMLElement;
		NSLog(@"?!");
        if(root)
        {
            TBXMLElement *idEle = [TBXML childElementNamed:@"providerid" parentElement:root];
            if([[TBXML textForElement:idEle]intValue]==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Incorrect username or password." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
            }
            else
            {
				TBXMLElement *msEle = [TBXML childElementNamed:@"mobilesessionid" parentElement:root];
				
				providerId = [[TBXML textForElement:idEle]intValue];
				
				NSString* mobileSessionId = [TBXML textForElement:msEle];
				
#ifdef SMARTI
				NSString *urlms=[[NSString alloc]initWithFormat:@"http://smart-i.ws/mobilewebserviceadv.asmx/GetMobileSessionInfo?sessionId=%@", mobileSessionId];
#else
				NSString *urlms=[[NSString alloc]initWithFormat:@"http://smart-i.ws/mobilewebservice.asmx/GetMobileSessionInfo?sessionId=%@", mobileSessionId];
#endif

				NSLog(@"%@", urlms);
				
				TBXML *tbxmlms=[TBXML tbxmlWithURL:[NSURL URLWithString:urlms]];
				
				mobileSessionXML = [[ServiceObject alloc] initWithTBXML:tbxmlms];
				
				NSLog(@"%@", mobileSessionId);
				
                if(a==1)
                {
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [defaults setObject:username.text forKey:@"one"];
                    [defaults synchronize];
                    NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
                    [defaults1 setObject:password.text forKey:@"two"];
                    [defaults1 synchronize];
					
					if (self.npi != nil)
					{
						NSUserDefaults *defaults2=[NSUserDefaults standardUserDefaults];
						[defaults2 setObject:self.npi.text forKey:@"npi"];
						[defaults2 synchronize];						
					}
                }

                [mainView showHome];
            }
        }
		else
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid response from server" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
		}
    }

   //[mainView showHome]; 
    
}

- (void)viewDidUnload
{
    [self setNpi:nil];
	[self setUsernameImage:nil];
	[self setPasswordImage:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

@end
