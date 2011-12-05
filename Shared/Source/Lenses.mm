    //
//  Lenses.m
//  CyberImaging
//
//  Created by jay gurudev on 9/21/11.
//  Copyright 2011 software house. All rights reserved.
//

#import "Lenses.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenCV/opencv2/objdetect/objdetect.hpp>
#import <OpenCV/opencv2/imgproc/imgproc_c.h>
static int a=0;
static int intButton = 1;
static int boxX=0;
static int boxY=0;
static int boxWeidth=0;
static int boxHeight=0;
static int storeImageData=0;
@implementation Lenses
@synthesize typedata1,typedata2,typedata3,dropdownBtn1,dropdownBtn3,dropdownBtn2,image,image_1,image_2,captureImage,scroll,straitImage,lookdownImage,sideImage,move;

/*-(IBAction) saveBtnClick:(id)sender
{
}*/

-(IBAction) radiobtn1Click:(id)sender
{
	[radioBtn1 setSelected:YES];
	[radioBtn2 setSelected:NO];
	[radioBtn3 setSelected:NO];
}
-(IBAction) radiobtn2Click:(id)sender
{
	[radioBtn1 setSelected:NO];
	[radioBtn2 setSelected:YES];
	[radioBtn3 setSelected:NO];
}
-(IBAction) radiobtn3Click:(id)sender
{
	[radioBtn1 setSelected:NO];
	[radioBtn2 setSelected:NO];
	[radioBtn3 setSelected:YES];
}
-(IBAction) droapdownBtnClick1:(id)sender
{
	[dropDownView1 openAnimation];
	a=1;
}
-(IBAction) droapdownBtnClick2:(id)sender
{
	[dropDownView2 openAnimation];
	a=2;
}
-(IBAction) droapdownBtnClick3:(id)sender
{
	a=3;
	[dropDownView3 openAnimation];
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

-(IBAction)saveDetail:(id)sender
{
}

-(void)viewWillAppear:(BOOL)animated
{
	//[captureImage setImage:image];
    [straitImage setImage:image];
    [lookdownImage setImage:image_1];
    [sideImage setImage:image_2];
    [captureImage setImage:straitImage.image];
    UIImage *img=nil;//[UIImage imageWithContentsOfFile:path];
    [self opencvFaceDetect:img];
}

-(IBAction)ResizeSpect:(id)sender
{
	UISlider *slider=(UISlider *)sender;
	int spectWeight=(int)slider.value;
	int spectHeight=(int)slider.value;
    int x=(captureImage.frame.size.width - spectWeight)/2;
    int y=(captureImage.frame.size.height - spectHeight)/2;
   // NSLog(@"x:%i Y:%i",spectHeight,spectWeight);
    captureImage.frame=CGRectMake(captureImage.frame.origin.x + x,captureImage.frame.origin.y + y, spectWeight,spectHeight);
    scroll.contentSize=CGSizeMake(captureImage.frame.size.width,captureImage.frame.size.height);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
	//	captureImage.image =image;
	
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"];
	//image = [UIImage imageWithContentsOfFile:path];
	//UIImage *img=nil;//[UIImage imageWithContentsOfFile:path];
	//[self opencvFaceDetect:img];
	
	//[captureImage setImage:cropped];
	UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] init];
	self.navigationItem.rightBarButtonItem = saveBtn;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveDetail:)];
	
	
	
	typedata1 =[[NSArray alloc]initWithArray:[NSArray arrayWithObjects:@"1",@"2",@"3",nil]];
	dropDownView1 = [[DropDownView alloc] initWithArrayData:typedata1 cellHeight:30 heightTableView:200 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:dropdownBtn1 animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
	
	typedata2 =[[NSArray alloc]initWithArray:[NSArray arrayWithObjects:@"1",@"2",@"3",nil]];
	dropDownView2 = [[DropDownView alloc] initWithArrayData:typedata2 cellHeight:30 heightTableView:200 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:dropdownBtn2 animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
	
	typedata3 =[[NSArray alloc]initWithArray:[NSArray arrayWithObjects:@"1",@"2",@"3",nil]];
	dropDownView3 = [[DropDownView alloc] initWithArrayData:typedata3 cellHeight:30 heightTableView:200 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:dropdownBtn3 animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
	
	dropDownView1.delegate =self;
	dropDownView2.delegate =self;
	dropDownView3.delegate =self;
	[self.view addSubview:dropDownView1.view];
	[self.view addSubview:dropDownView2.view];
	[self.view addSubview:dropDownView3.view];
	[dropdownBtn1 setTitle:[typedata1 objectAtIndex:0] forState:UIControlStateNormal];
	[dropdownBtn2 setTitle:[typedata2 objectAtIndex:0] forState:UIControlStateNormal];
	[dropdownBtn3 setTitle:[typedata3 objectAtIndex:0] forState:UIControlStateNormal];
	
	scroll.layer.borderWidth = 1;
	scroll.layer.borderColor = [[UIColor grayColor] CGColor];
    scroll.scrollEnabled=NO;
	sideImage.layer.borderWidth = 1;
	sideImage.layer.borderColor = [[UIColor grayColor] CGColor];
    straitImage.layer.borderWidth = 1;
	straitImage.layer.borderColor = [[UIColor grayColor] CGColor];
    lookdownImage.layer.borderWidth = 1;
	lookdownImage.layer.borderColor = [[UIColor grayColor] CGColor];
    textview.layer.borderWidth = 1;
	textview.layer.borderColor = [[UIColor grayColor] CGColor];
}
-(IBAction) selectImageBtnClick:(id)sender
{
	UIButton* button = (UIButton*)sender;
	if(button.tag==1)
    {
        [captureImage setImage:straitImage.image];
        intButton=1;
        right.hidden=NO;
        top.hidden=NO;
        left.hidden=NO;
        bottom.hidden=NO;
        arrowImage.hidden=NO;
        resize.hidden=NO;
        move.text=@"Move Box";   
    }
	if(button.tag==2)
	{
		[captureImage setImage:lookdownImage.image];
		intButton=2;
        
        right.hidden=NO;
        top.hidden=NO;
        left.hidden=NO;
        bottom.hidden=NO;
        arrowImage.hidden=NO;
        resize.hidden=NO;
        move.text=@"Move Box";
	}
	if(button.tag==3)
	{
		[captureImage setImage:sideImage.image];
		intButton=3;
        right.hidden=YES;
        top.hidden=YES;
        left.hidden=YES;
        bottom.hidden=YES;
        arrowImage.hidden=YES;
        resize.hidden=YES;
        move.text=@"Move Line";
	}
    UIImage *img=nil;//[UIImage imageWithContentsOfFile:path];
	[self opencvFaceDetect:img];

    
}

-(void)dropDownCellSelected:(NSInteger)returnIndex
{
	if(a==1)
	{
		[dropdownBtn1 setTitle:[typedata1 objectAtIndex:returnIndex] forState:UIControlStateNormal];
	}
	if (a==2)
	{
		[dropdownBtn2 setTitle:[typedata2 objectAtIndex:returnIndex] forState:UIControlStateNormal];
	}
	if(a==3)
	{
		[dropdownBtn3 setTitle:[typedata3 objectAtIndex:returnIndex] forState:UIControlStateNormal];
	}
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
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image1 {
	CGImageRef imageRef = image1.CGImage;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	IplImage *iplimage = cvCreateImage(cvSize(image1.size.width, image1.size.height), IPL_DEPTH_8U, 4);
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
													iplimage->depth, iplimage->widthStep,
													colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, image1.size.width, image1.size.height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
	
	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);

	cvCvtColor(iplimage, ret, CV_RGBA2BGR);
	cvReleaseImage(&iplimage);
	
	return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image1 
{
	NSLog(@"IplImage (%d, %d) %d bits by %d channels, %d bytes/row %s", image1->width, image1->height, image1->depth, image1->nChannels, image1->widthStep, image1->channelSeq);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSData *data = [NSData dataWithBytes:image1->imageData length:image1->imageSize];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
	CGImageRef imageRef = CGImageCreate(image1->width, image1->height,
										image1->depth, image1->depth * image1->nChannels, image1->widthStep,
										colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
										provider, NULL, false, kCGRenderingIntentDefault);
	UIImage *ret = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	return ret;
}


- (void) opencvFaceDetect:(UIImage *)overlayImage  {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"1");
	if(captureImage.image) {
		cvSetErrMode(CV_ErrModeParent);
		
		IplImage *image2 = [self CreateIplImageFromUIImage:captureImage.image];
        
		UIImage* image3 = [self UIImageFromIplImage:image2];
		
		NSLog(@"2");	
		// Scaling down
		IplImage *small_image = cvCreateImage(cvSize(image2->width/2,image2->height/2), IPL_DEPTH_8U, 3);
		cvPyrDown(image2, small_image, CV_GAUSSIAN_5x5);
		int scale = 2;
		NSLog(@"3");
		// Load XML
		//NSString *path=[[NSBundle mainBundle] pathForResource:@"1" ofType:@"xml"];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_eye_tree_eyeglasses" ofType:@"xml"];
		CvHaarClassifierCascade* cascade = (CvHaarClassifierCascade*)cvLoad([path cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL, NULL);
		//CvHaarClassifierCascade* cascade1= (CvHaarClassifierCascade*)cvLoad([path1 cStringUsingEncoding:NSASCIIStringEncoding], NULL, NULL,NULL);
		CvMemStorage* storage = cvCreateMemStorage(0);
		NSLog(@"4");
		// Detect faces and draw rectangle on them
		//		CvSeq* faces = cvHaarDetectObjects(small_image, cascade, storage, 1.2f, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize(0,0), cvSize(20, 20));
		CvSeq* faces = cvHaarDetectObjects(small_image, cascade, storage, 1.2f, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize(0,0), cvSize(20,20));
		
		//	CvSeq* results = cvHoughCircles(small_image, storage , CV_HOUGH_GRADIENT , 2 , small_image->height/3,100,300,0,0 );
		NSLog(@"5");
		cvReleaseImage(&small_image);
		
		// Create canvas to show the results
		CGImageRef imageRef = captureImage.image.CGImage;
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef contextRef = CGBitmapContextCreate(NULL, captureImage.image.size.width, captureImage.image.size.height,
														8, captureImage.image.size.width * 4,
														colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
		CGContextDrawImage(contextRef, CGRectMake(0, 0, captureImage.image.size.width, captureImage.image.size.height), imageRef);
		
		CGContextSetLineWidth(contextRef, 4);
		CGContextSetRGBStrokeColor(contextRef, 0.0, 0.0, 1.0, 0.5);
        
        
        CGContextRef contextRef1 = CGBitmapContextCreate(NULL, captureImage.image.size.width, captureImage.image.size.height,
														8, captureImage.image.size.width * 4,
														colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
		CGContextDrawImage(contextRef1, CGRectMake(0, 0, captureImage.image.size.width, captureImage.image.size.height), imageRef);
		
		CGContextSetLineWidth(contextRef1, 4);
		CGContextSetRGBStrokeColor(contextRef1,1.0, 0.0, 0.0, 1.0);
        
		
		NSLog(@"6");
		
		CGRect face_rect;
        
        if(intButton==3)
        {
            CGRect face_rect1 = CGContextConvertRectToDeviceSpace(contextRef,CGRectMake(0, storeImageData+boxY,captureImage.image.size.width,2));
            CGRect face_rect2=CGContextConvertRectToDeviceSpace(contextRef,CGRectMake(100+boxX,0,2,captureImage.image.size.height));
            //  CGContextDrawImage(contextRef, face_rect, overlayImage.CGImage);
            CGContextStrokeRect(contextRef, face_rect1);
            CGContextStrokeRect(contextRef, face_rect2);
        }
        else
        {
        
            for(int i = 0; i<faces->total; i++) 
            {
			
			
                NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
			
			
                CvRect cvrect = *(CvRect*)cvGetSeqElem(faces, i);
		//	CGRect face_rect = CGContextConvertRectToDeviceSpace(contextRef, CGRectMake((cvrect.x * scale)-20 , (cvrect.y * scale)-5  , cvrect.width * scale +40 , cvrect.height * scale +10));
            
                face_rect = CGContextConvertRectToDeviceSpace(contextRef, CGRectMake((cvrect.x * scale)+boxX,( cvrect.y * scale)+boxY  ,( cvrect.width *scale)+boxWeidth, (cvrect.height * scale)+boxHeight));
               CGRect face_rect1 = CGContextConvertRectToDeviceSpace(contextRef1, CGRectMake((cvrect.x * scale) + (cvrect.width * scale)/2,( cvrect.y * scale)+(cvrect.height *scale)/2  ,20,2));
                if(intButton==1)
                {
                    storeImageData=(cvrect.y *scale )+(cvrect.height * scale)/2;
                }
         
                if(overlayImage)
                {
                    CGContextDrawImage(contextRef, face_rect, overlayImage.CGImage);
				/*
				 if((cvrect.x * scale) < 150)
				 {
				 image1=[[UIImageView alloc]initWithFrame:CGRectMake(cvrect.x*1, cvrect.y*1.5, cvrect.y*1.5, cvrect.height*2)];
				 image1.contentMode=UIViewContentModeScaleToFill;
				 image1.image=[UIImage imageNamed:@"spect1.png"];
				 [self.view addSubview:image1];
				 }
				 else
				 {
				 image1=[[UIImageView alloc]initWithFrame:CGRectMake((cvrect.x*2.5 - cvrect.y*scale)  , cvrect.y*2.5, cvrect.y*2.5, cvrect.height*2)];
				 image1.contentMode=UIViewContentModeScaleToFill;
				 image1.image=[UIImage imageNamed:@"spect1.png"];
				 [self.view addSubview:image1];
				 
				 }*/
				
                } 
                else {
				
                    CGContextStrokeRect(contextRef, face_rect);
                    CGContextStrokeRect(contextRef1, face_rect1);
                    //cvCircle(image, cvPoint(100,100), 20, cvScalar(0,200,0,0), 1,0,0);
                    NSLog(@"7");
                }
			
			[pool release];
            }
        }
		/////////////***********************************////////
       
		//captureImage.image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(contextRef)];
		captureImage.image = image3;

       // captureImage.image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(contextRef1)];
		CGContextRelease(contextRef);
		CGColorSpaceRelease(colorSpace);
		
		cvReleaseMemStorage(&storage);
		cvReleaseHaarClassifierCascade(&cascade);
		
		//[self hideProgressIndicator];
	}
	
	[pool release];
}
-(IBAction)MoveBoxErrow:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if(btn.tag==0)
    {
        boxX-=1;
        NSLog(@"0");
    }
    else if(btn.tag==1)
    {
        boxX+=1;
                NSLog(@"1");
    }
    else if(btn.tag==2)
    {
        boxY-=1;
                NSLog(@"2");
    }
    else if(btn.tag==3)
    {
        boxY+=1;
                NSLog(@"3");
    }
    else if(btn.tag==4)
    {
        boxX-=1;
        boxWeidth+=1;
    }
    else if(btn.tag==5)
    {
        boxY-=1;
        boxHeight+=1;
        
    }
    else if(btn.tag==6)
    {
        boxWeidth+=1;
    }
    else
    {
        boxHeight+=1;
    }
    
    if(intButton==1)
    {
        captureImage.image=image; 
    }
    if(intButton ==2)
    {
        captureImage.image=image_1;
    }
    if(intButton == 3)
    {
        captureImage.image=image_2;
    }
    UIImage *img=nil;//[UIImage imageWithContentsOfFile:path];
	[self opencvFaceDetect:img];

}

@end
