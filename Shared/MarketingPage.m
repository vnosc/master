//
//  MarketingPage.m
//  Smart-i
//
//  Created by Troy Potts on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MarketingPage.h"

@implementation MarketingPage

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	//[self.navigationController.navigationItem.leftBarButtonItem setTarget:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)videoOptiClick:(id)sender {
    UnityOpticsVideoView *v=[[UnityOpticsVideoView alloc]init];
    v.title=@"Project OptiSuite";
    v.videoFilename = @"OptiSuite_Video_1.30.12.mp4";
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)videoUnityClick:(id)sender {
    UnityOpticsVideoView *v=[[UnityOpticsVideoView alloc]init];
    v.title=@"Unity Performance Optics";
    v.videoFilename = @"unityVideo.mp4";
    [self.navigationController pushViewController:v animated:YES];
}
@end
