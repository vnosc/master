//
//  CaptureOverview.m
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CaptureOverview.h"

extern ServiceObject* mobileSessionXML;
extern ServiceObject* patientXML;
extern ServiceObject* frameXML;

extern NSArray* patientImages;

@implementation CaptureOverview
@synthesize txtPatientName;
@synthesize txtMemberId;
@synthesize imageView1;
@synthesize imageView2;
@synthesize imageView3;
@synthesize imageView4;
@synthesize imageViews;
@synthesize imageLabel1;
@synthesize imageLabel2;
@synthesize imageLabel3;
@synthesize imageLabel4;
@synthesize imageClearBtn1;
@synthesize imageClearBtn2;
@synthesize imageClearBtn3;
@synthesize imageClearBtn4;
@synthesize frameInfo;

@synthesize frameMfr;
@synthesize frameModel;
@synthesize frameType;
@synthesize frameColor;
@synthesize frameABox;
@synthesize frameBBox;
@synthesize frameED;
@synthesize frameDBL;

@synthesize captureVC;
@synthesize suffixes;
@synthesize measureTexts;

@synthesize selectedImageView;

@synthesize HUD;

- (id)init
{
	if (self = [super init])
	{
		self.suffixes = [NSArray arrayWithObjects:@"dist", @"near", @"side", @"tryon", nil];
		self.measureTexts = [NSArray arrayWithObjects:@"Dist PD/Height", @"Near PD", @"Panto/Vertex/Wrap", @"Frame Try-On", nil];
	}
	return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.suffixes = [NSArray arrayWithObjects:@"dist", @"near", @"side", @"tryon", nil];
		self.measureTexts = [NSArray arrayWithObjects:@"Dist PD/Height", @"Near PD", @"Panto/Vertex/Wrap", @"Frame Try-On", nil];
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
	
	self.imageViews = [[NSArray alloc] initWithObjects:self.imageView1, self.imageView2, self.imageView3, self.imageView4, nil];
	
	self.imageLabel1.layer.backgroundColor = [UIColor blackColor].CGColor;
	self.imageLabel2.layer.backgroundColor = [UIColor blackColor].CGColor;
	self.imageLabel3.layer.backgroundColor = [UIColor blackColor].CGColor;
	self.imageLabel4.layer.backgroundColor = [UIColor blackColor].CGColor;
	
	[self.frameInfo.layer setBorderWidth:3.0f];
	[self.frameInfo.layer setCornerRadius:25];
	[self.frameInfo.layer setMasksToBounds:YES];
	//CALayer *l = self.frameInfo.layer;
	CAGradientLayer *l = [CAGradientLayer layer];
	//l.colors = [NSArray arrayWithObjects:[UIColor, nil
	//l.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.3f], [NSNumber numberWithFloat:0.6f], [NSNumber numberWithFloat:1.0f], nil];
	l.colors = [NSArray arrayWithObjects:[UIColor lightGrayColor].CGColor, [UIColor darkGrayColor].CGColor, nil];
	l.frame = self.frameInfo.layer.bounds;
	[self.frameInfo.layer insertSublayer:l atIndex:0];
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	[self getLatestPatientFromService];
	
	[self getFrameInfoFromService];
	
	captureVC = [[CapturePicture alloc]init];
	captureVC.title=@"Image Capture";

	HUD.labelText = @"Downloading images...";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedPatientName:) name:@"UITextFieldTextDidBeginEditingNotification" object:self.txtPatientName];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"UINavigationControllerDidShowViewControllerNotification" object:self.navigationController];
	
	[HUD showWhileExecuting:@selector(loadPatientImages:) onTarget:self withObject:self animated:YES];
	//[HUD show:YES];
	
    //HUD.delegate = self;
	
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
	[self loadPatientData:patientXML];
	[self loadFrameData:frameXML];
	
	[super viewWillAppear:animated];
}

- (void) getLatestPatientFromService
{
	
	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	patientXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientIdv]];
	
}

- (void) loadPatientData:(ServiceObject *)patient
{
	if ([patientXML hasData] && [patientXML.dict objectForKey:@"firstName"])
	{
		[self.txtMemberId setText:[patient getTextValueByName:@"memberId"]];
		[self.txtPatientName setText:[NSString stringWithFormat:@"%@ %@", [patient getTextValueByName:@"firstName"], [patient getTextValueByName:@"lastName"]]];
	}
}

- (void)loadPatientImages:(id)sender
{
	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	int cnt=0;
	
	for (UIImageView* obj in self.imageViews)
	{
		[obj.layer setBorderWidth:3.0f];
		[obj.layer setCornerRadius:25];
		[obj.layer setMasksToBounds:YES];
		
		cnt++;
	}
	
	cnt=0;
	
	for (UIImageView* obj in self.imageViews)
	{
		
		NSString* suffix = [self.suffixes objectAtIndex:cnt];
		
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowPatientImage.aspx?patientId=%d&type=%@&ignore=true", patientId, suffix]]];
		obj.image = [[UIImage imageWithData:imageData] retain];
		
		cnt++;
	}
	
	id img1 = self.imageView1.image ? self.imageView1.image : [NSNull null];
	id img2 = self.imageView2.image ? self.imageView2.image : [NSNull null];
	id img3 = self.imageView3.image ? self.imageView3.image : [NSNull null];
	id img4 = self.imageView4.image ? self.imageView4.image : [NSNull null];
	
	patientImages = [[[NSArray alloc] initWithObjects:img1, img2, img3, img4, nil] retain];

}

- (void) getFrameInfoFromService
{	
	int frameIdx = [mobileSessionXML getIntValueByName:@"frameId"];
	frameXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetFrameInfoByFrameId?frameId=%d", frameIdx]];
	
	if ([frameXML hasData])
	{
		[self loadFrameData:frameXML];
	}
	else
	{
		NSLog(@"Invalid response from web service");
	}
}

- (void) loadFrameData:(ServiceObject *)frame
{
	self.frameMfr.text = [frame getTextValueByName:@"FrameManufacturer"];
	self.frameModel.text = [frame getTextValueByName:@"FrameModel"];
	self.frameType.text = [frame getTextValueByName:@"FrameStyle"];
	self.frameColor.text = [frame getTextValueByName:@"FrameColor"];
	self.frameABox.text = [frame getTextValueByName:@"ABox"];
	self.frameBBox.text = [frame getTextValueByName:@"BBox"];
	self.frameED.text = [frame getTextValueByName:@"ED"];
	self.frameDBL.text = [frame getTextValueByName:@"DBL"];
}

- (void)viewDidUnload
{
    [self setImageView1:nil];
    [self setImageView2:nil];
    [self setImageView3:nil];
    [self setImageView4:nil];
    [self setTxtPatientName:nil];
    [self setTxtMemberId:nil];

	[self setFrameMfr:nil];
	[self setFrameModel:nil];
	[self setFrameType:nil];
	[self setFrameColor:nil];
	[self setFrameABox:nil];
	[self setFrameBBox:nil];
	[self setFrameED:nil];
	[self setFrameDBL:nil];
	
    [self setImageLabel1:nil];
	[self setImageLabel2:nil];
	[self setImageLabel3:nil];
	[self setImageLabel4:nil];
	[self setImageClearBtn1:nil];
	[self setImageClearBtn2:nil];
	[self setImageClearBtn3:nil];
	[self setImageClearBtn4:nil];
	[self setFrameInfo:nil];
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
    [imageView1 release];
    [imageView2 release];
    [imageView3 release];
    [imageView4 release];
    [txtPatientName release];
    [txtMemberId release];

	[frameMfr release];
	[frameModel release];
	[frameType release];
	[frameColor release];
	[frameABox release];
	[frameBBox release];
	[frameED release];
	[frameDBL release];
	
    [imageLabel1 release];
	[imageLabel2 release];
	[imageLabel3 release];
	[imageLabel4 release];
	[imageClearBtn1 release];
	[imageClearBtn2 release];
	[imageClearBtn3 release];
	[imageClearBtn4 release];
	[frameInfo release];
    [super dealloc];
}
- (IBAction)touchImage:(id)sender {
	int imageIdx = [sender tag];
	self.selectedImageView = imageIdx;
	self.captureVC.title = [NSString stringWithFormat:@"Image Capture - %@", [self.measureTexts objectAtIndex:imageIdx ]];
	self.captureVC.iv = [self.imageViews objectAtIndex:self.selectedImageView];
	self.captureVC.measureType = imageIdx;
	[self.navigationController pushViewController:captureVC animated:YES];
}

- (IBAction)clearImage:(id)sender {
}

- (IBAction)touchFrameInfo:(id)sender {
	SupplyFrameInfo *p = [[SupplyFrameInfo alloc] init];
	p.title = @"Frame Search";
	p.updateFrame = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameSearched:) name:@"SupplyFrameInfoDidFinish" object:nil];
	
	[self presentModalViewController:p animated:YES];
}

- (void)frameSearched:(id)sender
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SupplyFrameInfoDidFinish" object:nil];
	[self getFrameInfoFromService];
}


- (IBAction)saveAndContinue:(id)sender {
	
	/*int cnt = 1;
	for (UIImageView* iv in self.imageViews)
	{
		if (!iv.image)
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error - No Image" message:[NSString stringWithFormat:@"No image in slot %d.\nPlease take an image.", cnt]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
			
			return;
		}
		
		cnt++;
	}*/
	
	BOOL isValid = YES;
	
	isValid = isValid && [self validatePatient];
	isValid = isValid && [self validateFrame];
	
	if (isValid)
		[self uploadImagesAndFinish:self];
}

- (BOOL) validatePatient
{
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	if (currentPatientId == 0)
	{
		PatientSearch *patient=[[PatientSearch alloc]init];
		patient.title=@"Patient Selection";
		//[self.navigationController pushViewController:patient animated:YES];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAndContinue:) name:@"PatientSearchDidFinish" object:nil];
		
		[self presentModalViewController:patient animated:YES];
		
		return NO;
	}
	else
	{
		NSLog(@"patient validated");
		return YES;
	}
	
}

- (BOOL) validateFrame
{
	int currentFrameId = [mobileSessionXML getIntValueByName:@"frameId"];
	
	if (currentFrameId == 0)
	{
		SupplyFrameInfo *frame=[[SupplyFrameInfo alloc]init];
		frame.title=@"Frame Selection";
		frame.updateFrame = YES;
		//[self.navigationController pushViewController:patient animated:YES];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAndContinue:) name:@"SupplyFrameInfoDidFinish" object:nil];
		
		[self presentModalViewController:frame animated:YES];
		
		return NO;
	}
	else
	{
		NSLog(@"frame validated");
		return YES;
	}
	
}


- (void) uploadImagesAndFinish:(id)sender
{
	int currentPatientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"PatientSearchDidFinish" object:nil];
	
	if (currentPatientId != 0)
	{
		id img1 = self.imageView1.image ? self.imageView1.image : [NSNull null];
		id img2 = self.imageView2.image ? self.imageView2.image : [NSNull null];
		id img3 = self.imageView3.image ? self.imageView3.image : [NSNull null];
		id img4 = self.imageView4.image ? self.imageView4.image : [NSNull null];
		
		patientImages = [[[NSArray alloc] initWithObjects:img1, img2, img3, img4, nil] retain];
		
		[self performSelectorInBackground:@selector(uploadImages:) withObject:self];
		
		MeasureOverview *p = [[MeasureOverview alloc]init];
		p.title=@"Eye Measurement";
		[self.navigationController pushViewController:p animated:YES];
	}
}

- (void) uploadImages:(id)sender
{
	NSURL* url = [NSURL URLWithString:@"http://smart-i.mobi/UploadPatientImage.aspx"];
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];

	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	
	for (int i=0; i < 4; i++)
	{
				UIImageView* uiv = [self.imageViews objectAtIndex:i];
		
		if (uiv.image)
		{
			NSString* suffix = [suffixes objectAtIndex:i];
			NSString *fileName = [NSString stringWithFormat:@"%d_%@.jpg", patientId, suffix];
			
			// Upload an image
			NSData *imageData = UIImageJPEGRepresentation(uiv.image, 0);
			[request addData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:[NSString stringWithFormat:@"image_%@", suffix]];
		}
	}
	
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(uploadRequestFinished:)];
	[request setDidFailSelector:@selector(uploadRequestFailed:)];
		
	//HUD.labelText = @"Uploading images...";
	//[HUD show:YES];
	
	[request startAsynchronous];
	
	
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{    
    NSString *responseString = [request responseString];
	NSLog(@"Upload response %@", responseString);
	
	//[HUD hide:YES];
	
	/*MeasureOverview *p = [[MeasureOverview alloc]init];
	p.title=@"Eye Measurement";
	[self.navigationController pushViewController:p animated:YES];*/

}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
	
	NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]); 
}

-(void)clickedPatientName:(NSNotification*)n
{
	UITextField *tf = (UITextField*) n.object;

	[tf resignFirstResponder];
	[tf endEditing:YES];
	NSLog(@"SPROING");
	
	NSLog(@"%@ -> %@ -> %@", n.name, n.object, n.userInfo);
	
	PatientSearch *patient=[[PatientSearch alloc]init];
	patient.title=@"Patient Selection";
	//[self.navigationController pushViewController:patient animated:YES];
	[self presentModalViewController:patient animated:YES];
}

@end
