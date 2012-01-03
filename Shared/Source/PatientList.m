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
@synthesize sectionBar;
@synthesize linkBar;
@synthesize webView;
@synthesize webView2;
@synthesize suppressPush;
@synthesize firstURL;
@synthesize webLoads;

@synthesize selectedSectionIdx;
@synthesize selectedLinkIdxes;

@synthesize sectionLabels;
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
	[sectionBar release];
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
	
	self.selectedSectionIdx = 0;
	self.selectedLinkIdxes = [[NSMutableArray alloc] init];
	
	self.fakeNavBar.delegate = self;
	
	NSMutableArray *btns;
	int cnt;
	
	btns = [[NSMutableArray alloc] init];
    cnt=0;
	
	for (id cLabel in self.sectionLabels)
	{
		[self.selectedLinkIdxes addObject:[NSNumber numberWithInt:0]];
		
		/*UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btn addTarget:self action:@selector(sectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[btn setTitle:cLabel forState:UIControlStateNormal];
		btn.tag = cnt;
		[btn sizeToFit];
		
		[[UIBarButtonItem alloc] initWithCustomView:btn];
		
		UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
		// UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:cLabel style:UIBarButtonItemStyleBordered target:self action:@selector(sectionBtnClicked:)];
		//btnItem.tag = cnt;
		[btns addObject:btnItem];
		cnt++;*/
	}

	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:self.sectionLabels];
	[segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[segment addTarget:self action:@selector(sectionBtnClicked:) forControlEvents:UIControlEventValueChanged];
	[segment setSelectedSegmentIndex:0];
	
	UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:segment];
	[self.sectionBar setItems:[NSArray arrayWithObjects:btnItem, nil]];
	
	//[self.sectionBar setItems:[NSArray arrayWithArray:btns]];
	
	[self setUpLinks];
	
	self.webView.hidden = YES;
	
	for (id subview in self.webView.subviews)
		if ([[subview class] isSubclassOfClass:[UIScrollView class]])
			((UIScrollView *)subview).bounces = NO;
	
	//[self.tabBarController.tabBar removeFromSuperview];
	
	//[[self tabBarItem] setTitle:@"Frame Selection"];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishContinue:) name:@"PatientSearchDidFinish" object:nil];
				 
	self.webView.scalesPageToFit = YES;

	
	NSString *finalURL = [NSString stringWithFormat:@"http://smart-i.mobi/%@", self.firstURL];
    //[self loadPageMobile:@"http://smart-i.mobi/Mobile_ListPatients.aspx" wv:self.webView];
	[self loadPageMobile:finalURL wv:self.webView];
}

- (void) setUpLinks
{
	/*NSMutableArray *btns = [[NSMutableArray alloc] init];
	int cnt=0;
	for (id cLabel in [self.btnLabels objectAtIndex:self.selectedSectionIdx])
	{
		UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:cLabel style:UIBarButtonItemStyleBordered target:self action:@selector(linkBtnClicked:)];
		btnItem.tag = cnt;
		[btns addObject:btnItem];
		cnt++;
	}
	
	[self.linkBar setItems:[NSArray arrayWithArray:btns]];*/
	
	UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[self.btnLabels objectAtIndex:self.selectedSectionIdx]];
	[segment setSegmentedControlStyle:UISegmentedControlStyleBar];
	[segment addTarget:self action:@selector(linkBtnClicked:) forControlEvents:UIControlEventValueChanged];
	[segment setSelectedSegmentIndex:[self selectedLinkIdxForSection:self.selectedSectionIdx]];
	
	UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:segment];
	[self.linkBar setItems:[NSArray arrayWithObjects:btnItem, nil]];

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
	[self setSectionBar:nil];
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
	[self.view setUserInteractionEnabled:NO];
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
		
		[self finishPageTransition];
	}
}

- (void) finishPageTransition
{
	[self.view setUserInteractionEnabled:YES];
	
	if (changedSection)
	{
		[self setUpLinks];
		changedSection = NO;
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
	UISegmentedControl *segment = (UISegmentedControl*)sender;
	
	if (segment)
	{
		int idx = [segment selectedSegmentIndex];
		
		[self.selectedLinkIdxes replaceObjectAtIndex:self.selectedSectionIdx withObject:[NSNumber numberWithInt:idx]];
		
		NSString *btnURL = [[self.btnURLs objectAtIndex:self.selectedSectionIdx] objectAtIndex:idx];
		
		if (![btnURL isEqualToString:@""])
		{
			NSString *finalURL = [NSString stringWithFormat:@"http://smart-i.mobi/%@", btnURL];
			[self loadPageMobile:finalURL wv:self.webView];
		}
		else
		{
			[self finishPageTransition];
		}
	}
}

- (void) sectionBtnClicked:(id)sender
{
	UISegmentedControl *segment = (UISegmentedControl*)sender;
	
	if (segment)
	{
		int idx = [segment selectedSegmentIndex];
		
		self.selectedSectionIdx = idx;
		changedSection = YES;
		
		NSString *btnURL = [[self.btnURLs objectAtIndex:idx] objectAtIndex:[self selectedLinkIdxForSection:idx]];
		
		if (![btnURL isEqualToString:@""])
		{
			NSString *finalURL = [NSString stringWithFormat:@"http://smart-i.mobi/%@", btnURL];
			[self loadPageMobile:finalURL wv:self.webView];
		}
		else
		{
			[self finishPageTransition];
		}
	}
	
}

- (int) selectedLinkIdxForSection:(int)sectionIdx
{
	return [[self.selectedLinkIdxes objectAtIndex:sectionIdx] intValue];
}

@end
