//
//  LineView.m
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LineView.h"

@implementation LineView
@synthesize dragged;
@synthesize grabbedEnd;
@synthesize grabbedMid;
@synthesize grabbedLine;
@synthesize grabbedHand;
@synthesize grabOffset;
@synthesize grabbedLineObj;
@synthesize grabbedPoint;
@synthesize grabbedOtherRectPoint;

@synthesize lines = _lines;
@synthesize points = _points;
@synthesize touches = _touches;

@synthesize nextLineIsRect;
@synthesize measureType;
@synthesize canAddLines;
@synthesize didAddLine;
@synthesize selectedColor;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self initData];
	}
	return self;
}

- (void) initData
{
	[self setLines:[[NSMutableArray alloc] initWithObjects:nil]];
	[self setPoints:[[NSMutableArray alloc] initWithObjects:nil]];
	[self setTouches:[[NSMutableArray alloc] initWithObjects:nil]];
	NSLog(@"lines alloced");
	self.backgroundColor = [UIColor clearColor];
	self.multipleTouchEnabled = YES;
	self.userInteractionEnabled = NO;
	self.canAddLines = NO;
	self.measureType = -1;
	self.selectedColor = [UIColor greenColor];
	[self setNeedsDisplay];
	self.nextLineIsRect = NO;
	self.grabbedLineObj = nil;
	self.grabbedPoint = nil;
	self.dragged = NO;
	self.grabbedEnd = NO;
	self.grabbedMid = NO;
	self.grabbedLine = NO;
}

- (MeasureLine*) createLineFrom:(CGPoint)start to:(CGPoint)end
{
	NSLog(@"adding line");
	MeasureLine* line = [[MeasureLine alloc] initWithStartPoint:start endPoint:end];
	
	[self.lines addObject:line];
	NSLog(@"self.lines after add: %@", self.lines);
	NSLog(@"number of lines after add: %d", [self.lines count]);
	
	return line;
}

- (MeasureLine*) createLineFromPoint:(MeasurePoint*)start to:(CGPoint)end
{
	NSLog(@"adding line from line");
	MeasureLine* line = [[MeasureLine alloc] init];
			
	line.start = start;
	line.end = [[MeasurePoint alloc] initWithPoint:end];
	
	[self.lines addObject:line];
	NSLog(@"self.lines after add: %@", self.lines);
	NSLog(@"number of lines after add: %d", [self.lines count]);
	
	return line;
	
}

- (MeasureLine*) createLineFrom:(CGPoint)start toPoint:(MeasurePoint*)end
{
	NSLog(@"adding line from line");
	MeasureLine* line = [[MeasureLine alloc] init];
	
	line.start = [[MeasurePoint alloc] initWithPoint:start];
	line.end = end;
	
	[self.lines addObject:line];
	NSLog(@"self.lines after add: %@", self.lines);
	NSLog(@"number of lines after add: %d", [self.lines count]);
	
	return line;
	
}

//#define LINE_COLOR [UIColor lightGrayColor]
#define LINE_COLOR [UIColor whiteColor]
#define LINE_WIDTH 2
#define ARROW_LENGTH 6

#define POINT_COLOR [UIColor redColor]
#define POINT_CROSS_SIZE 10

#define GRAB_POINT_DIST 50
#define GRAB_LINE_DIST 20
#define GRAB_MID_DIST 100

- (void)drawRect:(CGRect)rect 
{
	NSLog(@"number of lines: %d", [self.lines count]);
	//NSLog(@"number of touches: %d", [self.touches count]);

	CGContextRef c = UIGraphicsGetCurrentContext();
	
	if (self.measureType == 0 || self.measureType == 1)
	{
		MeasureLine* lev = [self lineByName:@"Left Eye Vertical"];
		MeasureLine* rev = [self lineByName:@"Right Eye Vertical"];
		MeasureLine* bv = [self lineByName:@"Bridge Vertical"];
		MeasureLine* rfb = [self lineByName:@"Right Frame Box"];
		MeasureLine* lfb = [self lineByName:@"Left Frame Box"];
		
		if (lev && rev && bv)
		{
			NSLog(@"found both eye verticals");
			CGContextRef c = UIGraphicsGetCurrentContext();
			
			//if(dragged) {
			[LINE_COLOR setStroke];
			CGContextMoveToPoint(c, lev.start.x, lev.start.y);
			CGContextAddLineToPoint(c, bv.start.x, lev.start.y);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);

			CGContextMoveToPoint(c, rev.start.x, rev.start.y);
			CGContextAddLineToPoint(c, bv.start.x, rev.start.y);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
            CGContextMoveToPoint(c, lev.start.x, lev.start.y);
			CGContextAddLineToPoint(c, lev.start.x - ARROW_LENGTH, lev.start.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
            
			CGContextMoveToPoint(c, lev.start.x, lev.start.y);
			CGContextAddLineToPoint(c, lev.start.x - ARROW_LENGTH, lev.start.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
            
            
			CGContextMoveToPoint(c, bv.start.x, rev.start.y);
			CGContextAddLineToPoint(c, bv.start.x - ARROW_LENGTH, rev.start.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, bv.start.x, rev.start.y);
			CGContextAddLineToPoint(c, bv.start.x - ARROW_LENGTH, rev.start.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, bv.start.x, lev.start.y);
			CGContextAddLineToPoint(c, bv.start.x + ARROW_LENGTH, lev.start.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, bv.start.x, lev.start.y);
			CGContextAddLineToPoint(c, bv.start.x + ARROW_LENGTH, lev.start.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH);
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rev.start.x, rev.start.y);
			CGContextAddLineToPoint(c, rev.start.x + ARROW_LENGTH, rev.start.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rev.start.x, rev.start.y);
			CGContextAddLineToPoint(c, rev.start.x + ARROW_LENGTH, rev.start.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
        }
			
        if (lev && rev && lfb && rfb)
        {
			
        
            CGContextMoveToPoint(c, lev.start.x, lev.start.y);
            CGContextAddLineToPoint(c, lev.start.x, lfb.lowerPoint.y);        
            CGContextSetLineWidth(c, LINE_WIDTH); 
            CGContextClosePath(c);
            CGContextStrokePath(c);
            
            CGContextMoveToPoint(c, rev.start.x, rev.start.y);
            CGContextAddLineToPoint(c, rev.start.x, rfb.lowerPoint.y);        
            CGContextSetLineWidth(c, LINE_WIDTH); 
            CGContextClosePath(c);
            CGContextStrokePath(c);
            
            /*CGContextMoveToPoint(c, rb.rightPoint.x, rb.midpoint.y);
             CGContextAddLineToPoint(c, bv.start.x, rb.midpoint.y);        
             CGContextSetLineWidth(c, LINE_WIDTH); 
             CGContextClosePath(c);
             CGContextStrokePath(c);
             
             CGContextMoveToPoint(c, lb.leftPoint.x, lb.midpoint.y);
             CGContextAddLineToPoint(c, bv.start.x, lb.midpoint.y);        
             CGContextSetLineWidth(c, LINE_WIDTH); 
             CGContextClosePath(c);
             CGContextStrokePath(c);*/
        
			CGContextMoveToPoint(c, lev.start.x, lev.start.y);
			CGContextAddLineToPoint(c, lev.start.x - ARROW_LENGTH, lev.start.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, lev.start.x, lev.start.y);
			CGContextAddLineToPoint(c, lev.start.x + ARROW_LENGTH, lev.start.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, lev.start.x, lfb.lowerPoint.y);
			CGContextAddLineToPoint(c, lev.start.x - ARROW_LENGTH, lfb.lowerPoint.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, lev.start.x, lfb.lowerPoint.y);
			CGContextAddLineToPoint(c, lev.start.x + ARROW_LENGTH, lfb.lowerPoint.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH);
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rev.start.x, rev.start.y);
			CGContextAddLineToPoint(c, rev.start.x - ARROW_LENGTH, rev.start.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rev.start.x, rev.start.y);
			CGContextAddLineToPoint(c, rev.start.x + ARROW_LENGTH, rev.start.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rev.start.x, rfb.lowerPoint.y);
			CGContextAddLineToPoint(c, rev.start.x - ARROW_LENGTH, rfb.lowerPoint.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rev.start.x, rfb.lowerPoint.y);
			CGContextAddLineToPoint(c, rev.start.x + ARROW_LENGTH, rfb.lowerPoint.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH);
			CGContextClosePath(c);
			CGContextStrokePath(c);
		}
		
		MeasureLine* lfch = [self lineByName:@"Left Frame Center Horizontal"];
		MeasureLine* lfbh = [self lineByName:@"Left Frame Bottom Horizontal"];
		
		if (lfch && lfbh)
		{
			NSLog(@"found both left frame horizontals");
			
            CGPoint cp = lfch.end.point;
            CGPoint bp = lfbh.end.point;
            
			if (lfch.end.x < lfbh.end.x)
                bp = CGPointMake(lfch.end.x, lfbh.end.y);
			else
                cp = CGPointMake(lfbh.end.x, lfch.end.y);
            
            if (self.grabbedPoint == lfch.end)
                lfbh.end.x = lfch.end.x;
            else if (self.grabbedPoint == lfbh.end)
                lfch.end.x = lfbh.end.x;
            
			[LINE_COLOR setStroke];
			CGContextMoveToPoint(c, cp.x, cp.y);
			CGContextAddLineToPoint(c, bp.x, bp.y);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, cp.x, cp.y);
			CGContextAddLineToPoint(c, cp.x - ARROW_LENGTH, cp.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, cp.x, cp.y);
			CGContextAddLineToPoint(c, cp.x + ARROW_LENGTH, cp.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, bp.x, bp.y);
			CGContextAddLineToPoint(c, bp.x - ARROW_LENGTH, bp.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
													  
			CGContextMoveToPoint(c, bp.x, bp.y);
			CGContextAddLineToPoint(c, bp.x + ARROW_LENGTH, bp.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
		}
		
		MeasureLine* rfch = [self lineByName:@"Right Frame Center Horizontal"];
		MeasureLine* rfbh = [self lineByName:@"Right Frame Bottom Horizontal"];
		
		if (rfch && rfbh)
		{
			NSLog(@"found both right frame horizontals");
			[LINE_COLOR setStroke];
			CGContextMoveToPoint(c, rfch.end.x, rfch.end.y);
			CGContextAddLineToPoint(c, rfbh.end.x, rfbh.end.y);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rfch.end.x, rfch.end.y);
			CGContextAddLineToPoint(c, rfch.end.x - ARROW_LENGTH, rfch.end.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rfch.end.x, rfch.end.y);
			CGContextAddLineToPoint(c, rfch.end.x + ARROW_LENGTH, rfch.end.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rfbh.end.x, rfbh.end.y);
			CGContextAddLineToPoint(c, rfbh.end.x - ARROW_LENGTH, rfbh.end.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, rfbh.end.x, rfbh.end.y);
			CGContextAddLineToPoint(c, rfbh.end.x + ARROW_LENGTH, rfbh.end.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
		}
	}
	else if (self.measureType == 2)
	{
		MeasureLine* vu = [self lineByName:@"Vertical Up"];
		MeasureLine* fa = [self lineByName:@"Frame Across"];
		
		if (vu && fa)
		{
			
			MeasurePoint* top;
			if (fa.start.y < fa.end.y)
				top = fa.start;
			else
				top = fa.end;
			
			int arrowMag = ARROW_LENGTH;
			
			if (top.x < vu.end.x)
				arrowMag = -arrowMag;
			
			[LINE_COLOR setStroke];
			CGContextMoveToPoint(c, vu.end.x, vu.end.y);
			CGContextAddLineToPoint(c, top.x, top.y);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, vu.end.x, vu.end.y);
			CGContextAddLineToPoint(c, vu.end.x + arrowMag, vu.end.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, vu.end.x, vu.end.y);
			CGContextAddLineToPoint(c, vu.end.x + arrowMag, vu.end.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, top.x, top.y);
			CGContextAddLineToPoint(c, top.x - arrowMag, top.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, top.x, top.y);
			CGContextAddLineToPoint(c, top.x - arrowMag, top.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);		
		}
	}
	else if (self.measureType == 3)
	{
		MeasureLine* l1 = [self lineByName:@"Line Across Frame"];
		MeasureLine* l2 = [self lineByName:@"Line Across Eye"];
		
		if (l1 && l2)
		{

			CGPoint l2m = l2.midpoint;
			CGPoint l1m = [l1 closestPointTo:l2m];
			
			int arrowMagX = ARROW_LENGTH;
			int arrowMagY = ARROW_LENGTH;
			
			if (l1m.x < l2m.x)
				arrowMagX = -arrowMagX;
			if (l1m.y < l2m.y)
				arrowMagY = -arrowMagY;
			
			[LINE_COLOR setStroke];
			CGContextMoveToPoint(c, l1m.x, l1m.y);
			CGContextAddLineToPoint(c, l2m.x, l2m.y);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, l1m.x, l1m.y);
			CGContextAddLineToPoint(c, l1m.x - arrowMagX, l1m.y);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, l1m.x, l1m.y);
			CGContextAddLineToPoint(c, l1m.x, l1m.y - arrowMagY);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, l2m.x, l2m.y);
			CGContextAddLineToPoint(c, l2m.x + arrowMagX, l2m.y);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, l2m.x, l2m.y);
			CGContextAddLineToPoint(c, l2m.x, l2m.y + arrowMagY);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			/*CGContextMoveToPoint(c, top.x, top.y);
			CGContextAddLineToPoint(c, top.x - arrowMag, top.y - ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);
			
			CGContextMoveToPoint(c, top.x, top.y);
			CGContextAddLineToPoint(c, top.x - arrowMag, top.y + ARROW_LENGTH);        
			CGContextSetLineWidth(c, LINE_WIDTH); 
			CGContextClosePath(c);
			CGContextStrokePath(c);*/
		}
	}
	
	for (MeasureLine* l in self.lines)
	{
		[l drawRect:rect withColor:nil];
	}
	
	for (MeasurePoint* p in self.points) // TEMPORARY
	{
        [POINT_COLOR setStroke];
        CGContextMoveToPoint(c, p.x - POINT_CROSS_SIZE, p.y);
        CGContextAddLineToPoint(c, p.x + POINT_CROSS_SIZE, p.y);        
        CGContextSetLineWidth(c, LINE_WIDTH); 
        CGContextClosePath(c);
        CGContextStrokePath(c);
		
		CGContextMoveToPoint(c, p.x, p.y - POINT_CROSS_SIZE);
        CGContextAddLineToPoint(c, p.x, p.y + POINT_CROSS_SIZE);        
        CGContextSetLineWidth(c, LINE_WIDTH); 
        CGContextClosePath(c);
        CGContextStrokePath(c);
	}
}

- (MeasureLine*) lineByName:(NSString*)searchName
{
	for (MeasureLine* l in self.lines)
		if ([l.name isEqualToString:searchName])
		{
			NSLog(@"Found line! '%@' = '%@'", l.name, searchName);
			return l;
		}

	return nil;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"%d touches", [touches count]);
	
	int numTouches = [[event allTouches] count];
	
	if (numTouches == 1)
	{
	NSLog(@"TOUCHES BEGAN");
	UITouch *t = [[touches allObjects] objectAtIndex:0];
	CGPoint p = [t locationInView:self];
	
	[self.touches addObjectsFromArray:[touches allObjects]];
	
	self.didAddLine = NO;
	
	if (canAddLines)
	{
		MeasureLine* l = [self createLineFrom:p to:p];
		l.lineColor = [UIColor cyanColor];
		
		if (nextLineIsRect)
		{
			l.isRect = YES;
		}
		
		self.grabbedPoint = l.end;
		self.didAddLine = YES;
		grabbedEnd = YES;
	}
	
	if (!didAddLine)
	{
		float grabDist = 9999;
		
		if (self.grabbedPoint)
			self.grabbedPoint.dragged = NO;
		
		self.grabbedLineObj = nil;
		self.grabbedPoint = nil;
		
		self.grabbedOtherRectPoint = NO;
		
		for (MeasureLine* l in self.lines)
		{
			float startDist = [l distanceFromStartTo:p];
			float endDist = [l distanceFromEndTo:p];
			float startOtherDist = [l distanceFrom:CGPointMake(l.end.x, l.start.y) to:p];
			float endOtherDist = [l distanceFrom:CGPointMake(l.start.x, l.end.y) to:p];
			float startHandDist = [l distanceFrom:l.start.handPoint to:p];
			float endHandDist = [l distanceFrom:l.end.handPoint to:p];
			
			//float midDist = [l distanceFromMidpointTo:p];
			float lineDist = [l distanceFromLineTo:p];
			NSLog(@"distance to line: %f, start: %f, end: %f", lineDist, startDist, endDist);
			
			if (startDist < GRAB_POINT_DIST && startDist < grabDist)
			{
				grabDist = startDist;
				self.grabbedPoint = l.start;
				self.grabbedLineObj = nil;				
				grabbedEnd = NO;
				grabbedMid = NO;
				grabbedHand = NO;
				grabbedLine = NO;
			}
			
			else if (endDist < GRAB_POINT_DIST && endDist < grabDist)
			{
				grabDist = endDist;
				self.grabbedPoint = l.end;
				self.grabbedLineObj = nil;
				grabbedEnd = YES;
				grabbedMid = NO;
				grabbedHand = NO;
				grabbedLine = NO;			
			}
			
			else if (l.isRect && startOtherDist < GRAB_POINT_DIST && startOtherDist < grabDist)
			{
				grabDist = startOtherDist;
				self.grabbedPoint = l.start;
				self.grabbedLineObj = nil;				
				grabbedEnd = NO;
				grabbedMid = NO;
				grabbedHand = NO;
				grabbedLine = NO;
				grabbedOtherRectPoint = YES;
				NSLog(@"grabbed start other");
			}
			
			else if (l.isRect && endOtherDist < GRAB_POINT_DIST && endOtherDist < grabDist)
			{
				grabDist = endOtherDist;
				self.grabbedPoint = l.end;
				self.grabbedLineObj = nil;
				grabbedEnd = YES;
				grabbedMid = NO;
				grabbedHand = NO;
				grabbedLine = NO;	
				grabbedOtherRectPoint = YES;
				NSLog(@"grabbed end other");
			}
			
			else if (l.start.hasHand && startHandDist < l.start.handWidth && startHandDist < grabDist)
			{
				grabDist = startHandDist;
				self.grabbedPoint = l.start;
				self.grabbedLineObj = nil;
				grabbedEnd = NO;
				grabbedMid = NO;
				grabbedHand = YES;
				grabbedLine = NO;
			}
			
			else if (l.end.hasHand && endHandDist < l.end.handWidth && endHandDist < grabDist)
			{
				grabDist = endHandDist;
				self.grabbedPoint = l.end;
				self.grabbedLineObj = nil;
				grabbedEnd = YES;
				grabbedMid = NO;
				grabbedHand = YES;
				grabbedLine = NO;			
			}
			
			/*else if (midDist < GRAB_MID_DIST && midDist < grabDist)
			{
				grabDist = midDist;
				grabbedLineObj = l;
				grabbedEnd = NO;
				grabbedMid = YES;
				grabbedLine = NO;
			}*/
			
			/*else if (lineDist < GRAB_LINE_DIST && lineDist < grabDist)
			{
				grabDist = lineDist;
				self.grabbedPoint = nil;
				self.grabbedLineObj = l;
				grabbedEnd = NO;
				grabbedMid = NO;
				grabbedLine = YES;
			}*/
			
			//grabOffset = CGPointMake(p.x - l.midpoint.x, p.y - l.midpoint.y);
		}
		
		if (self.grabbedPoint)
		{
			self.grabbedPoint.dragged = YES;
			self.dragged = YES;
		}
	}

	[self setNeedsDisplay];
	}
	else
	{
		[self.nextResponder touchesBegan:touches withEvent:event];
	}
}

- (void) setNeedsDisplay
{
    self.dragged = YES;
    [super setNeedsDisplay];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *t = [[touches allObjects] objectAtIndex:0];
	CGPoint p = [t locationInView:self];
	
	if (self.grabbedLineObj)
	{
		MeasureLine* l = self.grabbedLineObj;
		
		if (self.grabbedLine)
			[l setMidpoint:CGPointMake(p.x - self.grabOffset.x, p.y - self.grabOffset.y)];
		else if (self.grabbedMid)
			[l setMidpoint:p];
		
		NSLog(@"Line: %d, Mid: %d, End: %d", self.grabbedLine ? 1 : 0, self.grabbedMid ? 1 : 0, self.grabbedEnd ? 1 : 0);
		self.dragged = YES;
		[self setNeedsDisplay];
	}
	else if (self.grabbedPoint)
	{
		CGPoint fp = p;
		if (self.grabbedHand)
			fp = CGPointMake(fp.x - self.grabbedPoint.handOffsetX, fp.y - self.grabbedPoint.handOffsetY);
		
		[self movePoint:self.grabbedPoint to:fp];
	}
}

- (void) movePoint:(MeasurePoint*)point to:(CGPoint)p
{
	CGPoint old = [self.grabbedPoint point];
	for (MeasureLine *l in [self linesWithPoint:self.grabbedPoint])
	{
		NSLog(@"%@", l);
		if (!self.grabbedOtherRectPoint)
		{
			[l movePoint:self.grabbedPoint from:old to:p];
		}
		else
		{
			if (self.grabbedPoint == l.start)
			{
				[l movePoint:l.start from:l.start.point to:CGPointMake(l.start.x, p.y)];
				[l movePoint:l.end from:l.end.point to:CGPointMake(p.x, l.end.y)];
			}
			else if (self.grabbedPoint == l.end)
			{
				[l movePoint:l.start from:l.start.point to:CGPointMake(p.x, l.start.y)];
				[l movePoint:l.end from:l.end.point to:CGPointMake(l.end.x, p.y)];
			}
		}
		//[l adjustLineForPoint:self.grabbedPoint];
	}
	self.dragged = YES;
	[self setNeedsDisplay];	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"TOUCH END");
	
	if (self.didAddLine)
	{
		if (nextLineIsRect)
		{
			nextLineIsRect = NO;
		}
		
		NSDictionary* d;
		d = [[NSDictionary alloc] initWithObjectsAndKeys:
			 [self.lines objectAtIndex:[self.lines count]-1], @"AddedLine",
			 nil];	
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LineViewDidAddLine" object:self userInfo:d];
	}
	
	self.grabbedLine = NO;
	self.grabbedEnd = NO;
	self.grabbedMid = NO;
	self.grabbedHand = NO;
	
	//[self.grabbedLineObj release];
	
	self.dragged = NO;
	self.didAddLine = NO;
	
	[self.touches removeObjectsInArray:[touches allObjects]];
}

- (NSArray*) linesWithPoint:(MeasurePoint*)mp
{
	NSMutableArray* ma = [[NSMutableArray alloc] init];
	
	for (MeasureLine *l in self.lines)
	{
		if (l.start == mp || l.end == mp)
			[ma addObject:l];
	}
	
	return [NSArray arrayWithArray:ma];
}

- (void)dealloc 
{
    [super dealloc];
	
	NSLog(@"dealloc?");
}

@end