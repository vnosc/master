//
//  FrameStyling.m
//  Smart-i
//
//  Created by Troy Potts on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FrameStyling.h"

extern ServiceObject* mobileSessionXML;
extern ServiceObject* patientXML;
extern NSArray* patientImages;

@implementation FrameStyling
@synthesize txtPatientName;
@synthesize txtMemberId;
@synthesize imageCompareL;
@synthesize imageCompareR;
@synthesize imageCompareViews;
@synthesize imageViews;
@synthesize imageViewBtns;
@synthesize retakePictureBtns;
@synthesize frameNameCompareLbls;
@synthesize frameNameLbls;
@synthesize pgr;
@synthesize tgr;
@synthesize dragImage = _dragImage;
@synthesize draggedImage;
@synthesize selectedImageView;
@synthesize captureVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
		NSLog(@"%@, %@", nibNameOrNil, nibBundleOrNil);
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		NSLog(@"whut");
		
        // Custom initialization
		self.dragImage = [[UIImageView alloc] init];
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
	
	captureVC = [[CapturePicture alloc]init];
	captureVC.title=@"Image Capture";
	
			self.dragImage = [[UIImageView alloc] init];
	[self.view addSubview:self.dragImage];
	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickedPatientName:) name:@"UITextFieldTextDidBeginEditingNotification" object:self.txtPatientName];
	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshImages:) name:@"PatientRecordDidFinish" object:nil];
	
	[self getLatestPatientFromService];
	
	[self loadPatientImages];
	
	[self.view addGestureRecognizer:self.tgr];
	[self.tgr setNumberOfTapsRequired:1];
	[self.tgr setNumberOfTouchesRequired:1];
	
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Package-Selection-Gray_0012s_0000_Layer-3.png"]];
	
	CALayer *layer;
	id img = [patientImages objectAtIndex:0];
	
	for (UIImageView *iv in self.imageViews)
	{		
		layer = iv.layer;
		[layer setBorderWidth:3.0f];
		[layer setCornerRadius:25];
		[layer setMasksToBounds:YES];
		
		[iv addGestureRecognizer:self.pgr];
	}
	
	layer = self.imageCompareL.layer;
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	layer = self.imageCompareR.layer;
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];	
	
	layer = self.dragImage.layer;
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];	
	
	if (img != [NSNull null])
	{
		self.imageCompareL.image = img;
		self.imageCompareR.image = img;
	}
	
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self loadPatientData:patientXML];
	
	//[self refreshImages];
	
	for (UIButton *b in self.retakePictureBtns)
	{
		UIImageView *iv = [self.imageViews objectAtIndex:b.tag];
		b.hidden = (iv.image == nil);
		[b setExclusiveTouch:YES];
	}
}

- (void)refreshImages:(NSNotification*)n
{
	/*id img = [patientImages objectAtIndex:0];
	if (img == [NSNull null])
		img = nil;
	for (UIImageView *iv in self.imageViews)
	{
		iv.image = img;
	}
	
	self.imageCompareL.image = img;
	self.imageCompareR.image = img;*/
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	self.draggedImage = NO;
	self.dragImage.layer.opacity = 0.0f;
}
- (void)viewDidUnload
{
	[self setTxtPatientName:nil];
	[self setTxtMemberId:nil];
	[self setImageViews:nil];
	[self setImageCompareL:nil];
	[self setImageCompareR:nil];
    [self setPgr:nil];
	[self setImageViewBtns:nil];
	[self setTgr:nil];
	[self setImageCompareViews:nil];
	[self setRetakePictureBtns:nil];
	[self setFrameNameLbls:nil];
	[self setFrameNameCompareLbls:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) getLatestPatientFromService
{
	
	int patientIdv = [mobileSessionXML getIntValueByName:@"patientId"];
	patientXML = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetPatientInfo?patientId=%d", patientIdv]];
	
}

-(void)clickedPatientName:(NSNotification*)n
{
	UITextField *tf = (UITextField*) n.object;
	
	[tf resignFirstResponder];
	[tf endEditing:YES];
	NSLog(@"SPROING");
	
	NSLog(@"%@ -> %@ -> %@", n.name, n.object, n.userInfo);
	
	PatientRecord *patient=[[PatientRecord alloc]init];
	patient.title=@"Patient Record";
	//[self.navigationController pushViewController:patient animated:YES];
	[self presentModalViewController:patient animated:YES];
}

- (void) loadPatientData:(ServiceObject *)patient
{
	if ([patientXML hasData] && [patientXML.dict objectForKey:@"FirstName"])
	{
		[self.txtMemberId setText:[patient getTextValueByName:@"MemberId"]];
		[self.txtPatientName setText:[patient getTextValueByName:@"PatientFullName"]];
	}
}

- (void)loadPatientImages
{
	CaptureOverview* co = [[CaptureOverview alloc] init];
	
	int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
	int cnt=0;
	
	cnt=0;
	
	NSMutableArray *mi = [[NSMutableArray alloc] init];
	
	for (NSString* suffix in co.suffixes)
	{
		
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://smart-i.mobi/ShowPatientImage.aspx?patientId=%d&type=%@&ignore=true", patientId, suffix]]];
		UIImage *uiimg = [[UIImage imageWithData:imageData] retain];
		id img = uiimg ? uiimg : [NSNull null];
		
		[mi addObject:img];
		
		cnt++;
	}
	
	patientImages = [[NSArray arrayWithArray:mi] retain];
	
}

- (void)dealloc {
	[txtPatientName release];
	[txtMemberId release];
	[imageViews release];
	[imageCompareL release];
	[imageCompareR release];
    [pgr release];
	[imageViewBtns release];
	[tgr release];
	[imageCompareViews release];
	[retakePictureBtns release];
	[frameNameLbls release];
	[frameNameCompareLbls release];
	[super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[event allTouches] count] == 1)
	{
		UITouch *t = [touches anyObject];
		//int cnt = 0;
		int cnt = 0;
		for (UIImageView *img in self.imageViews)
		{
			CGPoint p = [t locationInView:img];
			NSLog(@"%f,%f", p.x, p.y);
			//if ([t view] == img)
			if ([img pointInside:p withEvent:event])
			{
				self.draggedImage = YES;
				self.selectedImageView = cnt;
				
				[self.dragImage setImage:img.image];
				[self.dragImage setFrame:img.frame];
				[self.dragImage setBounds:img.bounds];
				//[self.draggedImage setHidden:NO];
				
				CGPoint m = [t locationInView:self.view];
				self.dragImage.center = m;
				
				self.dragImage.layer.opacity = 0.0f;
				
				CABasicAnimation *t = [CABasicAnimation animationWithKeyPath:@"opacity"];
				
				[self.dragImage.layer setOpacity:0.5f];
				
				t.fromValue = [NSNumber numberWithFloat:0.0f];
				t.toValue = [NSNumber numberWithFloat:0.5f];
				t.duration = 0.2f;
				
				t.delegate = self;
				
				[self.dragImage.layer addAnimation:t forKey:@"animateOpacity"];
				
				//[self.draggedImage setAnimationDuration:1.0f];
				//[self.draggedImage startAnimating];
				/*[CATransaction begin];
				[CATransaction setValue:[NSNumber numberWithFloat:10.0f] forKey:kCATransactionAnimationDuration];
				
				[self.draggedImage.layer setOpacity:1.0f];
				
				[CATransaction commit];*/
				
				NSLog(@"imageview %d dragged", cnt);
				break;
			}
			cnt++;
		}
	}
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.draggedImage)
	{
		NSLog(@"moving dragged image");
		UITouch *t = [touches anyObject];
		CGPoint m = [t locationInView:self.view];
		self.dragImage.center = m;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.draggedImage)
	{
		//[self.draggedImage setHidden:YES];
		//[CATransaction begin];
		//[CATransaction setValue:[NSNumber numberWithFloat:10.0f] forKey:kCATransactionAnimationDuration];
		
		CABasicAnimation *t = [CABasicAnimation animationWithKeyPath:@"opacity"];
		
		[self.dragImage.layer setOpacity:0.0f];
		
		t.fromValue = [NSNumber numberWithFloat:0.5f];
		t.toValue = [NSNumber numberWithFloat:0.0f];
		t.duration = 0.2f;
		
		t.delegate = self;
		
		[self.dragImage.layer addAnimation:t forKey:@"animateOpacity"];
		
		self.draggedImage = NO;
		
		//[CATransaction commit];
		
		UITouch *t2 = [touches anyObject];
		
		int cnt=0;
		for (UIImageView *img in self.imageCompareViews)
		{
			CGPoint p = [t2 locationInView:img];
			NSLog(@"%f,%f", p.x, p.y);
			//if ([t view] == img)
			if ([img pointInside:p withEvent:event])
			{
				img.image = self.dragImage.image;
				UILabel *l = [self.frameNameCompareLbls objectAtIndex:cnt];
				UILabel *l2 = [self.frameNameLbls objectAtIndex:self.selectedImageView];
				l.text = l2.text;
			}
			cnt++;
		}
		
		self.selectedImageView = -1;
	}
}

- (IBAction)touchImage:(id)sender {
	
	//int cnt = 0;
	int cnt = 0;
	self.tgr.cancelsTouchesInView = NO;
	
	for (UIImageView *img in self.imageViews)
	{
		CGPoint p = [self.tgr locationInView:img];
		NSLog(@"%f,%f", p.x, p.y);
		//if ([t view] == img)
		if ([img pointInside:p withEvent:nil])
		{
			NSLog(@"Touched");
			int imageIdx = cnt;
			
			UIImageView *iv = [self.imageViews objectAtIndex:imageIdx];
			if (iv.image)
			{
				UIViewController *vc = [[UIViewController alloc] init];
				vc.contentSizeForViewInPopover = CGSizeMake(768,1024);
				UIImageView *ivp = [[UIImageView alloc] initWithImage:iv.image];
				ivp.contentMode = UIViewContentModeScaleAspectFit;
				vc.view = ivp;
				vc.view.backgroundColor = [UIColor whiteColor];
				CGPoint p = [self.view convertPoint:iv.frame.origin toView:self.view];
				CGRect r = CGRectMake(p.x, p.y, iv.frame.size.width, iv.frame.size.height);
				UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:vc];
				[pc presentPopoverFromRect:r inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			}
			else
			{
				self.tgr.cancelsTouchesInView = YES;
				[self takePicture:imageIdx];
			}
			break;
		}
		
		cnt++;
	}
}

- (IBAction)retakePictureBtnClicked:(id)sender {
	NSLog(@"retake btn");
	[self takePicture:[sender tag]];
}

- (void)takePicture:(int)imageIdx
{
	NSLog(@"take picture: %d", self.selectedImageView);
	self.selectedImageView = imageIdx;
	UIImageView *iv = [self.imageViews objectAtIndex:self.selectedImageView];
	self.captureVC.title = @"Image Capture";
	self.captureVC.iv = iv;
	self.captureVC.measureType = -1;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(promptForFrame:) name:@"CapturePictureDidFinish" object:nil];
	
	[self.navigationController pushViewController:captureVC animated:YES];
}

- (void)promptForFrame:(id)sender
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"CapturePictureDidFinish" object:nil];
	
	SupplyFrameInfo *p = [[SupplyFrameInfo alloc] init];
	p.title = @"Frame Search";

	UILabel *l = [self.frameNameLbls objectAtIndex:self.selectedImageView];
	l.text = @"Unknown Frame";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveFrameName:) name:@"SupplyFrameInfoDidFinish" object:nil];
	
	[self presentModalViewController:p animated:YES];
}

- (void)saveFrameName:(id)sender
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SupplyFrameInfoDidFinish" object:nil];
	
	NSNotification *n = (NSNotification*)sender;
	NSDictionary *d = [n userInfo];
	
	UILabel *l = [self.frameNameLbls objectAtIndex:self.selectedImageView];
	l.text = [d objectForKey:@"frameType"];
}

@end
