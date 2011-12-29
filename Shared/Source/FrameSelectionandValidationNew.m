//
//  FrameSelectionandValidationNew.m
//  CyberImaging
//
//  Created by Troy Potts on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FrameSelectionandValidationNew.h"
#import <QuartzCore/QuartzCore.h>
#import "PatientSearch.h"
#import "PatientRecord.h"
#import "PatientPrescription.h"
#import "ServiceObject.h"

extern int providerId;
extern ServiceObject* mobileSessionXML;

@implementation FrameSelectionandValidationNew
@synthesize webView;
@synthesize webView2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Frame Selection" style:UIBarButtonItemStyleBordered target:nil action:nil];
    }
    return self;
}

- (void)dealloc
{
	[webView release];
	[webView2 release];
    [super dealloc];
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
	
	self.webView.hidden = YES;
	
	for (id subview in self.webView.subviews)
		if ([[subview class] isSubclassOfClass:[UIScrollView class]])
			((UIScrollView *)subview).bounces = NO;
	
	[self.tabBarController.tabBar removeFromSuperview];
	
	[[self tabBarItem] setTitle:@"Frame Selection"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishContinue:) name:@"PatientRecordDidFinish" object:nil];
				 
    [self loadPageMobile:@"http://smart-i.mobi/Mobile_SelectFrame.aspx" wv:self.webView];
}

-(IBAction) selectandcontinueBtnClick : (id) sender
{
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];

	NSString* returnedFrame = [self.webView stringByEvaluatingJavaScriptFromString:@"getFrameForService();"];
	
	if ([returnedFrame length] > 0)
	{
		NSLog(@"Updating selected FrameId to %@", returnedFrame);
		[mobileSessionXML setObject:returnedFrame forKey:@"frameId"];
		
		[mobileSessionXML updateMobileSessionData];
	}
	else
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please select a frame." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	if (currentPatientId == 0)
	{
		PatientRecord *patient=[[PatientRecord alloc]init];
		patient.title=@"Patient Record";
		//[self.navigationController pushViewController:patient animated:YES];
		[self presentModalViewController:patient animated:YES];
	}
	else
		[self finishContinue:self];
}
	 
- (void)finishContinue:(id)sender
{
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	if (currentPatientId != 0)
	{
		PatientPrescription *patient=[[PatientPrescription alloc]init];
		patient.title=@"Prescription Information";
		patient.continueToSelection = YES;
		[self.navigationController pushViewController:patient animated:YES];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[HUD hide:YES];
}
- (void)viewDidUnload
{
	[self setWebView:nil];
	[self setWebView2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)loadPage:(NSString *)pageName wv:(UIWebView *)wv
{
	NSLog(@"Loading page %@", pageName);
	NSURL* url = [NSURL URLWithString:pageName];
	NSURLRequest* requestObj = [NSURLRequest requestWithURL:url];
	[wv loadRequest:requestObj];
}

- (void)loadPageMobile:(NSString *)pageName wv:(UIWebView *)wv
{
	NSString* mobileSessionId = [mobileSessionXML getTextValueByName:@"sessionId"];
	NSString *fullPageName = [NSString stringWithFormat:@"%@?userId=%d&msid=%@", pageName, providerId, mobileSessionId];
	
	NSLog(@"Adding parameters to pagename for mobile");
	[self loadPage:fullPageName wv:wv];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"Loading";
	HUD.userInteractionEnabled = NO;
	
	[HUD show:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"%@", error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewArg
{
	[HUD hide:YES];
	webViewArg.hidden = NO;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

@end
