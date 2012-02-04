//
//  UnityOpticsVideoView.m
//  CyberImaging
//
//  Created by Troy Potts on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UnityOpticsVideoView.h"

@implementation UnityOpticsVideoView

@synthesize videoFilename;

- (NSString*) backgroundImageName { return @""; }

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
    // Do any additional setup after loading the view from its nib.
	
    videoPlayer = [self createVideoPlayer:self.videoFilename];
	videoPlayer.view.frame = CGRectMake(0, 0, 768, 768);
	[videoPlayer play];
	
	[self.navigationController.navigationItem.backBarButtonItem setAction:@selector(removeVideo)];
	//[self.navigationController.navigationItem.leftBarButtonItem setTarget:self];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(videoFinished:)
	 name:@"MPMoviePlayerPlaybackDidFinishNotification"
	 object:videoPlayer];
}

- (MPMoviePlayerController*)createVideoPlayer:(NSString*)videoFileName
{
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:videoFileName ofType:nil];
	NSURL *url = [NSURL fileURLWithPath:urlStr];
    MPMoviePlayerController *vp = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[self.view addSubview:vp.view];
    vp.controlStyle = MPMovieControlStyleNone;
    return vp;
}

- (void)removeVideo
{
	[videoPlayer stop];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[self removeVideo];
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

- (void)videoFinished:(NSNotification*)n
{
	//[self removeVideo];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backToMainMenu:(id)sender {
	//[self removeVideo];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
