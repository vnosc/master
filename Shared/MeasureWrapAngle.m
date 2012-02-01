//
//  MeasureWrapAngle.m
//  Smart-i
//
//  Created by Troy Potts on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MeasureWrapAngle.h"

@implementation MeasureWrapAngle
@synthesize measureAreaView;
@synthesize angleSlider;
@synthesize frameWidthSlider;
@synthesize sliderLine;
@synthesize diagLine;
@synthesize angleField;
@synthesize wrapImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.sliderLine = [[MeasureLine alloc] initWithStartPoint:CGPointMake(0,0) endPoint:CGPointMake(0,0)];
		self.diagLine = [[MeasureLine alloc] initWithStartPoint:CGPointMake(0,0) endPoint:CGPointMake(0,0)];
		self.diagLine.start = self.sliderLine.start;
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
	
    CGAffineTransform rotateTransformCW = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                                -90.0 * M_PI / 180.0f);
    CGAffineTransform rotateTransformCCW = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                                  90.0 * M_PI / 180.0f);    
    //self.wrapImageView.transform = rotateTransformCW;
    self.frameWidthSlider.transform = rotateTransformCCW;
    
    [self dockRight:self.frameWidthSlider to:self.measureAreaView];

    
	self.measureAreaView.contentMode = UIViewContentModeRedraw;
	self.measureAreaView.effOffset = 22;
    
	float f2 = self.angleSlider.value;
	[self setSliderPoint:f2];
    
    float f3 = self.frameWidthSlider.value;
	[self setFrameWidthPoint:f3];
	
    // Do any additional setup after loading the view from its nib.
}

- (void) dockRight:(UIView*)v to:(UIView*)rel
{
    float newLeft = rel.frame.origin.x + rel.frame.size.width;
    float newRight = v.frame.size.width;
    float newBottom = rel.frame.size.height / 3;
    float newTop = rel.frame.origin.y + rel.frame.size.height - newBottom;
    
    v.frame = CGRectMake(newLeft, newTop, newRight, newBottom + 10);
}

- (void)viewDidUnload
{
	[self setMeasureAreaView:nil];
	[self setAngleSlider:nil];
	[self setAngleField:nil];
    [self setWrapImageView:nil];
    [self setFrameWidthSlider:nil];
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
	[measureAreaView release];
	[angleSlider release];
	[angleField release];
    [wrapImageView release];
    [frameWidthSlider release];
	[super dealloc];
}
- (IBAction)angleSliderChanged:(id)sender {
	float f2 = self.angleSlider.value;
	NSLog(@"angleSlider.value: %f - f2: %f", self.angleSlider.value, f2);
	[self setSliderPoint:f2];
}

- (IBAction)frameWidthSliderChanged:(id)sender {
    float f2 = self.frameWidthSlider.value;
    NSLog(@"frameWidthSlider.value: %f - f2: %f", self.frameWidthSlider.value, f2);
    [self setFrameWidthPoint:f2];
}

- (void) setSliderPoint:(float)f2
{	
	NSLog(@"again angleSlider.value: %f - f2: %f", self.angleSlider.value, f2);
	float effWidth = (self.measureAreaView.frame.size.width - self.measureAreaView.effOffset);
	float x = f2 * effWidth;

	self.sliderLine.start.point = CGPointMake(x, self.measureAreaView.frame.size.height);
	self.sliderLine.end.point = CGPointMake(effWidth, self.measureAreaView.frame.size.height);
	self.diagLine.start.point = CGPointMake(x, self.measureAreaView.frame.size.height);
	self.diagLine.end.point = CGPointMake(effWidth, self.measureAreaView.frame.size.height / 2);
    //self.diagLine.end.point = CGPointMake(effWidth, self.measureAreaView.anglePointY);
	
	self.measureAreaView.anglePointX = x;
	[self.measureAreaView setNeedsDisplay];
	
	//NSLog(@"%f,%f   %f,%f   %f,%f   %f,%f", self.sliderLine.start.point.x, self.sliderLine.start.point.y, self.sliderLine.end.point.x, self.sliderLine.end.point.y, self.diagLine.start.point.x, self.diagLine.start.point.y, self.diagLine.end.point.x, self.diagLine.end.point.y);
	//NSLog(@"angle: %@ or %@", [self.sliderLine angleBetween:self.diagLine], [self.diagLine angleBetween:self.sliderLine]);
	
    [self updateAngle];
}

- (void) updateAngle
{
	float angle = 90 - [[self.sliderLine angleBetween:self.diagLine] floatValue];
	
	if (isnan(angle))
		angle = 0;
	
	//NSLog(@"angle %f", angle);
	self.angleField.text = [NSString stringWithFormat:@"%.2fº", angle];
}

- (void) setFrameWidthPoint:(float)f2
{
	NSLog(@"again frameWidthSlider.value: %f - f2: %f", self.frameWidthSlider.value, f2);
	float effHeight = self.measureAreaView.frame.size.height - self.frameWidthSlider.frame.size.height*2;
	float y = effHeight + (f2 * self.frameWidthSlider.frame.size.height * 2);
    
	self.measureAreaView.anglePointY = y;
	[self.measureAreaView setNeedsDisplay];
    
    //[self updateAngle];
}

- (IBAction)saveAndContinue:(id)sender {
	
	NSDictionary *d = [[NSDictionary alloc] initWithObjectsAndKeys:
		 [NSNumber numberWithFloat:[self.angleField.text floatValue]], @"WrapAngle",
		 nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MeasurePictureDidCalculateMeasurement" object:self userInfo:d];
	
	[self.navigationController popViewControllerAnimated:YES];
}
@end


@implementation MeasureAreaView

@synthesize effOffset;
@synthesize anglePointX;
@synthesize anglePointY;

- (id) initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.anglePointX = 0.0f;
        self.anglePointY = 0.0f;
        self.effOffset = 23;
	}
	return self;
}
- (void) drawRect:(CGRect)rect
{
	float width = rect.size.width;
	float height = rect.size.height;
	
	float effWidth = width - self.effOffset;
    float effWidthRatio = effWidth / width;
    
    float effHeight = height;
	
    int lineWidth = 2;
    
	CGPoint anglePoint = CGPointMake(self.anglePointX, height);
	
	//UIGraphicsBeginImageContext(self.frame.size);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(ctx);
	[[UIColor redColor] setStroke];
	CGContextSetLineWidth(ctx, lineWidth);
	CGContextMoveToPoint(ctx, self.anglePointX, height);
	CGContextAddLineToPoint(ctx, effWidth, height/2);
	CGContextAddLineToPoint(ctx, self.anglePointX, 0);
	CGContextStrokePath(ctx);
	
	CGContextBeginPath(ctx);
	[[UIColor blackColor] setStroke];
	CGContextSetLineWidth(ctx, lineWidth);
	CGContextMoveToPoint(ctx, 10, height/2);
	CGContextAddLineToPoint(ctx, effWidth, height/2);
	CGContextStrokePath(ctx);
	
	CGContextBeginPath(ctx);
	[[UIColor greenColor] setStroke];
	CGContextSetLineWidth(ctx, lineWidth);
	CGContextMoveToPoint(ctx, effWidth, 0);
	CGContextAddLineToPoint(ctx, effWidth, height);
	CGContextStrokePath(ctx);
	
	CGContextBeginPath(ctx);
	[[UIColor blackColor] setStroke];
	[[UIColor redColor] setFill];
	
	CGRect ellipseRect = CGRectMake(anglePoint.x - (effWidth-anglePoint.x), (height - anglePointY) / 2, (effWidth-anglePoint.x)*2, anglePointY);
	CGRect clipRect = CGRectMake(anglePoint.x, 0, effWidth, height);
	CGContextClipToRect(ctx, clipRect);
	CGContextAddEllipseInRect(ctx, ellipseRect);
	CGContextStrokePath(ctx);
	
	/*UIBezierPath *p = [[UIBezierPath alloc] init];
	CGPoint br = CGPointMake(width, height);
	[p moveToPoint:CGPointMake(width-10, height/2)];
	[p addCurveToPoint:CGPointMake(self.anglePointX, height) controlPoint1:br controlPoint2:br];
	[p stroke];*/

	//UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	
	//[img drawInRect:rect];
}

@end