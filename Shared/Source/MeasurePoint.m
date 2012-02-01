//
//  LineView.m
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MeasurePoint.h"

extern int blendMode;

@implementation MeasurePoint

@synthesize x,y;
@synthesize point;
@synthesize handPoint;

@synthesize name;

@synthesize lockX, lockY;
@synthesize dragged;

@synthesize hasHand;
@synthesize handText;
@synthesize handWidth, handHeight;
@synthesize handOffsetX, handOffsetY;

- (id) initWithPoint:(CGPoint)pointArg
{
	if (self = [super init])
	{
		self.point = pointArg;
	}
	return self;
}
#pragma mark Getters

-(CGPoint) point
{
	return CGPointMake(self.x, self.y);
}

-(CGPoint) handPoint
{
	return CGPointMake(self.x + self.handOffsetX, self.y + self.handOffsetY);
}

/*-(CGPoint) midpoint
{
	return CGPointMake((self.end.x - self.start.x) / 2 + self.start.x, (self.end.y - self.start.y) / 2 + self.start.y);
}*/

#pragma mark Setters
-(void) setPoint: (CGPoint) s
{
	CGPoint sm = [self fromPoint:self.point toPoint:s lockX:self.lockX lockY:self.lockY];
	self.x = sm.x;
	self.y = sm.y;
}

- (CGPoint) fromPoint:(CGPoint)p toPoint:(CGPoint)s lockX:(BOOL)lx lockY:(BOOL)ly
{
    return [self fromPoint:p toPoint:s lockX:lx lockY:ly override:NO];
}

- (CGPoint) fromPoint:(CGPoint)p toPoint:(CGPoint)s lockX:(BOOL)lx lockY:(BOOL)ly override:(BOOL)override
{
    if (!override)
        p = CGPointMake(lx ? p.x : s.x, ly ? p.y : s.y);
    else
        p = s;
	return p;
}

#define LINE_COLOR   [UIColor whiteColor]
#define CIRCLE_COLOR [UIColor whiteColor]

#define LINE_WIDTH    2
#define CIRCLE_RADIUS 4

#define MID_GRAB_SIZE 10

-(void) setHand:(BOOL)isSet text:(NSString*)text width:(float)width height:(float)height offsetX:(float)offsetX offsetY:(float)offsetY
{
	self.hasHand = isSet;
	self.handText = text;
	self.handWidth = width;
	self.handHeight = height;
	self.handOffsetX = offsetX;
	self.handOffsetY = offsetY;
}

- (void)movePointTo:(CGPoint)pointArg
{
	self.point = pointArg;
}

- (void)drawPoint:(CGRect)rect withColor:(UIColor *)color
{
	[self drawPoint:rect at:self.point withColor:color];
}

- (void)drawPoint:(CGRect)rect at:(CGPoint)at withColor:(UIColor *)color
{
    CGContextRef c = UIGraphicsGetCurrentContext();
	
	UIColor* useColor = color;
	if (!useColor)
	{
		useColor = LINE_COLOR;
		if (self.dragged)
			useColor = [UIColor greenColor];
	}
	
	//NSLog(@"point drawn");
    //if(dragged) {
        [useColor setStroke];
        [useColor setFill];
        CGContextAddArc(c, at.x, at.y, CIRCLE_RADIUS, 0, M_PI*2, YES);
        CGContextClosePath(c);
        CGContextFillPath(c);

	
	if (self.hasHand)
	{
		CGContextSaveGState(c);
		
		CGContextSetShadowWithColor(c, CGSizeMake(3.0f,3.0f), 3.0f, nil);
		
		UIColor* handColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
		UIColor* handColorOutline = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
		[handColor setFill];
		[handColorOutline setStroke];

		//CGContextBeginTransparencyLayer(c, nil);
		
		CGPoint handPointCenter = CGPointMake(at.x + self.handOffsetX, at.y + self.handOffsetY);
		
		CGRect handleRect = CGRectMake(handPointCenter.x - 5, handPointCenter.y, 10, (at.y - handPointCenter.y) - 5);
		
		CGContextFillRect(c, handleRect);
		
		CGRect er = CGRectMake(handPointCenter.x - handWidth / 2,  handPointCenter.y - handHeight / 2, handWidth, handHeight);
		
		CGContextStrokeRect(c, handleRect);
		
		CGContextSetBlendMode(c, kCGBlendModeCopy);
		CGContextFillEllipseInRect(c, er);
		CGContextStrokeEllipseInRect(c, er);
		CGContextSetBlendMode(c, kCGBlendModeNormal);
		
		//CGContextEndTransparencyLayer(c);
		
		UIFont* font = [UIFont boldSystemFontOfSize:24.0f];
		CGSize textSize = [self.handText sizeWithFont:font];
		CGPoint handPointText = CGPointMake(handPointCenter.x - textSize.width / 2, handPointCenter.y - textSize.height / 2);
		[[UIColor whiteColor] setFill];
		
		CGContextSetShadowWithColor(c, CGSizeMake(5.0f,5.0f), 3.0f, [[UIColor blackColor] CGColor]);
		[self.handText drawAtPoint:handPointText withFont:font];
		
		CGContextRestoreGState(c);
		
	}
	/*NSLog(@"str (%f, %f)", self.start.x, self.start.y);
	NSLog(@"mid (%f, %f)", self.midpoint.x, self.midpoint.y);
	NSLog(@"end (%f, %f)", self.end.x, self.end.y);*/
	//CGContextAddArc(c, self.midpoint.x, self.midpoint.y, CIRCLE_RADIUS, 0, M_PI*2, YES);
	//CGContextClosePath(c);
	//CGContextFillPath(c);
	
		/*CGContextAddRect(c, CGRectMake(self.midpoint.x - MID_GRAB_SIZE / 2, self.midpoint.y - MID_GRAB_SIZE / 2, MID_GRAB_SIZE, MID_GRAB_SIZE));
		CGContextClosePath(c);
		CGContextFillPath(c);*/
	
    //}
}

- (float) distanceFrom:(CGPoint)p1 to:(CGPoint)p2
{
	float xd = p2.x - p1.x;
	float yd = p2.y - p1.y;
	return sqrt((xd * xd) + (yd * yd));
}

/*- (float) distanceFromLineTo:(CGPoint)p
{
	float d = [self distanceFromStartToEnd];
	float d2 = abs((self.end.x - self.start.x) * p.x + (self.end.y - self.start.y) * p.y) / d;
	return d2;
}*/

- (void)dealloc 
{
    [super dealloc];
}

@end