//
//  Coating.m
//  LENSIndex
//
//  Created by nitesh suvagia on 11/26/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "Coating.h"
#import "CoatingView.h"

#import <QuartzCore/QuartzCore.h>

@implementation Coating
@synthesize tintSlider;
@synthesize tintLabel;
@synthesize tintSegment;
@synthesize coatingView;
@synthesize polarizedPercentLabel;
@synthesize polarizedPercentSlider;
@synthesize viewTint;
@synthesize viewTintControlBox;
@synthesize arControlBox;
@synthesize scratchCoatControlBox;
@synthesize polarizedControlBox;
@synthesize modeViews;
@synthesize tintColorBtns;
@synthesize btnAR;
@synthesize btnPolarized;
@synthesize btnScratch;
@synthesize btnTint;
@synthesize modeSegment;
@synthesize modeSegmentPlaceholder;
@synthesize instLbl;
@synthesize glassesViewLeft;
@synthesize glassesViewRight;
@synthesize glassLeft;
@synthesize glassRight;
@synthesize bgLeft;
@synthesize bgRight;
@synthesize baseTintColor;
@synthesize lastTintStrength;
@synthesize mode;

@synthesize withoutImages;
@synthesize withImages;
@synthesize polarizedColorBtns;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
//        brushPattern=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"scratvcc.png"]]; 
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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //self.backgroundColor=[UIColor whiteColor];
        myPath=[[UIBezierPath alloc]init];
        myPath.lineWidth=20;
		// brushPattern=[UIColor whiteColor];

        // brushPattern=[[UIColor alloc]initWithWhite:0.1 alpha:0.0];
        //[UIColor colorWithPatternImage:];
		
		/*SVSegmentedControl *svsc = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"AR Coat", @"Polarized", @"Scratch Coat", @"Tint", nil]];
		svsc.frame = self.modeSegmentPlaceholder.frame;
		self.modeSegment = svsc;
		[self.view addSubview:svsc];*/
		
		const CGFloat* comp = CGColorGetComponents([UIColor brownColor].CGColor);
		NSLog(@"color: %f,%f,%f", comp[0], comp[1], comp[2]);
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.lastTintStrength = 0.50;
	self.withoutImages = [[NSMutableArray alloc] init];
	self.withImages = [[NSMutableArray alloc] init];	
	
	lensImage = [UIImage imageNamed:@"lens.png"];
	lensFrameImage = [UIImage imageNamed:@"frame.png"];
	lensMaskImage = [UIImage imageNamed:@"lensmask.png"];
	
	NSArray *withoutImageNames = [NSArray arrayWithObjects:@"city_glare.png", @"field_Overexposed2.png", @"field_normal.png", @"field_normal.png", nil];
	NSArray *withImageNames = [NSArray arrayWithObjects:@"city_noglare.png", @"field_normal.png", @"field_normal.png", @"field_normal.png", nil];
	
	for (NSString *s in withoutImageNames)
	{
		if ([s length] > 0)
			[self.withoutImages addObject:[UIImage imageNamed:s]];
		else
			[self.withoutImages addObject:[[UIImage alloc] init]];
	}
	for (NSString *s in withImageNames)
	{
		if ([s length] > 0)
			[self.withImages addObject:[UIImage imageNamed:s]];
		else
			[self.withImages addObject:[[UIImage alloc] init]];
	}
	
	//self.withoutImages = [NSArray arrayWithObjects:[UIImage imageNamed, nil
	brushPattern=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"scratch.png"]]; 
	
	CALayer *layer;
	
	for (UIButton *b in self.tintColorBtns)
	{
		layer = b.layer;
		
		[layer setBorderWidth:1.0f];
		[layer setCornerRadius:25];
		[layer setMasksToBounds:YES];
	}
	
	for (UIButton *b in self.polarizedColorBtns)
	{
		layer = b.layer;
		
		[layer setBorderWidth:1.0f];
		[layer setCornerRadius:25];
		[layer setMasksToBounds:YES];
	}
	
	layer = self.viewTintControlBox.layer;
	[layer setBorderWidth:2.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	/*layer = self.arControlBox.layer;
	[layer setBorderWidth:2.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];*/
	
	layer = self.scratchCoatControlBox.layer;
	[layer setBorderWidth:2.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	layer = self.polarizedControlBox.layer;
	[layer setBorderWidth:2.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	layer = self.glassesViewLeft.layer;
	[layer setBorderWidth:2.0f];
	[layer setMasksToBounds:YES];
	
	layer = self.glassesViewRight.layer;
	[layer setBorderWidth:2.0f];
	[layer setMasksToBounds:YES];
	
	self.glassLeft.brushPattern = brushPattern;
	self.glassRight.brushPattern = brushPattern;
	
	[self initScratchPaths];
	[self applyTint:self.glassLeft];	
	[self applyTint:self.glassRight];
	
	[self displayViewForMode:self.mode];
}

- (void) initScratchPaths
{
	self.glassLeft.myPath=[[UIBezierPath alloc]init];
	self.glassLeft.myPath.lineWidth=20;
	self.glassRight.myPath=[[UIBezierPath alloc]init];
	self.glassRight.myPath.lineWidth=20;
}
- (void)viewDidUnload
{
	[self setTintSlider:nil];
	[self setBtnAR:nil];
	[self setBtnPolarized:nil];
	[self setBtnScratch:nil];
	[self setBtnTint:nil];
	[self setTintColorBtns:nil];
	[self setTintSegment:nil];
	[self setTintLabel:nil];
	[self setViewTint:nil];
	[self setModeViews:nil];
	[self setViewTintControlBox:nil];
	[self setBgRight:nil];
	[self setArControlBox:nil];
	[self setScratchCoatControlBox:nil];
	[self setPolarizedControlBox:nil];
	[self setBgLeft:nil];
	[self setPolarizedColorBtns:nil];
	[self setPolarizedPercentLabel:nil];
	[self setPolarizedPercentSlider:nil];
	[self setGlassesViewRight:nil];
	[self setGlassesViewLeft:nil];
	[self setModeSegment:nil];
	[self setModeSegmentPlaceholder:nil];
	[self setInstLbl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  //  return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)dealloc {
	[tintSlider release];
	[btnAR release];
	[btnPolarized release];
	[btnScratch release];
	[btnTint release];
	[tintColorBtns release];
	[tintSegment release];
	[tintLabel release];
	[viewTint release];
	[modeViews release];
	[viewTintControlBox release];
	[bgRight release];
	[arControlBox release];
	[scratchCoatControlBox release];
	[polarizedControlBox release];
	[bgLeft release];
	[polarizedColorBtns release];
	[polarizedPercentLabel release];
	[polarizedPercentSlider release];
	[glassesViewRight release];
	[glassesViewLeft release];
	[modeSegment release];
	[modeSegmentPlaceholder release];
	[instLbl release];
	[super dealloc];
}
- (IBAction)tintSliderChanged:(id)sender {
	UISlider *slider = (UISlider*)sender;
	float tintStrength = [slider value];
	self.tintLabel.text = [NSString stringWithFormat:@"%.0f%%", tintStrength];
	tintStrength /= 100.0f;
	[self applyTint:self.glassRight strength:tintStrength];
	
}

- (IBAction)tintSegmentChanged:(id)sender {
	UISegmentedControl *segment = (UISegmentedControl*)sender;
	NSString *segmentText = [segment titleForSegmentAtIndex:[segment selectedSegmentIndex]];
	segmentText = [segmentText substringToIndex:[segmentText length]-1];
	NSLog(@"%@", segmentText);
	float tintStrength = [segmentText floatValue] / 100.0f;
	[self applyTint:self.glassRight strength:tintStrength];
}

- (IBAction)polarizedPercentSliderChanged:(id)sender {
}

- (IBAction)polarizedColorBtnClick:(id)sender {
}

- (void) applyTint:(DraggableLens*)lens
{
	[self applyTint:lens strength:self.lastTintStrength];
}
- (void) applyTint:(DraggableLens*)lens strength:(float)tintStrength
{
	if (lens.doesTint)
		self.lastTintStrength = tintStrength;
	
	if (self.mode == 1)
		tintStrength = 0.50;
	UIColor *tintColor = nil;
	if (self.baseTintColor)
	{
		const CGFloat* comp = CGColorGetComponents(self.baseTintColor.CGColor);
		tintColor = [UIColor colorWithRed:comp[0] green:comp[1] blue:comp[2] alpha:tintStrength];
		//self.bgRight.image = [self getTintedImage:lensImage color:tintColor];
	}
	
	lens.image = [self getTintedImage:lens color:tintColor];
}

- (IBAction)tintColorBtnClick:(id)sender {
	UIButton *cb = (UIButton*)sender;
	self.baseTintColor = cb.backgroundColor;
	[self applyTint:self.glassRight strength:self.lastTintStrength];
}

- (IBAction)modeBtnClick:(id)sender {
	self.mode = [sender tag];
	[self displayViewForMode:self.mode];
}

- (IBAction)modeSegmentChanged:(id)sender {
	UISegmentedControl *segment = (UISegmentedControl*)sender;
	self.mode = [segment selectedSegmentIndex];
	[self displayViewForMode:self.mode];
}

- (IBAction)clearScratches:(id)sender {
	[self initScratchPaths];
	[self applyTint:self.glassLeft];	
	[self applyTint:self.glassRight];
}

- (UIImage*) getTintedImage:(DraggableLens*)lens color:(UIColor*)color
{
	//UIGraphicsBeginImageContext(img.size);
	UIGraphicsBeginImageContext(lens.frame.size);
	
	UIImageView *bgView;
	
	if (lens == self.glassLeft)
		bgView = self.bgLeft;
	else if (lens == self.glassRight)
		bgView = self.bgRight;
	
	//UIGraphicsBeginImageContextWithOptions(self.bgRight.frame.size, YES, 1.0f);
	
	ctx = UIGraphicsGetCurrentContext();
	
	//CGContextTranslateCTM(ctx, 0, self.bgRight.frame.size.height);
	//CGContextScaleCTM(ctx, 1.0, -1.0);
	
	UIImage *img = lensImage;
	
	CGContextTranslateCTM(ctx, 0, img.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);

	//CGRect imgRect = CGRectMake(self.glassRight.frame.origin.x, self.bgRight.frame.size.height-self.glassRight.frame.origin.y-self.glassRight.frame.size.height, img.size.width, img.size.height);
	
	CGRect imgRect = CGRectMake(0, 0, img.size.width, img.size.height);
	
	CGRect bgRect = CGRectMake(-lens.frame.origin.x, lens.frame.size.height-bgView.frame.size.height+lens.frame.origin.y, bgView.frame.size.width, bgView.frame.size.height);
	
	//CGContextSetBlendMode(ctx, kCGBlendModeClear);
	//CGContextClearRect(ctx, bgRect);
	
	CGContextSetBlendMode(ctx, kCGBlendModeNormal);
	
	//UIImage *bg = [self.withoutImages objectAtIndex:self.mode];
	UIImage *bg2 = [self.withImages objectAtIndex:self.mode];
	
	//CGRect bgRect = CGRectMake(0, 0, self.bgRight.frame.size.width, self.bgRight.frame.size.height);
	//CGContextDrawImage(ctx, bgRect, bg.CGImage);
	
	//CGRect imgRect = CGRectMake(self.glassRight.frame.origin.x, self.bgRight.frame.size.height-self.glassRight.frame.origin.y-self.glassRight.frame.size.height, img.size.width, img.size.height);
	
	//CGContextSetBlendMode(ctx, 
	
	CGContextSaveGState(ctx);
	
	CGContextClipToMask(ctx, imgRect, lensMaskImage.CGImage);
	
	if (lens.doesCutOut)
		CGContextDrawImage(ctx, bgRect, bg2.CGImage);
	
	CGContextDrawImage(ctx, imgRect, img.CGImage);
	
	CGContextTranslateCTM(ctx, 0, img.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);

	if (lens.doesScratch)
	{		
		[lens.brushPattern setStroke];
		[lens.myPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
	}
	
	CGContextTranslateCTM(ctx, 0, img.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	if (lens.doesTint)
	{
		if (self.mode==1)
		{
			CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f].CGColor);		
			CGContextSetBlendMode(ctx, kCGBlendModeDarken);			
			CGContextFillRect(ctx, imgRect);
		}
		if (color)
		{
			CGContextSetBlendMode(ctx, kCGBlendModeColor);	
			CGContextSetFillColorWithColor(ctx, color.CGColor);		
			CGContextFillRect(ctx, imgRect);
		}
	}
	
	CGContextRestoreGState(ctx);
	
	CGContextDrawImage(ctx, imgRect, lensFrameImage.CGImage);
	
	//CGContextTranslateCTM(ctx, 0, self.bgRight.frame.size.height);
	//CGContextScaleCTM(ctx, 1.0, -1.0);
	
	UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImg;
}

- (void) displayViewForMode:(int)modeArg
{
	int cnt = 0;
	for (UIView *v in self.modeViews)
	{
		if (modeArg == cnt)
			v.hidden = NO;
		else
			v.hidden = YES;
		cnt++;
	}
	
	self.bgLeft.image = [self.withoutImages objectAtIndex:self.mode];
	self.bgRight.image = [self.withoutImages objectAtIndex:self.mode];
	
	self.glassLeft.doesCutOut = NO;
	self.glassRight.doesCutOut = NO;
	if (self.mode == 0 || self.mode == 1 || self.mode == 3)
		self.glassRight.doesCutOut = YES;

	BOOL shouldDrag = self.mode != 2;
	self.glassLeft.doesDrag = shouldDrag;
	self.glassRight.doesDrag = shouldDrag;
	
	BOOL shouldScratch = self.mode == 2;
	self.glassLeft.doesScratch = shouldScratch;
	self.glassRight.doesScratch = NO;
	
	BOOL shouldTint = self.mode == 3 || self.mode == 1;
	self.glassLeft.doesTint = NO;
	self.glassRight.doesTint = shouldTint;
	
	[self applyTint:self.glassLeft];
	[self applyTint:self.glassRight];
	
	//if (self.mode == 3 || self.mode == 1)
	//	[self applyTint:self.glassRight];
	//else
	//	[self applyTint:self.glassRight strength:0];
}

@end

@implementation DraggableLens

@synthesize coatingView;
@synthesize doesCutOut;
@synthesize doesDrag;
@synthesize doesTint;
@synthesize doesScratch;
@synthesize brushPattern;
@synthesize myPath;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (doesDrag)
	{
		UITouch *t = [touches anyObject];
		CGPoint p = [t locationInView:self];
		CGPoint c = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
		//NSLog(@"center: %f,%f    touch: %f,%f", c.x, c.y, p.x, p.y);
		dragDistFromCenter = CGPointMake(p.x - c.x, p.y - c.y);
	}
	
	if (doesScratch)
	{
		NSLog(@"start scratch");
		touchStart = [[touches anyObject] locationInView:self];
		
		UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
		[myPath moveToPoint:[mytouch locationInView:self]];		
		
	}
	
	//self.center = CGPointMake(self.frame.origin.x + p.x, self.frame.origin.y + p.y);
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (doesDrag)
	{
		UITouch *t = [touches anyObject];
		CGPoint p = [t locationInView:self];
		CGPoint pa = CGPointMake(p.x - dragDistFromCenter.x, p.y - dragDistFromCenter.y);
		self.center = CGPointMake(self.frame.origin.x + pa.x, self.frame.origin.y + pa.y);
	}
	
	if (doesScratch)
	{
		NSLog(@"continuing scratch");
		UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
		[myPath addLineToPoint:[mytouch locationInView:self]];
	}
	
	[self.coatingView applyTint:self];
}
@end
