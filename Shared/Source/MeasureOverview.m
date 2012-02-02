//
//  CaptureOverview.m
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MeasureOverview.h"

extern NSArray* patientImages;
extern NSArray* patientImagesMeasured;

extern ServiceObject* mobileSessionXML;
extern ServiceObject* patientXML;
extern ServiceObject* prescriptionXML;

@implementation MeasureOverview
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
@synthesize imageLabels;

@synthesize txtRightDistPD;
@synthesize txtLeftDistPD;
@synthesize txtRightNearPD;
@synthesize txtLeftNearPD;
@synthesize txtRightHeight;
@synthesize txtLeftHeight;
@synthesize txtPantho;
@synthesize txtVertex;
@synthesize txtWrap;

@synthesize measureDetailView;

@synthesize measureVC;
@synthesize suffixes;
@synthesize measureTexts;

@synthesize measureType;
@synthesize selectedImageView;

@synthesize HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
				self.suffixes = [NSArray arrayWithObjects:@"distm", @"nearm", @"pantho", @"vertwrap", nil];
				self.measureTexts = [NSArray arrayWithObjects:@"Dist PD/Height", @"Frame Wrap", @"Pantoscopic Angle", @"Vertex Distance", nil];
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
	self.imageLabels = [[NSArray alloc] initWithObjects:self.imageLabel1, self.imageLabel2, self.imageLabel3, self.imageLabel4, nil];	
    
    [self initImageLabelsText];
    
	[self.measureDetailView.layer setBorderWidth:3.0f];
	[self.measureDetailView.layer setCornerRadius:25];
	[self.measureDetailView.layer setMasksToBounds:YES];
	//CALayer *l = self.frameInfo.layer;
	
	[self createGradientForLayer:self.measureDetailView.layer];
	
	self.imageLabel1.layer.backgroundColor = [UIColor blackColor].CGColor;
	self.imageLabel2.layer.backgroundColor = [UIColor blackColor].CGColor;
	self.imageLabel3.layer.backgroundColor = [UIColor blackColor].CGColor;
	self.imageLabel4.layer.backgroundColor = [UIColor blackColor].CGColor;
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.labelText = @"Downloading images...";

	[self getLatestPatientFromService];
	
	[self getLatestPrescriptionFromService];
	
	[HUD showWhileExecuting:@selector(loadPatientImages:) onTarget:self withObject:self animated:YES];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(measurementDone:)
	 name:@"MeasurePictureDidCalculateMeasurement"
	 object:self.measureVC];
	
    // Do any additional setup after loading the view from its nib.
}

- (void) getLatestPatientFromService
{
	
	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	patientXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientIdv]];
	
	if ([patientXML hasData] && [patientXML.dict objectForKey:@"FirstName"])
	{
		[self loadPatientData:patientXML];
	}
	
}

- (void) loadPatientData:(ServiceObject *)patient
{
	[self.txtMemberId setText:[patient getTextValueByName:@"MemberId"]];
	[self.txtPatientName setText:[patient getTextValueByName:@"PatientFullName"]];
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
		
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[ServiceObject urlOfWebPage:[NSString stringWithFormat:@"ShowPatientImage.aspx?patientId=%d&type=%@&ignore=true", patientId, suffix]]]];
		obj.image = [[UIImage imageWithData:imageData] retain];
        
		cnt++;
	}
	
	cnt = 0;
	for (UIImageView* obj in self.imageViews)
	{
		if (obj.image == nil && (cnt == 1 || [patientImages objectAtIndex:cnt] != [NSNull null]))
        {
            if (cnt != 1)
                obj.image = [patientImages objectAtIndex:cnt];
            else
            {
                obj.image = [UIImage imageNamed:@"frame_wrap_rotated.png"];
                
                [obj setContentMode:UIViewContentModeScaleAspectFit];
                [obj setBackgroundColor:[UIColor whiteColor]];
                
                /*CGAffineTransform rotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                                            -90.0 * M_PI / 180.0f);
                
                obj.transform = rotateTransform;*/
            }
        }
        
		if (cnt < 2)
			cnt++;
	}

	[self updatePatientImagesMeasured];
}

- (void) initImageLabelsText
{
    int cnt=0;
	
	for (UILabel* obj in self.imageLabels)
	{
		
        [obj setText:[NSString stringWithFormat:@"Measure %@", [self.measureTexts objectAtIndex:cnt]]];
        
		cnt++;
	}
}

- (void) updatePatientImagesMeasured
{
	id img1 = self.imageView1.image ? self.imageView1.image : [NSNull null];
	id img2 = self.imageView2.image ? self.imageView2.image : [NSNull null];
	id img3 = self.imageView3.image ? self.imageView3.image : [NSNull null];
	id img4 = self.imageView4.image ? self.imageView4.image : [NSNull null];
	
    img2 = [NSNull null];
    
	patientImagesMeasured = [[[NSArray alloc] initWithObjects:img1, img2, img3, img4, nil] retain];	
}

- (void) getLatestPrescriptionFromService
{
	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	
	prescriptionXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPrescriptionInfoByPatientId?patientId=%d&number=1", patientIdv]];
	
	if ([prescriptionXML hasData])
	{
		[self loadPrescription:prescriptionXML];
		
		int oldPresId = [mobileSessionXML getIntValueByName:@"prescriptionId"];
		if (oldPresId == 0)
		{
			[mobileSessionXML setObject:[NSNumber numberWithInt:[prescriptionXML getIntValueByName:@"prescriptionId"]] forKey:@"prescriptionId"];
			[mobileSessionXML updateMobileSessionData];
		}
	}
	else
	{
		NSLog(@"Invalid response from web service");
	}
	
}

- (void) loadPrescription:(ServiceObject *)prescription
{
	[self.txtRightDistPD setText:[prescription getTextValueByName:@"REDistPD"]];
	[self.txtLeftDistPD setText:[prescription getTextValueByName:@"LEDistPD"]];
	[self.txtRightNearPD setText:[prescription getTextValueByName:@"RENearPD"]];
	[self.txtLeftNearPD setText:[prescription getTextValueByName:@"LENearPD"]];
	[self.txtRightHeight setText:[prescription getTextValueByName:@"REHeight"]];
	[self.txtLeftHeight setText:[prescription getTextValueByName:@"LEHeight"]];
	[self.txtPantho setText:[prescription getTextValueByName:@"PanthoscopicAngle"]];
	[self.txtVertex setText:[prescription getTextValueByName:@"VertexDistance"]];
	[self.txtWrap setText:[prescription getTextValueByName:@"WrapAngle"]];
}

- (void)viewDidUnload
{
    [self setImageView1:nil];
    [self setImageView2:nil];
    [self setImageView3:nil];
    [self setImageView4:nil];
    [self setTxtPatientName:nil];
    [self setTxtMemberId:nil];
	
	[self setTxtRightDistPD:nil];
    [self setTxtLeftDistPD:nil];
    [self setTxtRightNearPD:nil];
    [self setTxtLeftNearPD:nil];
    [self setTxtRightHeight:nil];
    [self setTxtLeftHeight:nil];
    [self setTxtPantho:nil];
    [self setTxtVertex:nil];
    [self setTxtWrap:nil];
	
	[self setImageLabel1:nil];
	[self setImageLabel2:nil];
	[self setImageLabel3:nil];
	[self setImageLabel4:nil];
	[self setMeasureDetailView:nil];
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
	
	[txtRightDistPD release];
    [txtLeftDistPD release];
    [txtRightNearPD release];
    [txtLeftNearPD release];
    [txtRightHeight release];
    [txtLeftHeight release];
    [txtPantho release];
    [txtVertex release];
    [txtWrap release];
	
	[imageLabel1 release];
	[imageLabel2 release];
	[imageLabel3 release];
	[imageLabel4 release];
	[measureDetailView release];
    [super dealloc];
}
- (IBAction)touchImage:(id)sender {
	
	int imageIdx = [sender tag];
	int adjustedIdx = (imageIdx == 3) ? 2 : imageIdx;
	
	NSLog(@"%d", imageIdx);
	self.selectedImageView = imageIdx;
	NSLog(@"%d", self.selectedImageView);
	
    if (imageIdx == 1)
    {
        [self showWrapAnglePage];
        return;
    }
    
	NSString* measureText = [self.measureTexts objectAtIndex:imageIdx ];
	
	if ([patientImages objectAtIndex:adjustedIdx] != [NSNull null])
	{
		UIImageView *uiv = [self.imageViews objectAtIndex:self.selectedImageView];
		
		
		measureVC = [[MeasurePicture alloc]init];
		self.measureVC.title = [NSString stringWithFormat:@"Eye Measurement - %@", measureText];
		self.measureVC.measureType = imageIdx;
		self.measureType = imageIdx;
		
		NSLog(@"%@", uiv.image);
		//self.measureVC.iv = [self.imageViews objectAtIndex:self.selectedImageView];
		
		int adjustedIdx = (imageIdx == 3) ? 2 : imageIdx;
		
		self.measureVC.img = [patientImages objectAtIndex:adjustedIdx];
		
		[self.navigationController pushViewController:measureVC animated:YES];
	}
	else
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"No Image Found"] message:[NSString stringWithFormat:@"You must take a picture of the patient to measure %@.", measureText] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)wrapAngleBtnClicked:(id)sender {
	
    [self showWrapAnglePage];
}

- (void) showWrapAnglePage
{
	self.measureType = 4;
	
	MeasureWrapAngle *p = [[MeasureWrapAngle alloc] init];
	p.title = @"Measure Wrap Angle";
	[self.navigationController pushViewController:p animated:YES];
}

- (IBAction)saveAndContinue:(id)sender {
	
	//patientImages = [self.imageViews copy];
	
	//ServiceObject executeServiceMethod:@"UpdatePrescriptionMeasurements?prescriptionId=%d&
	
	BOOL isValid = YES;
	
	//self.modified = NO;
	
	NSLog(@"Validating measurements");
	
	isValid = isValid && [self validateMeasurementValue:self.txtRightDistPD showAlert:isValid];
	isValid = isValid && [self validateMeasurementValue:self.txtLeftDistPD showAlert:isValid];
	isValid = isValid && [self validateMeasurementValue:self.txtRightNearPD showAlert:isValid];
	isValid = isValid && [self validateMeasurementValue:self.txtLeftNearPD showAlert:isValid];
	isValid = isValid && [self validateMeasurementValue:self.txtRightHeight showAlert:isValid];
	isValid = isValid && [self validateMeasurementValue:self.txtLeftHeight showAlert:isValid];
	isValid = isValid && [self validateMeasurementValue:self.txtPantho showAlert:isValid];
	isValid = isValid && [self validateMeasurementValue:self.txtVertex showAlert:isValid];
	isValid = isValid && [self validateMeasurementValue:self.txtWrap showAlert:isValid];
	
	if (isValid)
	{
		//		NSString* result = 
		
		//NSLog(@"Should we insert new prescription? %@", self.modified ? @"YES" : @"NO");
		
		int prescriptionId = [mobileSessionXML getIntValueByName:@"prescriptionId"];
		
		[ServiceObject executeServiceMethod:[NSString stringWithFormat:@"UpdatePrescriptionMeasurements?prescriptionId=%d&REDistPD=%@&LEDistPD=%@&RENearPD=%@&LENearPD=%@&REHeight=%@&LEHeight=%@&PanthoscopicAngle=%@&VertexDistance=%@&WrapAngle=%@", prescriptionId, self.txtRightDistPD.text, self.txtLeftDistPD.text, self.txtRightNearPD.text, self.txtLeftNearPD.text, self.txtRightHeight.text, self.txtLeftHeight.text, self.txtPantho.text, self.txtVertex.text, self.txtWrap.text]];
		
		[self updatePatientImagesMeasured];
		
		[self performSelectorInBackground:@selector(uploadImages:) withObject:self];
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Measurements Saved" message:@"The measurements you have taken have been saved to the current prescription." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
}
	
- (BOOL) validateMeasurementValue:(UITextField *)textField showAlert:(BOOL)showAlert
{	
	NSString* value = textField.text;
	//if ([textField.text length] == 0)
	//	value = nil;
	
	NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
	NSNumber* n = [nf numberFromString:value];
	
	BOOL isValid = ![textField hasText] || (n != nil);
	
	textField.textColor = isValid ? [UIColor blackColor] : [UIColor redColor];
	
	if (!isValid && showAlert)
	{
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Invalid Value"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
		
		//[textField becomeFirstResponder];
	}
	
	return isValid;
}

- (void)createGradientForLayer:(CALayer*)layerArg
{
	CAGradientLayer *l = [CAGradientLayer layer];
	//l.colors = [NSArray arrayWithObjects:[UIColor, nil
	//l.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.3f], [NSNumber numberWithFloat:0.6f], [NSNumber numberWithFloat:1.0f], nil];
	l.colors = [NSArray arrayWithObjects:[UIColor lightGrayColor].CGColor, [UIColor darkGrayColor].CGColor, nil];
	l.frame = layerArg.bounds;
	[layerArg insertSublayer:l atIndex:0];
}

- (void)measurementDone:(NSNotification*)n
{
	NSDictionary* d = [n userInfo];
	
	NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);

	if ([self.imageViews count] > measureType && [d objectForKey:@"FinalImage"])
	{
		UIImage* finalImage = [d objectForKey:@"FinalImage"];
		
		UIImageView* uiv = [self.imageViews objectAtIndex:measureType];
		uiv.image = finalImage;
	}
	
	if (measureType == 0)
	{
		self.txtRightDistPD.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"RightDistPD"] floatValue]];
		self.txtLeftDistPD.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"LeftDistPD"] floatValue]];
		self.txtRightNearPD.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"RightDistPD"] floatValue] - 2.8f];
		self.txtLeftNearPD.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"LeftDistPD"] floatValue] - 2.8f];        
		self.txtRightHeight.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"RightHeight"] floatValue]];
		self.txtLeftHeight.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"LeftHeight"] floatValue]];
	}
	else if (measureType == 1)
	{
		self.txtRightNearPD.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"RightNearPD"] floatValue]];
		self.txtLeftNearPD.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"LeftNearPD"] floatValue]];
	}
	else if (measureType == 2)
	{
		self.txtPantho.text = [NSString stringWithFormat:@"%.2fº", [[d objectForKey:@"Pantho"] floatValue]];
	}
	else if (measureType == 3)
	{
		self.txtVertex.text = [NSString stringWithFormat:@"%.2f", [[d objectForKey:@"Vertex"] floatValue]];
		//self.txtWrap.text = [[d objectForKey:@"Wrap"] stringValue];
	}
	else if (measureType == 4)
	{
		self.txtWrap.text = [NSString stringWithFormat:@"%.2fº", [[d objectForKey:@"WrapAngle"] floatValue]];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([alertView.title compare:@"Measurements Saved"] == NSOrderedSame)
		[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) uploadImages:(id)sender
{
	NSURL* url = [NSURL URLWithString:[ServiceObject urlOfWebPage:@"UploadPatientImage.aspx"]];
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

@end
