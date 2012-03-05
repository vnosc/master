//
//  OpenCVTesting.m
//  CyberImaging
//
//  Created by Troy Potts on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OpenCVTesting.h"
#import "CaptureOverview.h"
#import <QuartzCore/QuartzCore.h>

#import "UIImage+OpenCV.h"

#define CONTOUR std::vector<cv::Point>
#define CONTOUR_LIST std::vector< CONTOUR >

extern ServiceObject* mobileSessionXML;

extern NSArray* patientImages;

const int kaperture = 7;

// Name of face cascade resource file without xml extension
NSString * const kFaceCascadeFilename = @"haarcascade_frontalface_alt2";
//NSString * const kFaceCascadeFilename = @"haarcascade_righteye_2splits";

// Name of eye cascade resource file without xml extension
//NSString * const kEyeCascadeFilename = @"haarcascade_mcs_righteye";
NSString * const kEyeCascadeFilename = @"haarcascade_eye_tree_eyeglasses";

// Options for cv::CascadeClassifier::detectMultiScale

const int kFaceHaarOptions =  CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH;
const int kEyeHaarOptions = 0;

@interface OpenCVTesting ()
{
	cv::Mat _cannyMat;
	cv::CascadeClassifier _faceCascade;
	cv::CascadeClassifier _eyeCascade;
    
    std::vector <std::vector<cv::Point> > contours;
}

- (CONTOUR_LIST) filterContours:(CONTOUR_LIST)cons;
- (BOOL) checkContourValidity:(std::vector<cv::Point>) contour;
- (void) loadCascade:(cv::CascadeClassifier&)cascade filename:(NSString *)fn;

@end

@implementation OpenCVTesting

@synthesize focusPoint;
@synthesize labelSize;
@synthesize propertySV;

@synthesize imageView;
@synthesize drawView;
@synthesize lowSlider;
@synthesize highSlider;
@synthesize lowSliderLabel;
@synthesize highSliderLabel;
@synthesize maxCornersSlider;
@synthesize qualityLevelSlider;
@synthesize minDistanceSlider;
@synthesize maxCornersLabel;
@synthesize qualityLevelLabel;
@synthesize minDistanceLabel;
@synthesize apertureSegment;
@synthesize labelSwitch;
@synthesize blurTypeSegment;
@synthesize morphTypeSegment;
@synthesize morphIterSlider;
@synthesize morphIterLabel;
@synthesize threshSlider;
@synthesize threshLabel;
@synthesize labelSizeLabel;
@synthesize labelSizeSlider;
@synthesize houghCircleDPSlider;
@synthesize houghCircleMinDistSlider;
@synthesize houghCircleCannySlider;
@synthesize houghCircleAccumulatorSlider;

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
	
    self.labelSize = 100;
    
	[self loadPatientImages];
	
	self.apertureSegment.selectedSegmentIndex = 1;
	
	self.propertySV.contentSize = CGSizeMake(5000,self.propertySV.frame.size.height);
	[self.view addSubview:self.propertySV];
	
	NSLog(@"images %@", patientImages);
	[self setBaseImageFromPatient];
	
	[self loadCascade:_faceCascade filename:kFaceCascadeFilename];
	[self loadCascade:_eyeCascade filename:kEyeCascadeFilename];
	
    // Do any additional setup after loading the view from its nib.
}

- (void) setBaseImageFromPatient
{
	NSLog(@"---- REVERTED IMAGE ----");
	
	id img = [patientImages objectAtIndex:0];
	if (img != [NSNull null])
	{
		_baseImage = img;
        [self revertImage];
	}    
}
- (void) revertImage
{
	NSLog(@"---- REVERTED IMAGE ----");

    self.imageView.image = _baseImage;
		
    [self.imageView.layer setMagnificationFilter:kCAFilterNearest];
}

- (void) recoverImage
{
	NSLog(@"- RECOVERED IMAGE -");
	
	self.imageView.image = _baseImage;
	
	[self.imageView.layer setMagnificationFilter:kCAFilterNearest];
}

- (void) storeImage
{
	NSLog(@"- STORED IMAGE -");
	
	_baseImage = [self.imageView.image retain];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *t = [touches anyObject];
	CGPoint p = [t locationInView:self.imageView];
	
	if ([labelSwitch isOn])
	{
		//CGPoint p2 = [t locationInView:self.view];
		
		//CGPoint p = CGPointMake(p2.x - self.imageView.bounds.origin.x, p2.y - self.imageView.bounds.origin.y);
		
        int dist = self.labelSize / 2;
		CGRect r = CGRectMake(p.x - dist, p.y - dist, dist, dist);
		
		[self drawFakeLabelAt:r];
	}
	else
	{
		self.focusPoint = p; 
		NSLog(@"Focus point set to %f,%f", p.x, p.y);
	}
}

- (void) loadCascade:(cv::CascadeClassifier&)cascade filename:(NSString *)fn
{
	NSLog(@"test?");
    // Load the Haar cascade from resources
    NSString *cascadePath = [[NSBundle mainBundle] pathForResource:fn ofType:@"xml"];
    
    if (!cascade.load([cascadePath UTF8String])) {
        NSLog(@"Could not load cascade: %@", cascadePath);
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
		
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[ServiceObject urlOfWebPage:[NSString stringWithFormat:@"ShowPatientImage.aspx?patientId=%d&type=%@&ignore=true", patientId, suffix]]]];
		UIImage *uiimg = [[UIImage imageWithData:imageData] retain];
		id img = uiimg ? uiimg : [NSNull null];
		
		[mi addObject:img];
		
		cnt++;
	}
	
	patientImages = [[NSArray arrayWithArray:mi] retain];
	
}

- (void) drawFakeLabelAt:(CGRect)r
{
	UIGraphicsBeginImageContext(self.imageView.image.size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *white = [UIColor whiteColor];
	[white setStroke];
	[white setFill];
	//CGContextDrawImage(context, CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height), self.imageView.image.CGImage);
	[self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)];
	CGContextFillRect(context, r);
	
	UIImage *retImg = UIGraphicsGetImageFromCurrentImageContext();
	
	//_baseImage = [retImg retain];
	
	self.imageView.image = retImg;
}

- (void)doGaussianBlur
{
	NSLog(@"doin' gaussian blur");
	cv::Mat eyeMat = [self.imageView.image CVMat];
	cv::Mat eyeMatOut;
	
	//cv::equalizeHist(eyeMat, eyeMat);
	
	int blurType = self.blurTypeSegment.selectedSegmentIndex;
	
	switch (blurType)
	{
		case 0:
			cv::blur(eyeMat, eyeMatOut, cv::Size(5,5));
			break;
		case 1:
			cv::medianBlur(eyeMat, eyeMatOut, 5);
			break;
		case 2:
			cv::GaussianBlur(eyeMat, eyeMatOut, cv::Size(5,5), 0);		
			break;
	}
	
	UIImage* tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	self.imageView.image = tempImage;
}

- (void)doSobel
{
	NSLog(@"doin' sobel");
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	//cv::Mat eyeMat = [_baseImage CVMat];
	cv::Mat eyeMatOut;
	
	cv::equalizeHist(eyeMat, eyeMat);

	cv::Sobel(eyeMat, eyeMatOut, eyeMat.depth(), 1,0);
	
	UIImage *tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	self.imageView.image = tempImage;
}

- (void)doLaplace
{
	NSLog(@"doin' laplace");
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	//cv::Mat eyeMat = [_baseImage CVMat];
	cv::Mat eyeMatOut;
	
	cv::equalizeHist(eyeMat, eyeMat);
	
	cv::Laplacian(eyeMat, eyeMatOut, eyeMat.depth());
	
	UIImage *tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	self.imageView.image = tempImage;
}

- (void)doCanny
{
	NSLog(@"doin' canny");
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	cv::Mat eyeMatOut;
	
	//cv::equalizeHist(eyeMat, eyeMat);
	
	float lsv = self.lowSlider.value;
	float hsv = self.highSlider.value;
	
	int aperture = [[self.apertureSegment titleForSegmentAtIndex:[self.apertureSegment selectedSegmentIndex]] intValue];
	
	// Perform Canny edge detection using slide values for thresholds
	cv::Canny(eyeMat, eyeMatOut,
			  lsv * aperture * aperture,
			  hsv * aperture * aperture,
			  aperture);
	
	
	
	//cv::dilate(eyeMatOut, eyeMatOut, nil);
	UIImage *tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	//_cannyMat = eyeMatOut;
	
	self.imageView.image = tempImage;
}

- (void)doHarris
{
	NSLog(@"doin' harris");
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	cv::Mat eyeMatOut;
	
	cv::equalizeHist(eyeMat, eyeMat);
	
	int aperture = [[self.apertureSegment titleForSegmentAtIndex:[self.apertureSegment selectedSegmentIndex]] intValue];
	
	// Perform Canny edge detection using slide values for thresholds
	cv::cornerHarris(eyeMat, eyeMatOut, 3, aperture, 0.04);

	UIImage* tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	self.imageView.image = tempImage;
}

- (void)doCircleHough
{
	NSLog(@"doin' circular hough");
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	cv::Mat eyeMatOut;

	UIImage *tempImage = [UIImage imageWithCVMat:eyeMat];
	
	CGContextRef ctx;
	
	if (focusPoint.x > 0 && focusPoint.y > 0)
	{
		UIGraphicsBeginImageContext(CGSizeMake(240,320));
		ctx = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
		[tempImage drawAtPoint:CGPointMake(-focusPoint.x, -focusPoint.y)];
	}
	else
	{
		UIGraphicsBeginImageContext(tempImage.size);
		ctx = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
		[tempImage drawAtPoint:CGPointZero];			
	}
	
	tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    std::vector<cv::Vec3f> circles;
    
    valDP = (double) self.houghCircleDPSlider.value;
    valMinDist = (double) self.houghCircleMinDistSlider.value;
    valCanny = (double) self.houghCircleCannySlider.value;
    valAccumulator = (double) self.houghCircleAccumulatorSlider.value;
    
    NSLog(@"dp: %e   minDist: %e   canny: %e   accumulator: %e", valDP, valMinDist, valCanny, valAccumulator);
    
    cv::HoughCircles(eyeMat, circles, CV_HOUGH_GRADIENT, valDP, valMinDist, valCanny, valAccumulator, 10, 30);
    //cv::HoughCircles(eyeMat, circles, CV_HOUGH_GRADIENT, 2, 1, 300, 50, 0, 0);
    
    [[UIColor blueColor] setStroke];
    for (int i; i < circles.size(); i++)
    {
        float x = circles[i][0];
        float y = circles[i][1];
        float radius = circles[i][2];
        CGContextStrokeEllipseInRect(ctx, CGRectMake(x-radius, y-radius, radius*2, radius*2));
        NSLog(@"%f, %f, %f", x, y, radius);
	}
    
    UIImage *imageWithCircles = UIGraphicsGetImageFromCurrentImageContext();
    self.imageView.image = imageWithCircles;
    UIGraphicsEndImageContext();
}

- (void)doEigen
{
	NSLog(@"doin' eigen");
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	cv::Mat eyeMatOut = cv::Mat(eyeMat.rows, eyeMat.cols, CV_32FC4);
	
	//cv::equalizeHist(eyeMat, eyeMat);
	
	int aperture = [[self.apertureSegment titleForSegmentAtIndex:[self.apertureSegment selectedSegmentIndex]] intValue];
	
	// Perform Canny edge detection using slide values for thresholds
	/*cv::Canny(eyeMat, eyeMatOut,
			  lsv * aperture * aperture,
			  hsv * aperture * aperture,
			  aperture);*/

	cv::cornerEigenValsAndVecs(eyeMat, eyeMatOut, 32, aperture);
	
	
	UIImage* tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	
	self.imageView.image = tempImage;
}

- (void)doThresh
{
	NSLog(@"doin' thresh");
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	cv::Mat eyeMatOut;
	
	cv::equalizeHist(eyeMat, eyeMat);

	cv::threshold(eyeMat, eyeMatOut, (int) self.threshSlider.value, 255, cv::THRESH_BINARY);
	
	UIImage* tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	self.imageView.image = tempImage;
}

- (void)doPyrMeanShiftFilter 
{
	NSLog(@"doin' pyramid mean shift filter");
	//cv::Mat eyeMat = [_baseImage CVGrayscaleMat];
	cv::Mat eyeMat = [self.imageView.image CVMat];
	cv::cvtColor(eyeMat, eyeMat, CV_RGBA2RGB);
	cv::Mat eyeMatOut;

	cv::pyrMeanShiftFiltering(eyeMat, eyeMatOut, 3, 5);

	UIImage* tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	self.imageView.image = tempImage;
	
	NSLog(@"done");
}

- (void)doCvBlobDetect
{
	//cv::bitwise_and
}

- (void)doContours
{
	std::vector<cv::Vec4i> hier;
	
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
    _baseContourImage = [[UIImage imageWithCVMat:eyeMat] retain];
    
	//cv::Mat eyeMat = [_baseImage CVGrayscaleMat];
	//cv::Mat eyeMat = [_baseImage CVMat];
	cv::Mat eyeMatOut;
	
	//eyeMat = [tempImage CVGrayscaleMat];
	
	//cv::threshold(eyeMat, eyeMat, 100, 255, cv::THRESH_BINARY);
	//eyeMat = [tempImage CVMat];
	
	NSLog(@"doin' contours");

	cv::findContours(eyeMat, contours, hier, CV_RETR_LIST, CV_CHAIN_APPROX_TC89_L1);
    
    
	NSLog(@"contours: %d", (int) contours.size());
	
    /*int biggestContourIdx = 0;
	for (int i = 0; i < contours.size(); i++)
	{
        if (contours[i].size() > contours[biggestContourIdx].size())
            biggestContourIdx = i;
    }
    
    cIdx = biggestContourIdx;
    
    [self drawContour:biggestContourIdx];*/
    
    contours = [self filterContours:contours];
    
    [self drawContours:contours];
    
}

- (void) drawContour:(int)contourIdx
{
	
	CGContextRef ctx;
	
    UIImage *tempImage = _baseContourImage;
    //UIImage *tempImage = _baseImage;
    
    float offsetX = 0;
    float offsetY = 0;
    
	if (focusPoint.x > 0 && focusPoint.y > 0)
	{
		UIGraphicsBeginImageContext(CGSizeMake(240,320));
		ctx = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
		[tempImage drawAtPoint:CGPointMake(-focusPoint.x, -focusPoint.y)];
        
        offsetX = -focusPoint.x;
        offsetY = -focusPoint.y;
	}
	else
	{
		UIGraphicsBeginImageContext(tempImage.size);
		ctx = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
		[tempImage drawAtPoint:CGPointZero];			
	}
    
    std::vector<cv::Point> contour = contours[contourIdx];
    
    int csize = contour.size();
    NSLog(@"biggest contour details: size %d, first %d,%d, last %d,%d", csize, contour[0].x, contour[0].y, contour[csize-1].x, contour[csize-1].y );
    
    [[UIColor greenColor] setStroke];
    CGContextMoveToPoint(ctx, contour[0].x + offsetX, contour[0].y + offsetY);
    for (int j = 1; j < csize; j++)
    {
		CGContextAddLineToPoint(ctx, contour[j].x + offsetX, contour[j].y + offsetY);
	}
	
	CGContextClosePath(ctx);
	CGContextStrokePath(ctx);
	
	/*for (int i = 0; i < corners.size(); i++)
	{
		cv::Point2d corner = corners[i];
		CGRect circleRect = CGRectMake(corner.x - 2, corner.y - 2, 4, 4);
		//circleRect = CGRectInset(circleRect, 5, 5);
		CGContextStrokeEllipseInRect(ctx, circleRect);
	}*/
    
    //cv::moments([imageWithContours CVMat]);

    //double contourArea = cv::contourArea(contour);
    //NSLog(@"contour area: %f", contourArea);
    
    //float contourAreaInMM = powf([self transformPixelsToRealDistance:sqrt(contourArea)], 2);
    //NSLog(@"contour area in mm: %f", contourAreaInMM);
    std::vector<cv::Point> approxPoly;
    
    cv::approxPolyDP(contour, approxPoly, 5, YES);
    
    int psize = approxPoly.size();
    
    [[UIColor blueColor] setStroke];
    for (int j = 0; j < psize; j++)
    {
        CGContextStrokeRect(ctx, CGRectMake(approxPoly[j].x + offsetX, approxPoly[j].y + offsetY, 3, 3));
	}
    
    UIImage *imageWithContours = UIGraphicsGetImageFromCurrentImageContext();
    self.imageView.image = imageWithContours;
    UIGraphicsEndImageContext();
}

- (void) drawContours:(std::vector< std::vector<cv::Point> >)cons
{
	
	CGContextRef ctx;
	
    UIImage *tempImage = self.imageView.image;
    //UIImage *tempImage = _baseImage;
    
    float offsetX = 0;
    float offsetY = 0;
    
	if (focusPoint.x > 0 && focusPoint.y > 0)
	{
		UIGraphicsBeginImageContext(CGSizeMake(240,320));
		ctx = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
		[tempImage drawAtPoint:CGPointMake(-focusPoint.x, -focusPoint.y)];
        
        offsetX = -focusPoint.x;
        offsetY = -focusPoint.y;
	}
	else
	{
		UIGraphicsBeginImageContext(tempImage.size);
		ctx = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
		[tempImage drawAtPoint:CGPointZero];			
	}
    
    CONTOUR lastContour;
    
    for (int i=0; i < cons.size(); i++)
    {
        std::vector<cv::Point> contour = cons[i];
        
        int csize = contour.size();
        
        if (lastContour.size() != 0)
        {
            [[UIColor redColor] setStroke];
            cv::RotatedRect lastrrect = cv::fitEllipse(lastContour);
            CGContextMoveToPoint(ctx, lastrrect.center.x + offsetX, lastrrect.center.y + offsetY);
            cv::RotatedRect rrect = cv::fitEllipse(contour);
            CGContextAddLineToPoint(ctx, rrect.center.x + offsetX, rrect.center.y + offsetY);
            CGContextClosePath(ctx);
            CGContextStrokePath(ctx);
        }
        
        [[UIColor greenColor] setStroke];
        CGContextMoveToPoint(ctx, contour[0].x + offsetX, contour[0].y + offsetY);
        for (int j = 1; j < csize; j++)
        {
            CGContextAddLineToPoint(ctx, contour[j].x + offsetX, contour[j].y + offsetY);
        }
        
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
        
        /*for (int i = 0; i < corners.size(); i++)
         {
         cv::Point2d corner = corners[i];
         CGRect circleRect = CGRectMake(corner.x - 2, corner.y - 2, 4, 4);
         //circleRect = CGRectInset(circleRect, 5, 5);
         CGContextStrokeEllipseInRect(ctx, circleRect);
         }*/
        
        //cv::moments([imageWithContours CVMat]);
        
        //double contourArea = cv::contourArea(contour);
        //NSLog(@"contour area: %f", contourArea);
        
        //float contourAreaInMM = powf([self transformPixelsToRealDistance:sqrt(contourArea)], 2);
        //NSLog(@"contour area in mm: %f", contourAreaInMM);
        std::vector<cv::Point> approxPoly;
        
        cv::approxPolyDP(contour, approxPoly, 5, YES);
        
        int psize = approxPoly.size();
        
        [[UIColor blueColor] setStroke];
        for (int j = 0; j < psize; j++)
        {
            CGContextStrokeRect(ctx, CGRectMake(approxPoly[j].x - 1 + offsetX, approxPoly[j].y - 1 + offsetY, 3, 3));
        }
        
        lastContour = contour;
    }
    
    UIImage *imageWithContours = UIGraphicsGetImageFromCurrentImageContext();
    self.imageView.image = imageWithContours;
    UIGraphicsEndImageContext();
}

- (void)doGoodFeaturesToTrack
{
	std::vector <cv::Point2d> corners;
	
	//cv::Mat eyeMat = [tempImage CVGrayscaleMat];
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	//cv::Mat eyeMat = [_baseImage CVMat];
	cv::Mat eyeMatOut;
	
	UIImage *tempImage = [UIImage imageWithCVMat:eyeMat];
	
	CGContextRef ctx;
	
	if (focusPoint.x > 0 && focusPoint.y > 0)
	{
		UIGraphicsBeginImageContext(CGSizeMake(240,320));
		ctx = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
		[tempImage drawAtPoint:CGPointMake(-focusPoint.x, -focusPoint.y)];
	}
	else
	{
		UIGraphicsBeginImageContext(tempImage.size);
		ctx = UIGraphicsGetCurrentContext();
		CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
		[tempImage drawAtPoint:CGPointZero];			
	}
	
	tempImage = UIGraphicsGetImageFromCurrentImageContext();
	
	eyeMat = [tempImage CVGrayscaleMat];
	//eyeMat = [tempImage CVMat];
	
	float maxCorners = self.maxCornersSlider.value;
	float qualityLevel = self.qualityLevelSlider.value;
	float minDistance = self.minDistanceSlider.value;
	
	//cv::equalizeHist(eyeMat, eyeMat);

	cv::goodFeaturesToTrack(eyeMat, corners, maxCorners, qualityLevel, minDistance);
	
	NSLog(@"corners: %d", (int) corners.size());

	[[UIColor greenColor] setStroke];
	
	for (int i = 0; i < corners.size(); i++)
	{
		cv::Point2d corner = corners[i];
		CGRect circleRect = CGRectMake(corner.x - 2, corner.y - 2, 4, 4);
		//circleRect = CGRectInset(circleRect, 5, 5);
		CGContextStrokeEllipseInRect(ctx, circleRect);
	}

	self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
}

- (void)doDilate
{
	NSLog(@"doin' dilate");
	cv::Mat eyeMat;
	eyeMat = [self.imageView.image CVMat];
	
	NSLog(@"dilate matrix made");
	cv::dilate(eyeMat, eyeMat, cv::Mat());
	
	self.imageView.image = [UIImage imageWithCVMat:eyeMat];
}

- (void)doErode
{
	NSLog(@"doin' erode");
	
	cv::Mat eyeMat = [self.imageView.image CVMat];
	
	NSLog(@"erode matrix made");
	
	cv::erode(eyeMat, eyeMat, cv::Mat());
	
	self.imageView.image = [UIImage imageWithCVMat:eyeMat];
}

- (void)doMorph:(NSString*)morphName op:(int)op
{
	NSLog(@"doin' morph %@", morphName);
	
	cv::Mat eyeMat = [self.imageView.image CVMat];
	cv::Mat eyeMatOut;

	int iterations = [self.morphIterSlider value];
	cv::morphologyEx(eyeMat, eyeMatOut, op, cv::Mat(), cv::Point(-1,-1), iterations);
	
	self.imageView.image = [UIImage imageWithCVMat:eyeMatOut];
}

- (void)doEqualizeHist
{
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	
	cv::equalizeHist(eyeMat, eyeMat);
	
	self.imageView.image = [UIImage imageWithCVMat:eyeMat];	
}

- (void)doCustom
{
	NSLog(@"doin' custom filter");
	
	cv::Mat eyeMat = [self.imageView.image CVMat];
	
	//kernel.
	//cv::filter2D(eyeMat, eyeMat, <#int ddepth#>, <#InputArray kernel#>)
	
	self.imageView.image = [UIImage imageWithCVMat:eyeMat];	
}

- (float) transformPixelsToRealDistance:(float)pixels
{
    // pixels * (mm / in) / (pixels / in)
    // pixels * (mm / in) * (in / pixels)
    // (pixels * mm * in) / (pixels * in)
    // mm
    
	return pixels * 25.4 / 132.0; // in mm
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setDrawView:nil];
	[self setLowSlider:nil];
	[self setHighSlider:nil];
	[self setLowSliderLabel:nil];
	[self setHighSliderLabel:nil];
	[self setMaxCornersSlider:nil];
	[self setQualityLevelSlider:nil];
	[self setMinDistanceSlider:nil];
	[self setMaxCornersLabel:nil];
	[self setQualityLevelLabel:nil];
	[self setMinDistanceLabel:nil];
	[self setApertureSegment:nil];
	[self setLabelSwitch:nil];
	[self setPropertySV:nil];
	[self setBlurTypeSegment:nil];
	[self setMorphTypeSegment:nil];
	[self setMorphIterSlider:nil];
	[self setMorphIterLabel:nil];
	[self setThreshSlider:nil];
	[self setThreshLabel:nil];
    [self setLabelSizeLabel:nil];
    [self setLabelSizeSlider:nil];
    [self setHoughCircleDPSlider:nil];
    [self setHoughCircleMinDistSlider:nil];
    [self setHoughCircleCannySlider:nil];
    [self setHoughCircleAccumulatorSlider:nil];
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
    [imageView release];
    [drawView release];
	[lowSlider release];
	[highSlider release];
	[lowSliderLabel release];
	[highSliderLabel release];
	[maxCornersSlider release];
	[qualityLevelSlider release];
	[minDistanceSlider release];
	[maxCornersLabel release];
	[qualityLevelLabel release];
	[minDistanceLabel release];
	[apertureSegment release];
	[labelSwitch release];
	[propertySV release];
	[blurTypeSegment release];
	[morphTypeSegment release];
	[morphIterSlider release];
	[morphIterLabel release];
	[threshSlider release];
	[threshLabel release];
    [labelSizeLabel release];
    [labelSizeSlider release];
    [houghCircleDPSlider release];
    [houghCircleMinDistSlider release];
    [houghCircleCannySlider release];
    [houghCircleAccumulatorSlider release];
    [super dealloc];
}
- (IBAction)revertBtnClick:(id)sender {
	[self revertImage];
}

- (IBAction)cannyBtnClick:(id)sender {
	[self doCanny];
}

- (IBAction)cannySliderChanged:(id)sender {
	[self.lowSliderLabel setText:[NSString stringWithFormat:@"%.0f", self.lowSlider.value]];
	[self.highSliderLabel setText:[NSString stringWithFormat:@"%.0f", self.highSlider.value]];
}

- (IBAction)trackBtnClick:(id)sender {
	[self doGoodFeaturesToTrack];
}

- (IBAction)trackSliderChanged:(id)sender {
	[self.maxCornersLabel setText:[NSString stringWithFormat:@"%.0f", self.maxCornersSlider.value]];
	[self.qualityLevelLabel setText:[NSString stringWithFormat:@"%.2f", self.qualityLevelSlider.value]];
	[self.minDistanceLabel setText:[NSString stringWithFormat:@"%.0f", self.minDistanceSlider.value]];
}

- (IBAction)threshBtnClick:(id)sender {
	[self doThresh];
}

- (IBAction)pyrMeanShiftFilterBtnClick:(id)sender {
	[self doPyrMeanShiftFilter];
}

- (IBAction)harrisBtnClick:(id)sender {
	[self doHarris];
}

- (IBAction)eigenBtnClick:(id)sender {
	[self doEigen];
}

- (IBAction)contoursBtnClick:(id)sender {
	[self doContours];
}

- (IBAction)gaussianBlurBtnClick:(id)sender {
	[self doGaussianBlur];
}

- (IBAction)cvBlobDetectBtnClick:(id)sender {
}

- (IBAction)sobelBtnClick:(id)sender {
	[self doSobel];
}

- (IBAction)dilateBtnClick:(id)sender {
	[self doDilate];
}

- (IBAction)erodeBtnClick:(id)sender {
	[self doErode];
}

- (IBAction)equalizeHistBtnClick:(id)sender {
	[self doEqualizeHist];
}

- (IBAction)morphBtnClick:(id)sender {
	int morphOp = [self.morphTypeSegment selectedSegmentIndex] + 2;
	NSString* morphName = [self.morphTypeSegment titleForSegmentAtIndex:[self.morphTypeSegment selectedSegmentIndex]];
	[self doMorph:morphName op:morphOp];
}

- (IBAction)morphIterSliderChanged:(id)sender {
	[self.morphIterLabel setText:[NSString stringWithFormat:@"%.0f", self.morphIterSlider.value]];
}

- (IBAction)customBtnClick:(id)sender {
	[self doCustom];
}

- (IBAction)laplaceBtnClick:(id)sender {
	[self doLaplace];
}

- (IBAction)recoverBtnClick:(id)sender {
	[self recoverImage];
}

- (IBAction)storeBtnClick:(id)sender {
	[self storeImage];
}

- (IBAction)threshSliderChanged:(id)sender {
	[self.threshLabel setText:[NSString stringWithFormat:@"%.0f", self.threshSlider.value]];
}

- (IBAction)detectPupilClick:(id)sender {
	/*std::vector <cv::Point2d> corners;
	
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	cv::Mat eyeMatCanny;
	
	cv::equalizeHist(eyeMat, eyeMat);
	
	// Perform Canny edge detection using slide values for thresholds
	cv::Canny(eyeMat, eyeMatCanny,
			  self.lowSlider.value * kCannyAperture * kCannyAperture,
			  self.highSlider.value * kCannyAperture * kCannyAperture,
			  kCannyAperture);
	
	cv::goodFeaturesToTrack(eyeMat, corners, 5, 0.5, 20);*/
	
	std::vector<cv::Rect> eyes;
	
	cv::Mat mat = [self.imageView.image CVGrayscaleMat];
	
	_eyeCascade.detectMultiScale(mat, eyes, 1.2, 0, kEyeHaarOptions, cv::Size(1, 1));
	//_eyeCascade.detectMultiScale(<#const cv::Mat &image#>, <#vector<Rect> &objects#>, <#vector<int> &rejectLevels#>, <#vector<double> &levelWeights#>)
	
	// -------------
	
	UIGraphicsBeginImageContext(self.imageView.image.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIImage *tempImage = self.imageView.image;
	[tempImage drawAtPoint:CGPointZero];
	
	//cv::equalizeHist(eyeMat, eyeMat);
	
	[[UIColor greenColor] setStroke];
	
	
	for (int i = 0; i < eyes.size(); i++)
	{
		cv::Rect r = eyes[i];
		NSLog(@"eye at %d,%d size %d,%d", r.x, r.y, r.width, r.height);
		CGRect circleRect = CGRectMake(r.x - 2 + r.width / 2, r.y - 2 + r.height / 2, 4, 4);
		//circleRect = CGRectInset(circleRect, 5, 5);
		CGContextStrokeEllipseInRect(ctx, circleRect);
	}
	
	self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//return eyes;
}

- (IBAction)labelSizeSliderChanged:(id)sender {
    self.labelSize = (int) self.labelSizeSlider.value;
    [self.labelSizeLabel setText:[NSString stringWithFormat:@"%d", self.labelSize]];
}

- (IBAction)houghCirclesBtnClick:(id)sender {
    [self doCircleHough];
}

- (IBAction)nextContourBtnClick:(id)sender {
    int checkedContours = 0;
    
    CONTOUR_LIST filteredContours = [self filterContours:contours];
    
    [self drawContours:filteredContours];
    
    while (checkedContours < contours.size())
    {
        cIdx = cIdx + 1;
        if (cIdx == contours.size())
            cIdx = 0;
        
        int thing = cIdx;
        checkedContours++;
        
        BOOL validContour = [self checkContourValidity:contours[thing]];
        
        //cv::RotatedRect rect = cv::fitEllipse(contours[thing]);
        //cv::appro
        if (validContour)
        {
            [self drawContour:thing];
            break;
        }
    }
}

- (IBAction)drawLaserCandidatesBtnClick:(id)sender {
    [self drawContours:contours];
}

- (IBAction)changeImageBtnClick:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:pc];
    [popover presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (CONTOUR_LIST) filterContours:(CONTOUR_LIST)cons
{
    CONTOUR_LIST filteredContours;
    
    for (int i=0; i < cons.size(); i++)
    {
        std::vector <cv::Point> contour = cons[i];
        
        if ([self checkContourValidity:contour])
            filteredContours.push_back(contour);
    }
    
    return filteredContours;
}

- (BOOL) checkContourValidity:(std::vector<cv::Point>) contour
{
    float contourArea = powf([self transformPixelsToRealDistance:sqrt(cv::contourArea(contour))], 2);
    BOOL validArea = contourArea > 2 && contourArea < 6;
    
    if (!validArea) return NO;
    
    // cv::Rect rect = cv::boundingRect(contours[thing]);
    cv::RotatedRect rrect = cv::fitEllipse(contour);
    float widthMM = [self transformPixelsToRealDistance:rrect.size.width];
    float heightMM = [self transformPixelsToRealDistance:rrect.size.height];
    float rectRatio = widthMM / heightMM;
    
    BOOL validDimensions = rectRatio > 0.7 && rectRatio < 1.3;
    
    BOOL validContour = validArea && validDimensions;
    
    NSLog(@"contour idx: %d / %lu - area: %f, dimensions: %f x %f, dimension ratio %f - %d ", cIdx, contours.size(), contourArea, widthMM, heightMM, rectRatio, validContour);
    
    return validContour;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = [image retain];
    _baseImage = image;
}
@end
