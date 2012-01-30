//
//  CapturePicture.m
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MeasurePicture.h"

extern int blendMode;
extern ServiceObject* frameXML;

@implementation MeasurePicture
@synthesize imageContainer;
@synthesize vImagePreview;
@synthesize touchView;

@synthesize rightEyePoint, leftEyePoint, bridgePoint;
@synthesize processStep;

@synthesize iv;
@synthesize img;
@synthesize pinchGR;
@synthesize panGR;
@synthesize zoomSlider;

@synthesize measureType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.measureType = -1;
		minScale = 1.0f;
		maxScale = 3.0f;
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
	
	//[self.view addGestureRecognizer:self.pinchGR];
	//[self.view addGestureRecognizer:self.panGR];
	[self beginMeasureProcess];
	
	CALayer *layer = self.imageContainer.layer;
	[layer setBorderWidth:3.0f];
	[layer setCornerRadius:25];
	[layer setMasksToBounds:YES];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(touchViewAddedLine:)
	 name:@"LineViewDidAddLine"
	 object:self.touchView];
	//[self initLines];
	
}

- (void) beginMeasureProcess
{
	self.processStep = 0;

	[self.touchView initData];

	self.touchView.userInteractionEnabled = NO;
	
	//vImagePreview.image = iv.image;
	vImagePreview.image = self.img;
	
	self.touchView.measureType = self.measureType;
	
	if (self.measureType == 0 || self.measureType == 1)
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please touch the center of the\nright pupil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	else if (self.measureType == 2)
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please touch and drag to draw a line across the front of the frame." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	
		self.touchView.userInteractionEnabled = YES;
		self.touchView.canAddLines = YES;
	}
	else if (self.measureType == 3)
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please touch the center of the\n pupil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
}

- (void) nextProcessStep:(UIEvent*)event notification:(NSNotification*)n
{
    
    NSDictionary *d = nil;
    MeasureLine *l = nil;
    CGPoint p;
    NSSet *touches = nil;
    
    if (event == nil)
    {
        d = [n userInfo];
        l = [d objectForKey:@"AddedLine"];
    }
    else
    {
        touches = [event allTouches];
        UITouch *t = [[touches allObjects] objectAtIndex:0];
        p = [t locationInView:self.touchView];
    }
    
    if (self.measureType == 0 || self.measureType == 1) // dist PD/near PD
    {
        [self nextPDStep:event notification:n];
    }
    else if (self.measureType == 2) // panto
    {
        [self nextPantoStep:event notification:n];
    }
    else if (self.measureType == 3) // frame tryon
    {
        [self nextVertexStep:event notification:n];
    }
}

- (void) nextPDStep:(UIEvent*)event notification:(NSNotification*)n
{
    
    NSDictionary *d = nil;
    MeasureLine *l = nil;
    CGPoint p;
    NSSet *touches = nil;
    
    if (event == nil)
    {
        d = [n userInfo];
        l = [d objectForKey:@"AddedLine"];
    }
    else
    {
        touches = [event allTouches];
        UITouch *t = [[touches allObjects] objectAtIndex:0];
        p = [t locationInView:self.touchView];
    }
    
    if (self.processStep == 0)
    {
        self.rightEyePoint = p;
        
        [self.touchView.points addObject:[[MeasurePoint alloc] initWithPoint:p]];
        // self.touchView.dragged = YES;
        [self.touchView setNeedsDisplay];
        
        [self beginPointStep:@"Please touch the center of the\nleft pupil."];
    }
    else if (self.processStep == 1)
    {
        self.leftEyePoint = p;
        
        [self incrementProcessCounter];
        
        [self.touchView.points addObject:[[MeasurePoint alloc] initWithPoint:p]];
        // self.touchView.dragged = YES;
        [self.touchView setNeedsDisplay];
        
        // UNCOMMENT TO SELECT BRIDGE
        /*UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please touch the center of the\nbridge." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         [alert release];*/
        
        [self nextProcessStep:event notification:n];
    }
    
    else if (self.processStep == 2)
    {        
        // self.touchView.dragged = YES;
        [self.touchView setNeedsDisplay];

        [self beginPointStep:@"Please touch the\nbottom of the right lens."];
    }
    
    else if (self.processStep == 3)
    {
        CGPoint bottomRightPoint = CGPointMake(self.rightEyePoint.x, p.y);
        CGPoint bottomLeftPoint = CGPointMake(self.rightEyePoint.x - 100, p.y);
        MeasureLine *l = [self.touchView createLineFrom:bottomRightPoint to:bottomLeftPoint];
        l.name = @"Right Frame Bottom Horizontal";
        l.startLockY = YES;
        l.endLockY = YES;
        
        [self.touchView setNeedsDisplay];
        
        [self beginPointStep:@"Please touch the\nbottom of the left lens."];
    }
    
    else if (1 == 0 && self.processStep == 2)
    {   
        self.bridgePoint = p;
        
        //[self.touchView.points addObject:[[MeasurePoint alloc] initWithPoint:p]];
        // self.touchView.dragged = YES;
        [self.touchView setNeedsDisplay];
        
        // UNCOMMENT FOR RECT BY HAND
        [self beginRectStep:@"Please touch and drag to draw a rectangle around the right side of the frame."];
        
        // UNCOMMENT FOR POINTS
        //[self beginAdjustStep:@"Adjust the lines by hand."];
        
    }
    else if (1 == 0 && self.processStep == 3)
    {
        l.name = @"Right Frame Box";
        
        [self beginRectStep:@"Please touch and drag to draw a rectangle around the left side of the frame."];

    }
    
    else if (self.processStep == 4)
    {
        CGPoint bottomLeftPoint = CGPointMake(self.leftEyePoint.x, p.y);
        CGPoint bottomRightPoint = CGPointMake(self.leftEyePoint.x + 100, p.y);
        MeasureLine *l = [self.touchView createLineFrom:bottomLeftPoint to:bottomRightPoint];
        l.name = @"Left Frame Bottom Horizontal";
        l.startLockY = YES;
        l.endLockY = YES;
        
        [self beginAdjustStep:@"Adjust the lines by hand."];
    }
}

- (void) nextPantoStep:(UIEvent*)event notification:(NSNotification*)n
{
    NSDictionary *d = nil;
    MeasureLine *l = nil;
    CGPoint p;
    NSSet *touches = nil;
    
    if (event == nil)
    {
        d = [n userInfo];
        l = [d objectForKey:@"AddedLine"];
    }
    else
    {
        touches = [event allTouches];
        UITouch *t = [[touches allObjects] objectAtIndex:0];
        p = [t locationInView:self.touchView];
    }
    
    if (self.processStep == 0)
    {
        
        l.name = @"Frame Across";
      
        MeasurePoint* mp = l.lowerPoint;
        
        MeasureLine* upLine = [self.touchView createLineFromPoint:mp to:CGPointMake(mp.x, l.upperPoint.y - 200)];
        upLine.name = @"Vertical Up";
        upLine.startMovesEnd = YES;
        upLine.endLockX = YES;
        
        MeasureLine* downLine = [self.touchView createLineFromPoint:mp to:CGPointMake(mp.x, mp.y + 200)];
        downLine.name = @"Vertical Down";
        downLine.startMovesEnd = YES;
        downLine.endLockX = YES;
        
        [self beginAdjustStep:@"Adjust the lines by hand."];
    }
}

- (void) nextVertexStep:(UIEvent *)event notification:(NSNotification *)n
{
    NSDictionary *d = nil;
    MeasureLine *l = nil;
    CGPoint p;
    NSSet *touches = nil;
    
    if (event == nil)
    {
        d = [n userInfo];
        l = [d objectForKey:@"AddedLine"];
    }
    else
    {
        touches = [event allTouches];
        UITouch *t = [[touches allObjects] objectAtIndex:0];
        p = [t locationInView:self.touchView];
    }
    
    if (self.processStep == 0)
    {
        self.rightEyePoint = p;
        
        [self.touchView.points addObject:[[MeasurePoint alloc] initWithPoint:p]];
        
        // self.touchView.dragged = YES;
        [self.touchView setNeedsDisplay];
        
        [self beginLineStep:@"Please touch and drag to draw a line across the front of the frame."];
    }
    else if (self.processStep == 1)
    {
        [self.touchView.points removeObjectAtIndex:0];
        
        [self beginAdjustStep:@"Adjust the lines by hand."];
    }
    /*else if (self.processStep == 1)
     {	
     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please touch and drag to draw a line across the front of the frame." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];
     [alert release];
     
     self.touchView.userInteractionEnabled = YES;
     self.touchView.canAddLines = YES;
     
     self.processStep++;
     }*/		

}

- (void) beginRectStep:(NSString *)instructions
{
    [self prepareForMeasureRect];
    [self beginProcessStep:instructions];
}

- (void) beginPointStep:(NSString*)instructions
{
    [self prepareForMeasurePoint];
    [self beginProcessStep:instructions];
}

- (void) beginAdjustStep:(NSString*)instructions
{
    [self initLines];
    self.touchView.canAddLines = NO;
    
    [self beginProcessStep:instructions];
}

- (void) beginProcessStep:(NSString*)instructions
{
    [self incrementProcessCounter];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:instructions delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];    
}

- (void) incrementProcessCounter
{
    NSLog(@"ProcessStep %d", processStep);
    self.processStep++;
}

- (void) prepareForMeasureRect
{
    self.touchView.userInteractionEnabled = YES;
    self.touchView.canAddLines = YES;
    self.touchView.nextLineIsRect = YES;   
}

- (void) prepareForMeasureLine
{
    self.touchView.userInteractionEnabled = YES;
    self.touchView.canAddLines = YES;
    self.touchView.nextLineIsRect = NO;   
}

- (void) prepareForMeasurePoint
{
    self.touchView.userInteractionEnabled = NO;
    self.touchView.canAddLines = NO;
    self.touchView.nextLineIsRect = NO;   
}

- (void) initLines
{
	self.touchView.userInteractionEnabled = YES;
	
	if (self.measureType == 0 || self.measureType == 1)
	{
		CGPoint lTopPoint = CGPointMake(self.leftEyePoint.x, self.leftEyePoint.y - 100);
		CGPoint lBotPoint = CGPointMake(self.leftEyePoint.x, self.leftEyePoint.y);
		MeasureLine* l1 = [self.touchView createLineFrom:lTopPoint toPoint:[self.touchView.points objectAtIndex:1]];
		l1.name = @"Left Eye Vertical";
		l1.endMovesStart = YES;
		l1.startMovesEnd = YES;

		CGPoint rTopPoint = CGPointMake(self.rightEyePoint.x, self.rightEyePoint.y - 100);
		CGPoint rBotPoint = CGPointMake(self.rightEyePoint.x, self.rightEyePoint.y);
		MeasureLine* l2 = [self.touchView createLineFrom:rTopPoint toPoint:[self.touchView.points objectAtIndex:0]];
		l2.name = @"Right Eye Vertical";
		l2.endMovesStart = YES;
		l2.startMovesEnd = YES;
		
		[l1.start setHand:YES text:@"L" width:60.0f height:60.0f offsetX:0.0f offsetY:-50.0f];
		[l2.start setHand:YES text:@"R" width:60.0f height:60.0f offsetX:0.0f offsetY:-50.0f];
		/*float fakeRectDistX = 80.0f;
		float fakeRectDistY = 60.0f;
		
		MeasureLine* l8 = [self.touchView createLineFrom:CGPointMake(rBotPoint.x - fakeRectDistX, rBotPoint.y-fakeRectDistY) to:CGPointMake(rBotPoint.x + fakeRectDistX, rBotPoint.y + fakeRectDistY)];
		l8.name = @"Right Frame Box";
		l8.isRect = YES;
		l8.lineColor = [UIColor redColor];
		
		MeasureLine* l9 = [self.touchView createLineFrom:CGPointMake(lBotPoint.x - fakeRectDistX, lBotPoint.y-fakeRectDistY) to:CGPointMake(lBotPoint.x + fakeRectDistX, lBotPoint.y + fakeRectDistY)];
		l9.name = @"Left Frame Box";
		l9.isRect = YES;
		l9.lineColor = [UIColor redColor];*/
		
		//CGPoint bTopPoint = CGPointMake((lTopPoint.x + rTopPoint.x) / 2, (lTopPoint.y + rTopPoint.y) / 2);
		//CGPoint bBotPoint = CGPointMake(bTopPoint.x, bTopPoint.y + 400);
		//float bridgeDist = 50.0f;

		//MeasureLine *l3 = [self createBridgeFromFrameBox];
        MeasureLine *l3 = [self createBridgeFromPupils];
		
		//[self.touchView.points removeObjectAtIndex:6];
		//[self.touchView.points removeObjectAtIndex:5];
		//[self.touchView.points removeObjectAtIndex:4];
		//[self.touchView.points removeObjectAtIndex:3];
		//[self.touchView.points removeObjectAtIndex:2];
		
		MeasureLine* l4 = [self.touchView createLineFromPoint:l2.end to:CGPointMake(rBotPoint.x - 100, rBotPoint.y)];
		l4.name = @"Right Frame Center Horizontal";
		//l4.lockPointY = YES;
		l4.endLockY = YES;
		l4.startMovesEnd = YES;

		MeasureLine* l5 = [self.touchView createLineFromPoint:l1.end to:CGPointMake(lBotPoint.x + 100, lBotPoint.y)];
		l5.name = @"Left Frame Center Horizontal";
		l5.endLockY = YES;
		l5.startMovesEnd = YES;

		/*MeasureLine* l6 = [self.touchView createLineFrom:CGPointMake(l4.start.x, l4.start.y + 50) to:CGPointMake(l4.end.x, l4.end.y + 50)];
		l6.name = @"Right Frame Bottom Horizontal";
		l6.endLockY = YES;
		l6.startMovesEnd = YES;
		
		MeasureLine* l7 = [self.touchView createLineFrom:CGPointMake(l5.start.x, l5.start.y + 50) to:CGPointMake(l5.end.x, l5.end.y + 50)];
		l7.name = @"Left Frame Bottom Horizontal";
		l7.endLockY = YES;
		l7.startMovesEnd = YES;*/
		
	}
	else if (self.measureType == 3)
	{
		MeasureLine* frameLine = [self.touchView.lines objectAtIndex:0];
		frameLine.name = @"Line Across Frame";
		
		CGPoint mid = frameLine.midpoint;
		CGPoint diff = CGPointMake(mid.x - self.rightEyePoint.x, mid.y - self.rightEyePoint.y);
		
		CGPoint newStart = CGPointMake(frameLine.start.x - diff.x, frameLine.start.y - diff.y);
		CGPoint newEnd = CGPointMake(frameLine.end.x - diff.x, frameLine.end.y - diff.y);
		
		MeasureLine* l = [self.touchView createLineFrom:newStart to:newEnd];
		l.lineColor = [UIColor redColor];
		l.name = @"Line Across Eye";
	}
	// self.touchView.dragged = YES;
	[self.touchView setNeedsDisplay];

    // Do any additional setup after loading the view from its nib.
}

- (MeasureLine*) createBridgeFromFrameBox
{
    MeasureLine* rfb = [self.touchView lineByName:@"Right Frame Box"];
    MeasureLine* lfb = [self.touchView lineByName:@"Left Frame Box"];
    
    float bridgeX = (rfb.rightPoint.x + lfb.leftPoint.x) / 2;
    CGPoint bTopPoint = CGPointMake(bridgeX, MIN(rfb.upperPoint.y, lfb.upperPoint.y));
    CGPoint bBotPoint = CGPointMake(bridgeX, MAX(rfb.lowerPoint.y, lfb.lowerPoint.y));
    
    MeasureLine* l3 = [self.touchView createLineFrom:bTopPoint to:bBotPoint];
    l3.name = @"Bridge Vertical";
    l3.startMovesEnd = YES;
    l3.endMovesStart = YES;
    
    return l3;

}

- (MeasureLine*) createBridgeFromPupils
{
    MeasureLine* rfb = [self.touchView lineByName:@"Right Frame Bottom Horizontal"];
    MeasureLine* lfb = [self.touchView lineByName:@"Left Frame Bottom Horizontal"];
    
    float bridgeX = (self.rightEyePoint.x + self.leftEyePoint.x) / 2;
    float bridgeY = (self.rightEyePoint.y + self.leftEyePoint.y) / 2;
    CGPoint bTopPoint = CGPointMake(bridgeX, bridgeY - 150);
    CGPoint bBotPoint = CGPointMake(bridgeX, MAX(rfb.lowerPoint.y, lfb.lowerPoint.y) + 50);
    
    MeasureLine* l3 = [self.touchView createLineFrom:bTopPoint to:bBotPoint];
    l3.name = @"Bridge Vertical";
    l3.startMovesEnd = YES;
    l3.endMovesStart = YES;
    
    return l3;
}

- (void)viewDidUnload
{
	NSLog(@"Unload");
	[self setVImagePreview:nil];
	[self setTouchView:nil];
	[self setPinchGR:nil];
	[self setPanGR:nil];
	[self setZoomSlider:nil];
	[self setImageContainer:nil];
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
	[vImagePreview release];
	[touchView release];
	[pinchGR release];
	[panGR release];
	[zoomSlider release];
	[imageContainer release];
	[super dealloc];
}
	
-(IBAction) captureBtnClick:(id)sender
{
	//buttonClick=1;
	
	/*self.touchView.grabbedPoint = nil;
	self.touchView.grabbedLineObj = nil;
	// self.touchView.dragged = YES;
	[self.touchView setNeedsDisplay];
	[self.touchView drawRect:self.touchView.frame];*/
	
	UIGraphicsBeginImageContext(self.vImagePreview.bounds.size);
	[vImagePreview.layer renderInContext:UIGraphicsGetCurrentContext()];
	[touchView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage* finalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSDictionary* d;
	
	if (self.measureType == 0)
	{
		MeasureLine* lev = [self.touchView lineByName:@"Left Eye Vertical"];
		MeasureLine* rev = [self.touchView lineByName:@"Right Eye Vertical"];
		//MeasureLine* lfb = [self.touchView lineByName:@"Left Frame Box"];
		//MeasureLine* rfb = [self.touchView lineByName:@"Right Frame Box"];
		MeasureLine* lfb = [self.touchView lineByName:@"Left Frame Bottom Horizontal"];
		MeasureLine* rfb = [self.touchView lineByName:@"Right Frame Bottom Horizontal"];        
		MeasureLine* bridge = [self.touchView lineByName:@"Bridge Vertical"];
			
		if (lev && rev && lfb && rfb && bridge)
		{
			float abox = [[frameXML getTextValueByName:@"ABox"] floatValue];
			float bbox = [[frameXML getTextValueByName:@"BBox"] floatValue];
			
			float rScaleABox = [self transformPixelsToRealDistance:rfb.run]; // / 52.0f;
			float rScaleBBox = [self transformPixelsToRealDistance:rfb.rise]; // / 31.0f;
            //float rScaleABox = [self transformPixelsToRealDistance:52.0f];
			//float rScaleBBox = [self transformPixelsToRealDistance:48.0f];
            
			NSLog(@"R ABox in mm: %f", rScaleABox);
			NSLog(@"R BBox in mm: %f", rScaleBBox);
			
			rScaleABox /= abox;
			rScaleBBox /= bbox;
			
			float lScaleABox = [self transformPixelsToRealDistance:lfb.run]; // / 52.0f;
			float lScaleBBox = [self transformPixelsToRealDistance:lfb.rise]; // / 31.0f;			
            //float lScaleABox = [self transformPixelsToRealDistance:52.0f];
			//float lScaleBBox = [self transformPixelsToRealDistance:48.0f];
            
			NSLog(@"L ABox in mm: %f", lScaleABox);
			NSLog(@"L BBox in mm: %f", lScaleBBox);
			
			lScaleABox /= abox;
			lScaleBBox /= bbox;
			
			float rDistPD = [self transformPixelsToRealDistance:bridge.lowerPoint.x - rev.lowerPoint.x]; ///rScaleABox + 0;
			float lDistPD = [self transformPixelsToRealDistance:lev.lowerPoint.x - bridge.lowerPoint.x]; ///lScaleABox + 0;
			float rHeight = [self transformPixelsToRealDistance:rfb.lowerPoint.y - rev.lowerPoint.y]; /// rScaleBBox + 0;
			float lHeight = [self transformPixelsToRealDistance:lfb.lowerPoint.y - lev.lowerPoint.y];// / lScaleBBox + 0;
			
			d = [[NSDictionary alloc] initWithObjectsAndKeys:
				 [NSNumber numberWithFloat:rDistPD], @"RightDistPD",
				 [NSNumber numberWithFloat:lDistPD], @"LeftDistPD",
				 [NSNumber numberWithFloat:rHeight], @"RightHeight",
				 [NSNumber numberWithFloat:lHeight], @"LeftHeight",
				 finalImage, @"FinalImage",
				 nil];
		}
		else
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Required data not found for measurement." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
			
			return;
		}
	}
	else if (self.measureType == 1)
	{
		MeasureLine* lev = [self.touchView lineByName:@"Left Eye Vertical"];
		MeasureLine* rev = [self.touchView lineByName:@"Right Eye Vertical"];
		MeasureLine* lfb = [self.touchView lineByName:@"Left Frame Box"];
		MeasureLine* rfb = [self.touchView lineByName:@"Right Frame Box"];
		MeasureLine* bridge = [self.touchView lineByName:@"Bridge Vertical"];
		
		if (lev && rev && lfb && rfb && bridge)
		{
			float abox = [[frameXML getTextValueByName:@"ABox"] floatValue];
			float bbox = [[frameXML getTextValueByName:@"BBox"] floatValue];
			
			float rScaleABox = [self transformPixelsToRealDistance:rfb.run]; // / 52.0f;
			float rScaleBBox = [self transformPixelsToRealDistance:rfb.rise]; // / 31.0f;
			
			NSLog(@"R ABox in mm: %f", rScaleABox);
			NSLog(@"R BBox in mm: %f", rScaleBBox);
			
			rScaleABox /= abox;
			rScaleBBox /= bbox;
			
			float lScaleABox = [self transformPixelsToRealDistance:lfb.run]; // / 52.0f;
			float lScaleBBox = [self transformPixelsToRealDistance:lfb.rise]; // / 31.0f;			
			
			NSLog(@"L ABox in mm: %f", lScaleABox);
			NSLog(@"L BBox in mm: %f", lScaleBBox);
			
			lScaleABox /= abox;
			lScaleBBox /= bbox;
			
			float rNearPD = [self transformPixelsToRealDistance:bridge.lowerPoint.x - rev.lowerPoint.x]; // /rScaleABox + 0;
			float lNearPD = [self transformPixelsToRealDistance:lev.lowerPoint.x - bridge.lowerPoint.x]; // /lScaleABox + 0;
			
			d = [[NSDictionary alloc] initWithObjectsAndKeys:
				 [NSNumber numberWithFloat:rNearPD], @"RightNearPD",
				 [NSNumber numberWithFloat:lNearPD], @"LeftNearPD",
				 finalImage, @"FinalImage",			 
				 nil];	
		}
		else
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Required data not found for measurement." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
			
			return;
		}
	}
	else if (self.measureType == 2)
	{
		MeasureLine* vu = [self.touchView lineByName:@"Vertical Up"];
		MeasureLine* vd = [self.touchView lineByName:@"Vertical Down"];
		MeasureLine* fa = [self.touchView lineByName:@"Frame Across"];
		
		if (vu && vd && fa)
		{
			MeasurePoint *shared = [fa sharedPoint:vu];
			MeasureLine *cl;
			if (fa.lowerPoint.y > shared.y)
				cl = vd;
			else
				cl = vu;
			
			float pantho = [[cl angleBetween:fa] floatValue];
			
			d = [[NSDictionary alloc] initWithObjectsAndKeys:
				 [NSNumber numberWithFloat:pantho], @"Pantho",
				 finalImage, @"FinalImage",			 
				 nil];				
		}
		else
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Required data not found for measurement." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
			
			return;
		}
	}
	else if (self.measureType == 3)
	{
		
		MeasureLine* l1 = [self.touchView lineByName:@"Line Across Frame"];
		MeasureLine* l2 = [self.touchView lineByName:@"Line Across Eye"];
		
		if (l1 && l2)
		{
			CGPoint l2m = l2.midpoint;
			
			float vertex = [self transformPixelsToRealDistance:[l1 distanceFromLineTo:l2m]];
			
			d = [[NSDictionary alloc] initWithObjectsAndKeys:
				 [NSNumber numberWithFloat:vertex], @"Vertex",
				 finalImage, @"FinalImage",			 			 
				 nil];
		}
		else
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Required data not found for measurement." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
			
			return;
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MeasurePictureDidCalculateMeasurement" object:self userInfo:d];
	
	[self.navigationController popViewControllerAnimated:YES];
	
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

- (float) transformPixelsToRealDistance:(float)pixels;
{
	return pixels * 25.4 / 132.0;
}

- (IBAction)cancelMeasure:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)moveSelectedUp:(id)sender {
	[self moveSelectedPoint:@"up" X:0 Y:-1];
}

- (IBAction)moveSelectedDown:(id)sender {
	[self moveSelectedPoint:@"down" X:0 Y:1];
}

- (IBAction)moveSelectedLeft:(id)sender {
	[self moveSelectedPoint:@"left" X:-1 Y:0];
}

- (IBAction)moveSelectedRight:(id)sender {
	[self moveSelectedPoint:@"right" X:1 Y:0];
}

- (IBAction)resetBtnClick:(id)sender {
	[self beginMeasureProcess];
}

- (void) moveSelectedPoint:(NSString*)dir X:(int)x Y:(int)y
{
	MeasurePoint* mp = self.touchView.grabbedPoint;
	x = x * 2;
	y = y * 2;
	if (mp)
	{
		NSLog(@"move %@", dir);
		if (!self.touchView.grabbedOtherRectPoint)
		{
			[self.touchView movePoint:mp to:CGPointMake(mp.x+x, mp.y+y)];
		}
		else
		{
			NSArray *a = [self.touchView linesWithPoint:mp];
			for (MeasureLine *l in a)
			{
				if (mp == l.start)
				{
					[self.touchView movePoint:mp to:CGPointMake(l.end.x+x, l.start.y+y)];
				}
				else if (mp == l.end)
				{
					[self.touchView movePoint:mp to:CGPointMake(l.start.x+x, l.end.y+y)];					
				}
					
			}
		}
	}	
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"%d touches", [touches count]);
		
	int numTouches = [[event allTouches] count];
	UITouch *t = [[touches allObjects] objectAtIndex:0];
	CGPoint p = [t locationInView:self.touchView];
	
	if (numTouches == 1 && [self.touchView pointInside:p withEvent:event])
	{
        [self nextProcessStep:event notification:nil];
		
		if (!self.zoomSlider.isEnabled && [self.touchView.points count] >= 2)
		{
			[self.zoomSlider setEnabled:YES];
		}
	}
	else
	{
		[self.nextResponder touchesEnded:touches withEvent:event];
	}
	

	
}

//- (void) nextProcessStep:(MeasureProcessStep*)ps

- (void)touchViewAddedLine:(NSNotification*)n
{
    [self nextProcessStep:nil notification:n];
}

-(IBAction)scale:(id)sender
{
	UIPinchGestureRecognizer *pgr = (UIPinchGestureRecognizer*)sender;
	
	if (pgr.state == UIGestureRecognizerStateBegan)
	{
		NSLog(@"Pinch began");
		initialTrans = self.vImagePreview.transform;
		initialScale = pgr.scale;
		currentScale = [[self.vImagePreview.layer valueForKeyPath:@"transform.scale"] floatValue];
	}
	else if (pgr.state == UIGestureRecognizerStateChanged)
	{
		NSLog(@"pinch scale: %f", pgr.scale);
		
		//CGRect r = self.vImagePreview.frame;
		
		float scale = 1 - (initialScale - pgr.scale);
		scale = MIN(scale, maxScale / currentScale);
		scale = MAX(scale, minScale / currentScale);
		
		CGAffineTransform trans = CGAffineTransformScale(initialTrans, scale, scale);

		self.vImagePreview.transform = trans;	
		self.touchView.transform = trans;
		//self.vImagePreview.frame = r;
	}
	else if (pgr.state == UIGestureRecognizerStateEnded)
	{
		NSLog(@"Pinch ended");
	}
}

- (IBAction)pan:(id)sender {
	
	UIPanGestureRecognizer *pgr = (UIPanGestureRecognizer*)sender;
	
	if (!self.touchView.canAddLines && !self.touchView.dragged)
	{
		if (pgr.state == UIGestureRecognizerStateBegan)
		{
			NSLog(@"Pan began");
			initialLocation = self.vImagePreview.frame;
			/*initialTrans = self.vImagePreview.transform;
			initialScale = pgr.scale;
			currentScale = [[self.vImagePreview.layer valueForKeyPath:@"transform.scale"] floatValue];*/
		}
		else if (pgr.state == UIGestureRecognizerStateChanged)
		{
			CGPoint p = [pgr translationInView:self.vImagePreview];
			NSLog(@"Pan velocity: %f, %f", p.x, p.y);
			CGRect r = CGRectMake(initialLocation.origin.x + p.x, initialLocation.origin.y + p.y, initialLocation.size.width, initialLocation.size.height);
			self.vImagePreview.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height);
			self.touchView.frame = self.vImagePreview.frame;
			
			/*CGAffineTransform trans = CGAffineTransformScale(initialTrans, scale, scale);
			
			self.vImagePreview.transform = trans;	
			self.touchView.transform = trans;
			//self.vImagePreview.frame = r;*/
		}
		else if (pgr.state == UIGestureRecognizerStateEnded)
		{
			NSLog(@"Pan ended");
		}
	}
	else
	{
		pgr.cancelsTouchesInView = NO;
	}
}

- (IBAction)testBlendMode:(id)sender {
	blendMode++;
	[self.touchView setNeedsDisplay];
}

- (IBAction)zoomSliderChanged:(id)sender {
	
	BOOL isRight = self.zoomSlider.value < 0;
	BOOL isLeft = self.zoomSlider.value > 0;
	float portion = ABS(self.zoomSlider.value / self.zoomSlider.maximumValue);
	float scale = ABS(self.zoomSlider.value / 50) + 1;
	
	CGPoint o = [self.vImagePreview center];
	CGPoint rp = CGPointMake(0,0);
	
	float xdist = 0, ydist = 0;
	
	if (isRight)
	{
		rp = self.rightEyePoint;
	}
	else if (isLeft)
	{
		rp = self.leftEyePoint;
	}
	
	xdist = o.x - rp.x;
	ydist = o.y - rp.y;
	
	NSLog(@"%f,%f - %f,%f -> %f, %f", o.x, o.y, rp.x, rp.y, xdist, ydist);

	
	CGAffineTransform trans = CGAffineTransformIdentity;
	trans = CGAffineTransformTranslate(trans, xdist * portion * scale * 1.5, ydist * portion * scale);
	trans = CGAffineTransformScale(trans, scale, scale);
	
	self.vImagePreview.transform = trans;
	self.touchView.transform = trans;
}

- (IBAction)zoomSliderTouched:(id)sender {
	if ([self.touchView.points count] < 2)
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Zooming requires that the pupils have been found.  Please identify the pupils." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];		
	}
}

@end

/*@implementation MeasureProcessStep

+ (MeasureProcessStep *) stepWithEvent:(UIEvent *)event
{
    MeasureProcessStep *obj = [[MeasureProcessStep alloc] initWithEvent:event notification:nil];
    return obj;
}

+ (MeasureProcessStep *) stepWithNotification:(NSNotification *)n
{
    MeasureProcessStep *obj = [[MeasureProcessStep alloc] initWithEvent:nil notification:n];    
}

- (MeasureProcessStep *) initWithEvent:(UIEvent *)event notification:(NSNotification *)n
{
    if (self = [self init])
    {
        _event = event;
        _notification = n;
    }
    return self;
}

@end*/
