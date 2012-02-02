//
//  FSHomePage.m
//  Smart-i
//
//  Created by Logistic on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSHomePage.h"
//#import "RXCustomTabBar1.h"
@implementation FSHomePage

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    activityIndicator = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview: activityIndicator];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [activityIndicator startAnimating];   
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)selectViewForTab:(id)sender
{
   // [activityIndicator startAnimating];   
    UIButton *btn=(UIButton *)sender;
    
    [self.tabBarController selectTab:btn.tag];
   // self.tabBarController.selectedIndex=btn.tag;
    
}

@end
