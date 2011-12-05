//
//  FrameSelectionandValidationNew.m
//  CyberImaging
//
//  Created by Troy Potts on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PatientList.h"
#import <QuartzCore/QuartzCore.h>
#import "PatientSearch.h"
#import "PatientPrescription.h"
#import "ServiceObject.h"

extern int providerId;
extern ServiceObject* mobileSessionXML;

@implementation PatientList
@synthesize fakeNavBar;
@synthesize linkBar;
@synthesize webView;
@synthesize webView2;
@synthesize suppressPush;
@synthesize firstURL;
@synthesize webLoads;

@synthesize btnLabels;
@synthesize btnURLs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		//self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Frame Selection" style:UIBarButtonItemStyleBordered target:nil action:nil];
		
		self.suppressPush = NO;
		
    }
    return self;
}

- (void)dealloc
{
	[webView release];
	[webView2 release];
	[fakeNavBar release];
	[linkBar release];
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
	
	self.fakeNavBar.delegate = self;
	
	NSMutableArray *btns = [[NSMutableArray alloc] init];
	
	int cnt=0;
	for (id cLabel in self.btnLabels)
	{
		UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:cLabel style:UIBarButtonItemStyleBordered target:self action:@selector(linkBtnClicked:)];
		btnItem.tag = cnt;
		[btns addObject:btnItem];
		cnt++;
	}
	
	[self.linkBar setItems:[NSArray arrayWithArray:btns]];
	
	self.webView.hidden = YES;
	
	for (id subview in self.webView.subviews)
		if ([[subview class] isSubclassOfClass:[UIScrollView class]])
			((UIScrollView *)subview).bounces = NO;
	
	//[self.tabBarController.tabBar removeFromSuperview];
	
	//[[self tabBarItem] setTitle:@"Frame Selection"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishContinue:) name:@"PatientSearchDidFinish" object:nil];
				 
	self.webView.scalesPageToFit = YES;

	
	NSString *finalURL = [NSString stringWithFormat:@"http://dev.smarteyewear.net/%@", self.firstURL];
    //[self loadPageMobile:@"http://smart-i.mobi/Mobile_ListPatients.aspx" wv:self.webView];
	[self loadPageMobile:finalURL wv:self.webView];
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
		PatientSearch *patient=[[PatientSearch alloc]init];
		patient.title=@"Patient Selection";
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
	[self setFakeNavBar:nil];
	[self setLinkBar:nil];
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
	NSLog(@"Loading?");
	
	if (self.webLoads == 0)
	{
		if (HUD == nil || HUD.isHidden)
		{
			HUD = [[MBProgressHUD alloc] initWithView:self.view];
			[self.view addSubview:HUD];
			
			HUD.delegate = self;
			HUD.labelText = @"Loading";
			HUD.userInteractionEnabled = NO;
			
			[HUD show:YES];
		}
	}
	
	self.webLoads++;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"%@", error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewArg
{
	
	self.webLoads--;
	
	if (self.webLoads == 0)
	{
	[HUD hide:YES];
	webViewArg.hidden = NO;
	
	NSLog(@"Webview finished loading.");
	
	NSString* pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	NSLog(@"%@", pageTitle);
	NSLog(@"%d", [self.fakeNavBar.items count]);
	
	if (!self.suppressPush)
		[self.fakeNavBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:self.title] animated:YES];
	
	self.suppressPush = NO;
	
		NSLog(@"%@", self.webView.request.URL.absoluteString);
	}
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (void) navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
	NSLog(@"wut");
	self.suppressPush = YES;
	[self.webView goBack];
}

- (void) linkBtnClicked:(id)sender
{
	int idx = [sender tag];
	if (![[self.btnURLs objectAtIndex:idx] isEqualToString:@""])
	{
	NSString *finalURL = [NSString stringWithFormat:@"http://dev.smarteyewear.net/%@", [self.btnURLs objectAtIndex:idx]];
	[self loadPageMobile:finalURL wv:self.webView];
	}
}
@end
