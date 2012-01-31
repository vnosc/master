//
//  CapturePicture.m
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CapturePicture.h"

@implementation CapturePicture
@synthesize vImagePreview;
@synthesize stillImageOutput;
@synthesize navigationTitleLabel;
@synthesize captureVideoPreviewLayer;

@synthesize iv;
@synthesize measureType;
@synthesize instMessages;

@synthesize usingFrontCamera;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.instMessages = [[NSArray alloc] initWithObjects:@"Please take a picture of the patient staring directly at the camera.", @"Please take a picture of the patient looking down.", @"Please take a picture of the patient from the side.", @"Please take a picture of the patient without his or her glasses on.", nil];
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
    
    //[self setImagePreviewMask];
	
    // Do any additional setup after loading the view from its nib.
//}

//-(void) viewDidAppear:(BOOL)animated
//{
	// vline=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aadi.png"]];
	//  vline.frame=CGRectMake(144,187,0,374);
	//  hline=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lineeee.png"]];
    
	[self createCamera];
	
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationTitleLabel.text = self.navigationItem.title;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    //[[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void) setImagePreviewMask
{
	CALayer *layer = self.vImagePreview.layer;
	
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
}

- (NSString*) getRectString:(CGRect)r
{
    return [NSString stringWithFormat:@"%f,%f,%f,%f", r.origin.x, r.origin.y, r.size.width, r.size.height];
}

- (void) createCamera
{
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
    
	CALayer *viewLayer = self.vImagePreview.layer;
	NSLog(@"viewLayer = %@", viewLayer);
    
	captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    //UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aadi.png"]];
    //[overlayImageView setFrame:CGRectMake(0,187,290,2)];
    //[captureVideoPreviewLayer addSublayer:overlayImageView.layer];
    
	//[self.vImagePreview setBounds:CGRectMake(40,40,648,864)];
    NSLog(@"vImagePreview bounds: %@", [self getRectString:self.vImagePreview.bounds]);
    NSLog(@"vImagePreview frame: %@", [self getRectString:self.vImagePreview.frame]);
    
	captureVideoPreviewLayer.frame = self.vImagePreview.frame;

	self.vImagePreview.layer.sublayers = nil;
	[self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    NSLog(@"captureVideoPreviewLayer bounds: %@", [self getRectString:captureVideoPreviewLayer.bounds]);
    NSLog(@"captureVideoPreviewLayer frame: %@", [self getRectString:captureVideoPreviewLayer.frame]);    
    
	//   UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aadi.png"]];
	//  [overlayImageView setFrame:CGRectMake(0,187,290,2)];
	// [[self vImagePreview] addSubview:overlayImageView];
	//  [self.vImagePreview.layer addSublayer:overlayImageView.layer];
    
	NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	
	AVCaptureDevice *device;
	if (self.usingFrontCamera)
		device = [devices objectAtIndex:1];
	else
		device = [devices objectAtIndex:0];
    
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
    
	[session startRunning];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
}

- (void)viewDidAppear:(BOOL)animated
{
	if (self.measureType >= 0 && self.measureType < [self.instMessages count])
	{
		NSString* msg = [self.instMessages objectAtIndex:self.measureType];
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:msg  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
}
- (void)viewDidUnload
{
	[self setVImagePreview:nil];
    [self setNavigationTitleLabel:nil];
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
	[vImagePreview release];
    [navigationTitleLabel release];
	[super dealloc];
}
	
-(IBAction) captureBtnClick:(id)sender
{
	//buttonClick=1;
	
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
	
	NSLog(@"about to request a capture from: %@", stillImageOutput);
	[stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
	 {
		 CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
		 if (exifAttachments)
		 {
			 // Do something with the attachments.
			 NSLog(@"attachements: %@", exifAttachments);
		 }
		 else
			 NSLog(@"no attachments");
		 
		 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
		 UIImage *image = [[UIImage alloc] initWithData:imageData];
		
		 self.iv.image = image;
	 }];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CapturePictureDidFinish" object:self];
	
	[self.navigationController popViewControllerAnimated:YES];
	
	/*
	 UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Image from..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image Gallary", nil];
	 actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	 actionSheet.alpha=0.90;
	 actionSheet.tag = 1;
	 [actionSheet showInView:self.view]; 
	 [actionSheet release];
	 */
	/*if(intButton==6)
	 {
	 intButton=1;
	 }
	 else {
	 intButton++;
	 }*/
		
}

- (IBAction)changeCamera:(id)sender {
	self.usingFrontCamera = !self.usingFrontCamera;
	[self createCamera];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
