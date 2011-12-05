//
//  HomeView.m
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeView.h"
#import "Lenses.h"
#import "Measurements.h"
#import "Adjust.h"
#import "CreateUser.h"
#import "NewUser.h"
static int buttonClick=0;

static int intButton = 1;

@implementation HomeView
@synthesize mainWindow,firstName,lastName,captureImage,smallImage,smallImage2,smallImage3,scroll,slider1,vline,hline;
@synthesize vImagePreview,stillImageOutput;

/*-(IBAction) lensesbtnclick:(id)sender
{
	lense=[[Lenses alloc]init];
	lense.title=@"Lenses";
	[self.navigationController pushViewController:lense animated:YES];

}*/

-(IBAction)ResizeSpect:(id)sender
{
    UISlider *slider=(UISlider *)sender;
	int spectWeight=(int)slider.value *1.76;
	int spectHeight=(int)slider.value;
    
    int x=(spectWeight - captureImage.frame.size.width)/2;
    int y=(spectHeight - captureImage.frame.size.height)/2;
    
    captureImage.frame=CGRectMake(captureImage.frame.origin.x - x,captureImage.frame.origin.y - y,spectWeight,spectHeight);
    scroll.contentSize=CGSizeMake(spectWeight,spectHeight);
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
         
         if(buttonClick==0 )
         {
             self.smallImage.image = image;
             buttonClick++;
         }
         else if(buttonClick==1)
         {
             self.smallImage2.image=image;
             buttonClick++;
         }
         else
         {
             self.smallImage3.image=image;
             buttonClick++;
         }
	 }];
    
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
-(IBAction) retackBtnClick : (id)sender
{
    buttonClick--;
    if(buttonClick==0)
    {
        smallImage=nil;
        
    }
    else if(buttonClick==1)
    {
        smallImage2=nil;
    }
    else
    {
        smallImage3=nil;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"this is 1");
	switch (actionSheet.tag) 
	{
			case 1:
			NSLog(@"this is 2");
			switch (buttonIndex)
			{
					
				case 0:
				{				
	
				
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;  
				picker.delegate = self;  
				//picker.allowsEditing = YES;  
				[self presentModalViewController:picker animated:YES];
				[picker release];
				
	
				}
				break;
				case 1:
				{
					NSLog(@"this is 3");
					UIImagePickerController *picker = [[UIImagePickerController alloc] init];  
					picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
					picker.delegate = self; 
					
					popover = [[UIPopoverController alloc] initWithContentViewController:picker];
					[popover presentPopoverFromRect:CGRectMake(0.0, 0.0, 0.0, 0.0) 
											 inView:self.view
						   permittedArrowDirections:UIPopoverArrowDirectionAny 
										   animated:YES];
					
				//[self presentModalViewController:picker animated:YES];
				//[picker release];
				//	[self.view addSubview:popover.view];	
					
					
				}
				break;
		}
			break;
			
		default:
			break;
	}	
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{	
	NSLog(@"hiii");
	NSData *dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
    captureImage.frame=CGRectMake(0, 0, 340, 300);
    slider1.value=300;
	UIImage *img = [[UIImage alloc] initWithData:dataImage];
	//[dataImage release];
	if(intButton==1)
	{
		NSLog(@"intbtn :%i",intButton);
		captureImage.image=nil;
		[captureImage setImage:img];
		[smallImage setImage:img];
		intButton++;		
		
	}
	else if(intButton==2)
	{
		NSLog(@"intbtn :%i",intButton);
		captureImage.image=nil;
		[captureImage setImage:img];
		[smallImage2 setImage:img];
		intButton++;
	}
	else
	{
		NSLog(@"intbtn :%i",intButton);
		captureImage.image=nil;
		[captureImage setImage:img];
		[smallImage3 setImage:img];
		intButton=1;
	}
		
	[picker dismissModalViewControllerAnimated:YES];
	[popover dismissPopoverAnimated:YES];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker 
	{
	
	[self.navigationController dismissModalViewControllerAnimated:YES];	
	}


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
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(IBAction) selectImageBtnClick:(id)sender
{
	UIButton* button = (UIButton*)sender;
	if(button.tag==1)
	 {
		 [captureImage setImage:smallImage.image];
		 intButton=1;
	 }
	if(button.tag==2)
	{
		[captureImage setImage:smallImage2.image];
		intButton=2;
	}
	if(button.tag==3)
	{
		[captureImage setImage:smallImage3.image];
		intButton=3;
	}
			

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    intButton=1;
	captureImage.layer.borderWidth = 1;
	captureImage.layer.borderColor = [[UIColor grayColor] CGColor];
    smallImage.layer.borderWidth = 1;
	smallImage.layer.borderColor = [[UIColor grayColor] CGColor];
    smallImage2.layer.borderWidth = 1;
	smallImage2.layer.borderColor = [[UIColor grayColor] CGColor];
    smallImage3.layer.borderWidth = 1;
	smallImage3.layer.borderColor = [[UIColor grayColor] CGColor];
	
	UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] init];
	self.navigationItem.rightBarButtonItem = saveBtn;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDetail:)];
	
    scroll.layer.borderWidth = 1;
	scroll.layer.borderColor = [[UIColor grayColor] CGColor];
    scroll.scrollEnabled=NO;
	
    // Do any additional setup after loading the view from its nib.
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@" "  message:@"Is This New User ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NewUser *newuser=[[NewUser alloc]init];
        newuser.title=@"User Information";
        [self.navigationController pushViewController:newuser animated:YES];
    }
}

-(IBAction)saveDetail:(id)sender
{
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


-(void) viewDidAppear:(BOOL)animated
{
   // vline=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aadi.png"]];
  //  vline.frame=CGRectMake(144,187,0,374);
  //  hline=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lineeee.png"]];
    
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetMedium;
    
	CALayer *viewLayer = self.vImagePreview.layer;
	NSLog(@"viewLayer = %@", viewLayer);
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aadi.png"]];
    [overlayImageView setFrame:CGRectMake(0,187,290,2)];
    [captureVideoPreviewLayer addSublayer:overlayImageView.layer];
    
	captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
	[self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
 //   UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aadi.png"]];
  //  [overlayImageView setFrame:CGRectMake(0,187,290,2)];
   // [[self vImagePreview] addSubview:overlayImageView];
  //  [self.vImagePreview.layer addSublayer:overlayImageView.layer];
    
	NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	
	//AVCaptureDevice *device = [devices objectAtIndex:0];
	AVCaptureDevice *device = [devices objectAtIndex:1];
    
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

@end
