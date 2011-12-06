//
//  MainViewController.m
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "Loading.h"
#import "LoginView.h"
#import "HomePage.h"


@implementation MainViewController
@synthesize mainWindow;
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
    [super dealloc];
    
    [loading release];
    [login release];
    
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
    [self.view removeFromSuperview];
    loading=[[Loading alloc]init];
    loading.mainView=self;
    [mainWindow addSubview:loading.view];
    // Do any additional setup after loading the view from its nib.
}
-(void)showLogin
{
    login=[[LoginView alloc]init];
	CGRect fr = self.view.frame;
	[self.view removeFromSuperview];
    login.mainView=self;
    [mainWindow addSubview:login.view];
	login.view.frame = fr;
}
-(void)showHome
{
    [self.view removeFromSuperview];
	
    HomePage *home=[[HomePage alloc]init];
	home.title=@"Home";
	home.mainview = self;
	UINavigationController *navHomePage=[[UINavigationController alloc]initWithRootViewController:home];
	[navHomePage.navigationBar setBarStyle:UIBarStyleBlack];
	
	/* Measurements *
	measure=[[Measurements alloc]init];
	measure.title=@"Measurements";
	UINavigationController *navMeasurements=[[UINavigationController alloc]initWithRootViewController:measure];

	Lenses *lense=[[Lenses alloc]init];
	lense.title=@"Lenses";
	UINavigationController *navLenses=[[UINavigationController alloc]initWithRootViewController:lense];

	Adjust *adjust=[[Adjust alloc]init];
	adjust.title=@"Adjust";
	UINavigationController *navAdjust=[[UINavigationController alloc]initWithRootViewController:adjust];
		
	
	
	[tabcontrol setViewControllers:[NSArray arrayWithObjects:navHomePage,navMeasurements,navLenses,navAdjust, nil]];
	[mainWindow addSubview:tabcontrol.view];
*/
	[self.mainWindow addSubview:navHomePage.view];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	//return NO;
	NSLog(@"Rotating?");
	return YES;
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	NSLog(@"Will rotate?");
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}*/

@end
