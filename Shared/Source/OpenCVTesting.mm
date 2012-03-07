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
NSString * const kEyeCascadeFilename = @"haarcascade_eye_tree_eyeglasses";
NSString * const kEyeCascadeRFilename = @"ojoD";
NSString * const kEyeCascadeLFilename = @"ojoI";


// Options for cv::CascadeClassifier::detectMultiScale

const int kFaceHaarOptions =  CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH;
const int kEyeHaarOptions = 0;

class PointGroup
{
public:
    std::vector <cv::Point> points;
    cv::Rect boundingRect;
    float tolerance;
    
    bool pointIsTolerated(cv::Point point)
    {       
        bool isTolerated = true;
        isTolerated = isTolerated && (point.x > (boundingRect.x - tolerance));
        isTolerated = isTolerated && (point.x < (boundingRect.x + boundingRect.width + tolerance));
        isTolerated = isTolerated && (point.y > (boundingRect.y - tolerance));
        isTolerated = isTolerated && (point.y < (boundingRect.y + boundingRect.height + tolerance));
        return isTolerated;
    }
    
    void addPoint(cv::Point point)
    {
        if (std::find(points.begin(), points.end(), point) == points.end())
        {
            this->points.push_back(point);
            NSLog(@"number of points: %lu", points.size());
            this->boundingRect = cv::boundingRect(this->points);
            NSLog(@"bounding rect: %d,%d,%d,%d", boundingRect.x, boundingRect.y, boundingRect.width, boundingRect.height);
            //if (tolerance > 0)
            //    tolerance -= 1;
        }
        else
            NSLog(@"ignoring point, it was found");
    }
    
    cv::Point center()
    {
        cv::Point c;
        c.x = boundingRect.x + (boundingRect.width / 2);
        c.y = boundingRect.y + (boundingRect.height / 2);
        return c;
    }
};

@interface OpenCVTesting ()
{
	cv::Mat _cannyMat;
	cv::CascadeClassifier _faceCascade;
	cv::CascadeClassifier _eyeCascade;
    cv::CascadeClassifier _eyeCascadeR;
    cv::CascadeClassifier _eyeCascadeL;
    
    std::vector <std::vector<cv::Point> > contours;
}

- (CONTOUR_LIST) filterContours:(CONTOUR_LIST)cons;
- (CONTOUR_LIST) filterContourRelations:(CONTOUR_LIST)cons;
- (void) loadCascade:(cv::CascadeClassifier&)cascade filename:(NSString *)fn;
- (BOOL) checkContourValidity:(std::vector<cv::Point>) contour idx:(int)idx;
- (float) getRealDistanceBetweenContour:(CONTOUR)contour1 andContour:(CONTOUR)contour2;

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
	[self setBaseImageFromPatient:0];
	
	[self loadCascade:_faceCascade filename:kFaceCascadeFilename];
	[self loadCascade:_eyeCascade filename:kEyeCascadeFilename];
    [self loadCascade:_eyeCascadeR filename:kEyeCascadeRFilename];
    [self loadCascade:_eyeCascadeL filename:kEyeCascadeLFilename];
	
    // Do any additional setup after loading the view from its nib.
}

- (void) setBaseImageFromPatient:(int)idx
{
	NSLog(@"---- REVERTED IMAGE ----");
	
	id img = [patientImages objectAtIndex:idx];
	if (img != [NSNull null])
	{
		_baseImage = img;
        _firstImage = img;
        [self revertImage];
	}    
}
- (void) revertImage
{
	NSLog(@"---- REVERTED IMAGE ----");

    self.imageView.image = _firstImage;
		
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

- (UIImage*)doGaussianBlur:(UIImage*)inputImg type:(int)blurType
{
	NSLog(@"doin' gaussian blur");
	cv::Mat eyeMat = [inputImg CVMat];
	cv::Mat eyeMatOut;
	
	//cv::equalizeHist(eyeMat, eyeMat);
	
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
	
    return tempImage;
}

- (UIImage*)doSobel:(UIImage*)inputImg dx:(int)dx dy:(int)dy
{
	NSLog(@"doin' sobel");
	cv::Mat eyeMat = [inputImg CVGrayscaleMat];
	cv::Mat eyeMatOut;
	
	cv::equalizeHist(eyeMat, eyeMat);

	cv::Sobel(eyeMat, eyeMatOut, eyeMat.depth(), dx,dy);
	
    return [UIImage imageWithCVMat:eyeMatOut];
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

- (UIImage*)doThresh:(UIImage*)inputImg threshold:(int)threshold
{
	NSLog(@"doin' thresh - %d", threshold);
	cv::Mat eyeMat = [inputImg CVGrayscaleMat];
	cv::Mat eyeMatOut;
	
	//cv::equalizeHist(eyeMat, eyeMat);

	cv::threshold(eyeMat, eyeMatOut, threshold, 255, cv::THRESH_BINARY);
    
    return [UIImage imageWithCVMat:eyeMatOut];
}

- (void)doAdaptiveThresh
{
	NSLog(@"doin' adaptive thresh");
	cv::Mat eyeMat = [self.imageView.image CVGrayscaleMat];
	cv::Mat eyeMatOut;
	
	cv::equalizeHist(eyeMat, eyeMat);
   
    int adaptiveMethod = 0;
    
    int blurType = self.blurTypeSegment.selectedSegmentIndex;
	
	switch (blurType)
	{
		case 0:
            adaptiveMethod = cv::ADAPTIVE_THRESH_MEAN_C;
			break;
		case 2:
            adaptiveMethod = cv::ADAPTIVE_THRESH_GAUSSIAN_C;
			break;
	}
    
    cv::adaptiveThreshold(eyeMat, eyeMatOut, 255, adaptiveMethod, cv::THRESH_BINARY, 41, 0);
	
	UIImage* tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	self.imageView.image = tempImage;
}

- (UIImage*)doMixRed:(UIImage*)inputImg
{
    NSLog(@"doin' mix red");
    
    UIImage* tempImage = [self getImageFrom:inputImg channel:0];
	
    return tempImage;
}

- (UIImage*)doMixGreen:(UIImage*)inputImg
{
    NSLog(@"doin' mix green");
    
    UIImage* tempImage = [self getImageFrom:inputImg channel:1];
	
    return tempImage;
}

- (UIImage*)doMixBlue:(UIImage*)inputImg
{
    NSLog(@"doin' mix blue");
    
    UIImage* tempImage = [self getImageFrom:inputImg channel:2];
	
    return tempImage;
}

- (UIImage*)doDampenGreenBlue:(UIImage*)inputImg
{
    NSLog(@"doin' green+blue dampen");
    
    cv::Mat eyeMat = [inputImg CVMat];
    cv::Mat eyeMatOut;
    
    std::vector<cv::Mat> channels;
    cv::split(eyeMat, channels);
    
    cv::Mat eyeMatRed = channels[0];
    cv::Mat eyeMatGreen = channels[1];
    cv::Mat eyeMatBlue = channels[2];
    
    cv::addWeighted(eyeMatGreen, -0.9, eyeMatRed, 1.0, 0, eyeMatRed);
    
    cv::addWeighted(eyeMatBlue, -0.9, eyeMatRed, 1.0, 0, eyeMatRed);
    
    cv::merge(channels, eyeMatOut);
    
    return [UIImage imageWithCVMat:eyeMatOut];
}

- (void)doNormalize
{
    NSLog(@"doin' normalize");

    cv::Mat eyeMat = [self.imageView.image CVMat];
    cv::Mat eyeMatOut;
    
    cv::normalize(eyeMat, eyeMatOut);
    eyeMatOut = eyeMatOut * 255;

    UIImage* tempImage = [UIImage imageWithCVMat:eyeMatOut];
	
	self.imageView.image = tempImage;
}

- (UIImage*)getImageFrom:(UIImage*)inputImg channel:(int)channelIdx
{

	cv::Mat eyeMat = [inputImg CVMat];
	cv::Mat eyeMatOut = [inputImg CVMat];
	
    std::vector<cv::Mat> input;
    input.push_back(eyeMat);
    
    std::vector<cv::Mat> output;
    output.push_back(eyeMatOut);
    
    std::vector<int> fromTo;
    
    int redSrc = (channelIdx == 0) ? 0 : -1;
    int greenSrc = (channelIdx == 1) ? 1 : -1;
    int blueSrc = (channelIdx == 2) ? 2 : -1;
    
    fromTo.push_back(redSrc);
    fromTo.push_back(0);
    
    fromTo.push_back(greenSrc);
    fromTo.push_back(1);
    
    fromTo.push_back(blueSrc);
    fromTo.push_back(2); 
    
    cv::mixChannels(input, output, fromTo);
	
    return [UIImage imageWithCVMat:eyeMatOut];
}

- (void)doConvertToHSV
{
	NSLog(@"doin' convert to HSV");
	cv::Mat eyeMat = [self.imageView.image CVMat];
	cv::Mat eyeMatOut;
	
    cv::cvtColor(eyeMat, eyeMatOut, cv::COLOR_RGB2HSV);
	
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

- (CONTOUR_LIST)doContours:(UIImage*)inputImg
{
	std::vector<cv::Vec4i> hier;
	
	cv::Mat eyeMat = [inputImg CVGrayscaleMat];
    _baseContourImage = [[UIImage imageWithCVMat:eyeMat] retain];
    
	//cv::Mat eyeMat = [_baseImage CVGrayscaleMat];
	//cv::Mat eyeMat = [_baseImage CVMat];
	cv::Mat eyeMatOut;
	
	//eyeMat = [tempImage CVGrayscaleMat];
	
	//cv::threshold(eyeMat, eyeMat, 100, 255, cv::THRESH_BINARY);
	//eyeMat = [tempImage CVMat];
	
	NSLog(@"doin' contours");

    CONTOUR_LIST localContours;
	cv::findContours(eyeMat, localContours, hier, CV_RETR_LIST, CV_CHAIN_APPROX_TC89_L1);
    
	NSLog(@"contours: %d", (int) localContours.size());
	
    /*int biggestContourIdx = 0;
	for (int i = 0; i < contours.size(); i++)
	{
        if (contours[i].size() > contours[biggestContourIdx].size())
            biggestContourIdx = i;
    }
    
    cIdx = biggestContourIdx;
    
    [self drawContour:biggestContourIdx];*/
    
    return [self filterContourRelations:[self filterContours:localContours]];
    
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

- (UIImage*) drawContours:(UIImage*)inputImg contours:(std::vector< std::vector<cv::Point> >)cons
{
	
	CGContextRef ctx;
	
    UIImage *tempImage = inputImg;
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
            cv::RotatedRect rrect = cv::fitEllipse(contour);
            cv::RotatedRect lastrrect = cv::fitEllipse(lastContour);
            
            MeasurePoint *mp1 = [[MeasurePoint alloc] initWithPoint:CGPointMake(rrect.center.x, rrect.center.y)];
            MeasurePoint *mp2 = [[MeasurePoint alloc] initWithPoint:CGPointMake(lastrrect.center.x, lastrrect.center.y)];
            
            float distBetween = [mp1 distanceFrom:mp1.point to:mp2.point];
            NSLog(@"distBetween: %f", distBetween);
            NSLog(@"distBetween real: %f", [self transformPixelsToRealDistance:distBetween]);
            
            bool validConnection = true;
            validConnection = validConnection && true;

            if (validConnection)
            {
                [[UIColor redColor] setStroke];
                
                CGContextMoveToPoint(ctx, lastrrect.center.x + offsetX, lastrrect.center.y + offsetY);

                CGContextAddLineToPoint(ctx, rrect.center.x + offsetX, rrect.center.y + offsetY);
                CGContextClosePath(ctx);
                CGContextStrokePath(ctx);
            }
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
    UIGraphicsEndImageContext();
    
    return imageWithContours;
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

- (UIImage*)doDilate:(UIImage*)inputImg
{
	NSLog(@"doin' dilate");
	cv::Mat eyeMat = [inputImg CVMat];
	
	cv::dilate(eyeMat, eyeMat, cv::Mat());
    
    return [UIImage imageWithCVMat:eyeMat];
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
	self.imageView.image = [self doThresh:self.imageView.image threshold:(int)self.threshSlider.value];
}

- (IBAction)adaptiveThreshBtnClick:(id)sender {
    [self doAdaptiveThresh];
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
	CONTOUR_LIST localContours = [self doContours:self.imageView.image];
    contours = localContours;
}

- (IBAction)gaussianBlurBtnClick:(id)sender {
    self.imageView.image = [self doGaussianBlur:self.imageView.image type:self.blurTypeSegment.selectedSegmentIndex];
}

- (IBAction)cvBlobDetectBtnClick:(id)sender {
}

- (IBAction)sobelBtnClick:(id)sender {
	self.imageView.image = [self doSobel:self.imageView.image dx:0 dy:1];
}

- (IBAction)dilateBtnClick:(id)sender {
	self.imageView.image = [self doDilate:self.imageView.image];
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
    
    std::vector< PointGroup > eyePointGroups;
	
	cv::Mat mat = [self.imageView.image CVGrayscaleMat];
	
	_eyeCascade.detectMultiScale(mat, eyes, 1.2, 5, kEyeHaarOptions, cv::Size(0,0));
    
	//_eyeCascade.detectMultiScale(<#const cv::Mat &image#>, <#vector<Rect> &objects#>, <#vector<int> &rejectLevels#>, <#vector<double> &levelWeights#>)
	
	// -------------
	
	UIGraphicsBeginImageContext(self.imageView.image.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	UIImage *tempImage = self.imageView.image;
	[tempImage drawAtPoint:CGPointZero];
	
	//cv::equalizeHist(eyeMat, eyeMat);

    float totalEyeX = 0;
    float totalEyeY = 0;
    
    float groupTolerantDist = 20.0f;
    
	for (int i = 0; i < eyes.size(); i++)
	{
		cv::Rect r = eyes[i];
        cv::Point c;
        c.x = r.x + (r.width / 2);
        c.y = r.y + (r.height / 2);
        
		//NSLog(@"eye at %d,%d size %d,%d", r.x, r.y, r.width, r.height);
        
        [[UIColor greenColor] setStroke];
		CGRect circleRect = CGRectMake(r.x - 2 + r.width / 2, r.y - 2 + r.height / 2, 4, 4);
        CGContextStrokeEllipseInRect(ctx, circleRect);
        
        //[[UIColor blueColor] setStroke];
        //CGRect circleRect2 = CGRectMake(r.x, r.y, r.width, r.height);
        //CGContextStrokeEllipseInRect(ctx, circleRect2);
        
        bool added = false;
        for (int j = 0; j < eyePointGroups.size(); j++)
        {
            PointGroup &pg = eyePointGroups[j];
            if (pg.pointIsTolerated(c))
            {
                NSLog(@"Point %d added to group %d at %d,%d", i, j, c.x, c.y);
                pg.addPoint(c);
                added = true;
                break;
            }
        }
        if (!added)
        {
            NSLog(@"Point %d making new group at %d,%d", i, c.x, c.y);
            PointGroup newGroup;
            newGroup.tolerance = 20;
            newGroup.addPoint(c);
            eyePointGroups.push_back(newGroup);
        }
	}
    
    for (int i = 0; i < eyePointGroups.size(); i++)
    {
        cv::Point c = eyePointGroups[i].center();
        
        [[UIColor yellowColor] setStroke];
        CGRect circleRect3 = CGRectMake(c.x - 3, c.y - 3, 6, 6);
        CGContextStrokeEllipseInRect(ctx, circleRect3); 
        
        cv::Rect bounds = eyePointGroups[i].boundingRect;
        CGRect circleRect4 = CGRectMake(bounds.x, bounds.y, bounds.width, bounds.height);
        
        NSLog(@"circleRect4 %f, %f, %f, %f", circleRect4.origin.x, circleRect4.origin.y, circleRect4.size.width, circleRect4.size.height);
        CGContextStrokeEllipseInRect(ctx, circleRect4); 
    }
    
    totalEyeX = totalEyeX / eyes.size();
    totalEyeY = totalEyeY / eyes.size();
    
    [[UIColor yellowColor] setStroke];
    CGRect circleRect3 = CGRectMake(totalEyeX - 3, totalEyeY - 3, 6, 6);
    CGContextStrokeEllipseInRect(ctx, circleRect3);
	
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

- (IBAction)drawLaserCandidatesBtnClick:(id)sender {
    self.imageView.image = [self drawContours:self.imageView.image contours:contours];
}

- (IBAction)changeImageBtnClick:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.delegate = self;
    
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:pc];
    [popover presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)patientImageBtnClick:(id)sender {
    int tag = [sender tag];
    [self setBaseImageFromPatient:tag];
}

- (IBAction)mixRedBtnClick:(id)sender {
    self.imageView.image = [self doMixRed:self.imageView.image];
}

- (IBAction)mixBlueBtnClick:(id)sender {
    self.imageView.image = [self doMixBlue:self.imageView.image];
}

- (IBAction)mixGreenBtnClick:(id)sender {
    self.imageView.image = [self doMixGreen:self.imageView.image];
}

- (IBAction)convertToHSVBtnClick:(id)sender {
    [self doConvertToHSV];
}

- (IBAction)testChannelSubBtnClick:(id)sender {
    self.imageView.image = [self doDampenGreenBlue:self.imageView.image];
}

- (IBAction)normalizeBtnClick:(id)sender {
    [self doNormalize];
}

- (IBAction)method1:(id)sender {
    
	int blurType = 1;
    self.imageView.image = [self doGaussianBlur:self.imageView.image type:blurType];
    
    self.imageView.image = [self doDilate:self.imageView.image];
    self.imageView.image = [self doDilate:self.imageView.image];
    
    self.imageView.image = [self doThresh:self.imageView.image threshold:200.0f];
    
    self.imageView.image = [self drawLasers:self.imageView.image];
}

- (IBAction)method2:(id)sender {
    
    self.imageView.image = [self doMethod2:self.imageView.image];
}

- (UIImage*)doMethod2:(UIImage*)inputImg
{
    UIImage *tempImage = inputImg;
    
    int blurType = 1;
    tempImage = [self doGaussianBlur:tempImage type:blurType];
    
    tempImage = [self doDampenGreenBlue:tempImage];
    tempImage = [self doMixRed:tempImage];
    
    tempImage = [self doThresh:tempImage threshold:20];
    
    return tempImage;
}

- (UIImage*)detectAndDrawLasers:(UIImage*)baseInputImg
{
    UIImage *tempImage = baseInputImg;
    
    tempImage = [self doMethod2:tempImage];
    
    CONTOUR_LIST localContours = [self doContours:tempImage];
    contours = localContours;
    
    return [self drawContours:baseInputImg contours:localContours];
}

- (UIImage*)drawLasers:(UIImage*)inputImg
{
    CONTOUR_LIST localContours = [self doContours:inputImg];
    contours = localContours;
    
    return [self drawContours:inputImg contours:localContours];
}

- (float)getLaserDistance:(UIImage*)baseInputImg
{
    UIImage *tempImage = baseInputImg;
    
    tempImage = [self doMethod2:tempImage];
    
    CONTOUR_LIST localContours = [self doContours:tempImage];
    
    NSLog(@"Are there 2 contours?...");
    if (localContours.size() != 2)
    {
        NSLog(@"Nope...");
        return 0;
    }
    
    return [self getRealDistanceBetweenContour:localContours[0] andContour:localContours[1]];
}

- (CONTOUR_LIST) filterContours:(CONTOUR_LIST)cons
{
    CONTOUR_LIST filteredContours;
    
    for (int i=0; i < cons.size(); i++)
    {
        std::vector <cv::Point> contour = cons[i];
        
        if ([self checkContourValidity:contour idx:i])
        {
            NSLog(@"new idx %lu", filteredContours.size());
            filteredContours.push_back(contour);
        }
    }
    
    return filteredContours;
}

- (CONTOUR_LIST) filterContourRelations:(CONTOUR_LIST)cons
{
    CONTOUR_LIST filteredContours;
    
    for (int i=0; i < cons.size(); i++)
    {
        for (int j=i+1; j < cons.size(); j++)
        {
            std::vector <cv::Point> contour1 = cons[i];
            std::vector <cv::Point> contour2 = cons[j];
            
            float distBetweenReal = [self getRealDistanceBetweenContour:contour1 andContour:contour2];
            
            float minDist = 12;
            float maxDist = 25;
            
            BOOL validDistance = distBetweenReal > minDist && distBetweenReal < maxDist;
            
            float contour1Area = powf([self transformPixelsToRealDistance:sqrt(cv::contourArea(contour1))], 2);
            float contour2Area = powf([self transformPixelsToRealDistance:sqrt(cv::contourArea(contour2))], 2);
            float contourAreaRatio = contour1Area / contour2Area;
            
            BOOL similarAreas = fabsf(contourAreaRatio - 1) < 0.6;
        
            BOOL validRelation = validDistance && similarAreas;
            
            NSLog(@"distBetween %d and %d, real: %f - contour area (%f, %f) ratio: %f", i, j, distBetweenReal, contour1Area, contour2Area, contourAreaRatio);
            
            if (validRelation)
            {
                filteredContours.push_back(contour1);
                filteredContours.push_back(contour2);
            }
        }
    }
    
    return filteredContours;
}

- (float) getRealDistanceBetweenContour:(CONTOUR)contour1 andContour:(CONTOUR)contour2
{    
    cv::RotatedRect rrect1 = cv::fitEllipse(contour1);
    cv::RotatedRect rrect2 = cv::fitEllipse(contour2);
    
    MeasurePoint *mp1 = [[MeasurePoint alloc] initWithPoint:CGPointMake(rrect1.center.x, rrect1.center.y)];
    MeasurePoint *mp2 = [[MeasurePoint alloc] initWithPoint:CGPointMake(rrect2.center.x, rrect2.center.y)];
    
    float distBetween = [mp1 distanceFrom:mp1.point to:mp2.point];
    float distBetweenReal = [self transformPixelsToRealDistance:distBetween];
    
    return distBetweenReal;
}

- (BOOL) checkContourValidity:(std::vector<cv::Point>) contour idx:(int)idx
{
    NSString *contourPrefix = [NSString stringWithFormat:@"contour %d", idx];
    if (contour.size() < 5) { NSLog(@"%@: %lu points, 5 needed", contourPrefix, contour.size()); return NO; }
    
    float contourArea = powf([self transformPixelsToRealDistance:sqrt(cv::contourArea(contour))], 2);
    
    float minContourArea = 1.3;
    float maxContourArea = 20;
    
    BOOL validArea = contourArea > minContourArea && contourArea < maxContourArea;
    
    if (!validArea) { NSLog(@"%@: area of %f not between %f and %f", contourPrefix, contourArea, minContourArea, maxContourArea); return NO; }
    
    // cv::Rect rect = cv::boundingRect(contours[thing]);
    cv::RotatedRect rrect = cv::fitEllipse(contour);
    float widthMM = [self transformPixelsToRealDistance:rrect.size.width];
    float heightMM = [self transformPixelsToRealDistance:rrect.size.height];
    float rectRatio = widthMM / heightMM;
    
    BOOL validDimensions = fabsf(rectRatio - 1) < 0.4;
    
    BOOL validContour = validArea && validDimensions;
    
    NSLog(@"%@: area: %f, dimensions: %f x %f, dimension ratio %f (%f checked) - %d ", contourPrefix, contourArea, widthMM, heightMM, rectRatio, fabsf(rectRatio - 1), validContour);
    
    return validContour;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = [image retain];
    _baseImage = image;
}
@end
