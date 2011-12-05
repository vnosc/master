    //
//  SelectSpech.m
//  CyberImaging
//
//  Created by jay gurudev on 9/23/11.
//  Copyright 2011 software house. All rights reserved.
//

#import "SelectSpech.h"
#import "ThumbImageView.h"
static int spectWeight=150;
static int spectHeight=50;
@implementation SelectSpech
@synthesize captureImage1,captureImage2,selectedImage,image,scrollimage,scroll;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

/*- (id)initWithImage:(UIImage *)selected
{
	
	return self;
}*/

-(void)viewWillAppear:(BOOL)animated
{
	[selectedImage setImage:image];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	holderView = [[UIView alloc] initWithFrame:CGRectMake(175,112, spectWeight,spectHeight)];
//	holderView.backgroundColor=[UIColor grayColor];
//	holderView.bound
	imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,spectWeight,spectHeight)];
	imageview.image=nil;
	[holderView addSubview:imageview];
	[self.view addSubview:holderView];
	//frameView=[[UIView alloc]initWithFrame:CGRectMake(80,25, 350,300)];
	//frameView.backgroundColor=[UIColor clearColor];
	//[self.view addSubview:frameView];
	[selectedImage setImage:image];
	selectedImage.layer.borderWidth = 1;
	selectedImage.layer.borderColor = [[UIColor grayColor] CGColor];
	captureImage1.layer.borderWidth = 1;
	captureImage1.layer.borderColor = [[UIColor grayColor] CGColor];
	captureImage2.layer.borderWidth = 1;
	captureImage2.layer.borderColor = [[UIColor grayColor] CGColor];


	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] init];
	self.navigationItem.rightBarButtonItem = doneBtn;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneDetail:)];
	
	//scrollimage.pagingEnabled = YES;
	scrollimage.showsHorizontalScrollIndicator = NO;
	scrollimage.backgroundColor=[UIColor grayColor];	
	NSArray *imageFilenames = [[NSArray alloc]initWithObjects:@"1.png",@"2.PNG",@"3.png",@"4.png",@"5.png",@"6.png",nil];//[NSArray arrayWithObjects:encodedString1,encodedString2,encodedString3,encodedString4,encodedString5,encodedString6,nil];
	
	/*
	CGFloat c=20.0f;
	for (NSString *singleImageFilename in imageFilenames) 
	{
		
		UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:singleImageFilename]];//imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:singleImageFilename]]]];
		[scrollimage addSubview:imageView];
		imageView.frame=CGRectMake(c,imageView.frame.origin.y,200,100);
		[scrollimage addSubview:imageView];
		c +=imageView.frame.size.width+10;
		scrollimage.contentSize=CGSizeMake(c,scrollimage.frame.size.height);
		
	}*/
	CGFloat contentOffset = 10.0f;
	for (NSString *name in imageFilenames) 
	{
		//UIImage *thumbImage = [UIImage imageNamed:name];
	//	NSString *imagestring=[[NSString alloc]initWithFormat:@"http://112.propertyshow.ka/upload/%@",name];
	//	NSURL *url = [NSURL URLWithString:imagestring];
	//	NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *thumbImage = [UIImage imageNamed:name];
		
		
		//thumbImage = [ImageManipulator makeRoundCornerImage:thumbImage : 20 : 20];
		if (thumbImage) {
			ThumbImageView *thumbView = [[ThumbImageView alloc] initWithImage:thumbImage];
			[thumbView setDelegate:self];
			[thumbView setImageName:name];
			CGRect frame = CGRectMake(contentOffset, 5.0f,150,50);
			
			[thumbView setFrame:frame];
			[thumbView setHome:frame];
			[scrollimage addSubview:thumbView];
			contentOffset +=thumbView.frame.size.width+20;
			[thumbView release];
			scrollimage.contentSize = CGSizeMake(contentOffset,scrollimage.frame.size.height);
		}
	}
	//CGRect frame = CGRectMake(0,0,320,90);
	//scrollImageView = [[UIView alloc] initWithFrame:frame];
	//[scrollImageView setBackgroundColor:[UIColor blackColor]];
	//[scrollImageView setOpaque:NO];
	//[scrollImageView setAlpha:0.25];
	//[[self view] addSubview:scrollImageView];
	//[self.view sendSubviewToBack:scrollImageView];
	
}

-(void)pickImageNamed:(NSString *)name
{
	//NSString *imageurl=[[NSString alloc]initWithString:name];
	
	UIImage *img=[UIImage imageNamed:name];
	//img = [ImageManipulator makeRoundCornerImage:img : 20 : 20];
	//selectedImage.image=img;
	
	
//	holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150,100)];
//	imageview = [[UIImageView alloc] initWithFrame:[holderView frame]];
	//[imageview setImage:image];
	[imageview setImage:img];
	//[holderView addSubview:imageview];
	
	UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[pinchRecognizer setDelegate:self];
	[holderView addGestureRecognizer:pinchRecognizer];
	
	UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer setDelegate:self];
	[holderView addGestureRecognizer:rotationRecognizer];
	
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[holderView addGestureRecognizer:panRecognizer];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[tapRecognizer setDelegate:self];
	[holderView addGestureRecognizer:tapRecognizer];
	
	//[self.view addSubview:holderView];
}
-(IBAction)ResizeSpect:(id)sender
{
	UISlider *slider=(UISlider *)sender;
	spectWeight=(int)slider.value;
	spectHeight=(int)slider.value/3;
	holderView.frame=CGRectMake(holderView.frame.origin.x,holderView.frame.origin.y,spectWeight,spectHeight);
	imageview.frame=CGRectMake(0,0,spectWeight,spectHeight);
    
}

- (void)thumbImageViewWasTapped:(ThumbImageView *)tiv {
    [self pickImageNamed:[tiv imageName]];
	// [self toggleThumbView];
}

- (void)thumbImageViewStartedTracking:(ThumbImageView *)tiv {
    [scrollimage bringSubviewToFront:tiv];
}


-(IBAction)doneDetail:(id)sender
{
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


-(void)scale:(id)sender {
	
	[frameView bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
	
	if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastScale = 1.0;
		return;
	}
	
	CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
	
	[[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
	
	lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)rotate:(id)sender {
	
	[frameView bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];
	
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastRotation = 0.0;
		return;
	}
	
	CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
	
	[[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];
	
	lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}

-(void)move:(id)sender {
	
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
	
	[frameView bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:frameView];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		
		firstX = [[sender view] center].x;
		firstY = [[sender view] center].y;
	}
	
	translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
	
	[[sender view] setCenter:translatedPoint];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		CGFloat finalX = translatedPoint.x + (.05*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
		CGFloat finalY = translatedPoint.y + (.05*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
		
		if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
			
			if(finalX < 80+ (imageview.frame.size.width/2)) {
				
				finalX = 80 +(imageview.frame.size.width/2);
			}
			
			else if(finalX > 320) {
				
				finalX = 300;
			}
			
			if(finalY < 25) {
				
				finalY = 25 + imageview.frame.size.height/2;
			}
			
			else if(finalY > 325) {
				
				finalY = 325 - imageview.frame.size.height/2;
			}
		}
		
		else {
			
			if(finalX <80 +imageview.frame.size.width/2) {
				
				finalX = 80+imageview.frame.size.width/2;
			}
			
			else if(finalX > 430 - imageview.frame.size.width/2) {
				
				finalX = 430 - imageview.frame.size.width/2;
			}
			
			if(finalY < 25 + imageview.frame.size.height/2) {
				
				finalY = 25 + imageview.frame.size.height/2;
			}
			
			else if(finalY > 325 - imageview.frame.size.height/2) {
				
				finalY = 325 - imageview.frame.size.height/2;
			}
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.05];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[[sender view] setCenter:CGPointMake(finalX, finalY)];
		[UIView commitAnimations];
	}
}

-(void)tapped:(id)sender {
	
	[[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	
	return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}



@end
