//
//  LineView.m
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MeasureLine.h"

@implementation MeasureLine

@synthesize start;
@synthesize end;
@synthesize midpoint;
@synthesize name;

@synthesize dragged;

@synthesize lineColor;
@synthesize isRect;

@synthesize startLockX, startLockY, endLockX, endLockY, startMovesEnd, endMovesStart;
@synthesize relatedLines;

-(id) init
{
	if (self = [super init])
	{
		//self.lineColor = [UIColor whiteColor];
		self.lineColor = [UIColor cyanColor];
        
        self.relatedLines = [[NSMutableArray alloc] init];
	}
	return self;
}
-(id) initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
	if (self = [self init])
	{
		self.start = [[MeasurePoint alloc] initWithPoint:startPoint];
		self.end = [[MeasurePoint alloc] initWithPoint:endPoint];
        
		NSLog(@"%@", self.start);
		NSLog(@"%@", self.end);
		
	}
	return self;
}
#pragma mark Getters

-(CGPoint) midpoint
{
	return CGPointMake((self.end.x - self.start.x) / 2 + self.start.x, (self.end.y - self.start.y) / 2 + self.start.y);
}

-(MeasurePoint*) upperPoint { return (self.start.y > self.end.y) ? self.end : self.start; }
-(MeasurePoint*) lowerPoint { return (self.start.y < self.end.y) ? self.end : self.start; }
-(MeasurePoint*) leftPoint { return (self.start.x > self.end.x) ? self.end : self.start; }
-(MeasurePoint*) rightPoint { return (self.start.x < self.end.x) ? self.end : self.start; }

-(float) length { return [self distanceFromStartToEnd]; }

-(float) rise { return self.lowerPoint.y - self.upperPoint.y; }
-(float) run { return self.rightPoint.x - self.leftPoint.x; }
-(NSNumber*) slope { if (self.run != 0) return [NSNumber numberWithFloat:(self.rise / self.run)]; return nil; }

#pragma mark Setters
/*-(void) setStart: (MeasurePoint*) mp
{
	start = [self fromPoint:self.start toPoint:s lockX:self.lockPointX lockY:self.lockPointY];
}

-(void) setEnd: (CGPoint) s
{
	end = [self fromPoint:self.end toPoint:s lockX:self.lockPointX lockY:self.lockPointY];
}*/

/*-(void) setStart:(CGPoint)point
{
	start.point = [self.start fromPoint:self.start.point toPoint:point lockX:self.lockX lockY:self.lockY];
}

-(void) setEnd:(CGPoint)point
{
	end.point = [self.end fromPoint:self.end.point toPoint:point lockX:self.lockX lockY:self.lockY];
}*/

-(void) setMidpoint:(CGPoint) e
{
	CGPoint currentMid = self.midpoint;
	
	float xd = e.x - currentMid.x;
	float yd = e.y - currentMid.y;

	start.point = [start fromPoint:self.start.point toPoint:CGPointMake(self.start.x + xd, self.start.y + yd) lockX:NO lockY:NO];
	end.point = [end fromPoint:self.end.point toPoint:CGPointMake(self.end.x + xd, self.end.y + yd) lockX:NO lockY:NO];
}

#define CIRCLE_COLOR [UIColor whiteColor]

#define LINE_WIDTH    2
#define CIRCLE_RADIUS 4

#define MID_GRAB_SIZE 10

- (void)movePoint:(MeasurePoint *)mp from:(CGPoint)from to:(CGPoint)to
{
	[self movePoint:mp from:from to:to recurse:YES];
}
- (void)movePoint:(MeasurePoint*)mp from:(CGPoint)from to:(CGPoint)to recurse:(BOOL)recurse
{
    [self movePoint:mp from:from to:to recurse:recurse override:NO];
}

- (void)movePoint:(MeasurePoint*)mp from:(CGPoint)from to:(CGPoint)to recurse:(BOOL)recurse override:(BOOL)override
{
	CGPoint moved = CGPointMake(to.x - from.x, to.y - from.y);
	NSLog(@"Line move point: %f,%f", moved.x, moved.y);
	
	if (mp == self.start)
		mp.point = [self.start fromPoint:from toPoint:to lockX:self.startLockX lockY:self.startLockY override:override];
	else if (mp == self.end)
		mp.point = [self.end fromPoint:from toPoint:to lockX:self.endLockX lockY:self.endLockY override:override];
	
	if (recurse)
		[self adjustForPoint:mp moved:moved];
}

- (void)adjustForPoint:(MeasurePoint*)mp moved:(CGPoint)moved
{
	
	if (mp == self.start)
	{
		if (self.startMovesEnd)
		{
			NSLog(@"Start is moving end.");
			[self movePoint:self.end from:mp.point to:CGPointMake(self.end.x + moved.x, self.end.y + moved.y) recurse:NO];
		}
	}		
	else if (mp == self.end)
	{
		if (self.endMovesStart)
		{
			NSLog(@"End is moving start.");
			[self movePoint:self.start from:mp.point to:CGPointMake(self.start.x + moved.x, self.start.y + moved.y) recurse:NO];		
		}
	}
    
    for (MeasureLine *l in self.relatedLines)
    {
        if (mp != [self sharedPoint:l])
        {
            NSLog(@"Checking related line: %@", l.name);
            if (![self containsPoint:l.start])
            {
                NSLog(@"-- RL unique start: %f,%f", l.start.x, l.start.y);
                
                [l movePoint:l.start from:l.start.point to:CGPointMake(l.start.point.x + moved.x, l.start.point.y + moved.y) recurse:NO override:YES];
            
                NSLog(@"-- RL unique start after: %f,%f", l.start.x, l.start.y);
            }
            if (![self containsPoint:l.end])
            {
                NSLog(@"-- RL unique end: %f,%f", l.end.x, l.end.y);
                
                [l movePoint:l.end from:l.end.point to:CGPointMake(l.end.point.x + moved.x, l.end.point.y + moved.y) recurse:NO override:YES];
                
                NSLog(@"-- RL unique end after: %f,%f", l.end.x, l.end.y);
            }
        }
    }
}

- (BOOL) containsPoint:(MeasurePoint*)mp
{
    return (mp == self.start || mp == self.end);
}

- (void)drawRect:(CGRect)rect withColor:(UIColor*)color
{
	UIColor* useColor = color;
	
	if (!useColor)
	{
		useColor = self.lineColor;
		if (self.start.dragged || self.end.dragged)
			useColor = [UIColor greenColor];
	}
	
    CGContextRef c = UIGraphicsGetCurrentContext();
	
	//NSLog(@"line drawn");
    //if(dragged) {
	
	if (!self.isRect)
	{
        [useColor setStroke];
        CGContextMoveToPoint(c, start.x, start.y);
        CGContextAddLineToPoint(c, end.x, end.y);        
        CGContextSetLineWidth(c, LINE_WIDTH); 
        CGContextClosePath(c);
        CGContextStrokePath(c);
	
		[self.start drawPoint:rect withColor:nil];
		[self.end drawPoint:rect withColor:nil];
	}
	else
	{
		[useColor setStroke];
		CGContextStrokeRect(c, CGRectMake(self.leftPoint.x, self.upperPoint.y, self.run, self.rise));

		[self.start drawPoint:rect withColor:nil];
		[self.end drawPoint:rect withColor:nil];
		[self.start drawPoint:rect at:CGPointMake(self.start.x, self.end.y) withColor:nil];
		[self.start drawPoint:rect at:CGPointMake(self.end.x, self.start.y) withColor:nil];
		
	}
	
	
    /*    [CIRCLE_COLOR setFill];
        CGContextAddArc(c, start.x, start.y, CIRCLE_RADIUS, 0, M_PI*2, YES);
        CGContextClosePath(c);
        CGContextFillPath(c);
		
        CGContextAddArc(c, end.x, end.y, CIRCLE_RADIUS, 0, M_PI*2, YES);
        CGContextClosePath(c);
        CGContextFillPath(c);*/
	
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

- (float) distanceFromStartTo:(CGPoint)p
{
	return [self distanceFrom:self.start.point to:p];
}

- (float) distanceFromEndTo:(CGPoint)p
{
	return [self distanceFrom:self.end.point to:p];
}

- (float) distanceFromMidpointTo:(CGPoint)p
{
	return [self distanceFrom:self.midpoint to:p];
}

- (float) distanceFromStartToEnd
{
	return [self distanceFrom:self.start.point to:self.end.point];	
}
/*- (float) distanceFromLineTo:(CGPoint)p
{
	float d = [self distanceFromStartToEnd];
	float d2 = abs((self.end.x - self.start.x) * p.x + (self.end.y - self.start.y) * p.y) / d;
	return d2;
}*/

- (void) setLockPointX:(BOOL)state
{
	self.start.lockX = state;
	self.end.lockX = state;
}

- (void) setLockPointY:(BOOL)state
{
	self.start.lockY = state;
	self.end.lockY = state;
}

- (MeasurePoint*) otherPointThan:(MeasurePoint*) mp
{
	if (self.start == mp)
		return self.end;
	else if (self.end == mp)
		return self.start;
	
	return nil;
}

- (MeasurePoint*) sharedPoint:(MeasureLine*) l
{
	if (self.start == l.start || self.start == l.end)
		return self.start;
	else if (self.end == l.start || self.end == l.end)
		return self.end;
	
	return nil;
}

- (MeasurePoint*) nonSharedPoint:(MeasureLine*) l
{
    return [self otherPointThan:[self sharedPoint:l]];
}

- (NSNumber*) angleBetween:(MeasureLine*)l
{
	MeasurePoint *mp = [self sharedPoint:l];

	if (mp)
	{
		MeasurePoint *otherPoint1 = [self otherPointThan:mp];
		MeasurePoint *otherPoint2 = [l otherPointThan:mp];
		
		float lineA = self.length;
		float lineB = l.length;
		float lineC = [self distanceFrom:otherPoint1.point to:otherPoint2.point];
		
		float numerator = powf(lineA, 2) + powf(lineB, 2) - powf(lineC, 2);
		float denominator = 2 * lineA * lineB;
		
		float angle = acosf(numerator / denominator) * 180 / M_PI;
		
		return [NSNumber numberWithFloat:angle];
	}
	
	return nil;
}
- (void)dealloc 
{
    [super dealloc];
}

- (CGPoint) closestPointTo:(CGPoint)p
{
    CGPoint v = CGPointMake(self.end.x - self.start.x, self.end.y - self.start.y);
    CGPoint w = CGPointMake(p.x - self.start.x, p.y - self.start.y);
    float c1 = [self dotProduct:w p2:v];
    float c2 = [self dotProduct:v p2:v];

    if (c1 <= 0) {
		return self.start.point;
    }
    else if (c2 <= c1) {
		return self.end.point;
    }
    else {
        float b = c1 / c2;
        return CGPointMake(self.start.x + b * v.x, self.start.y + b * v.y);
    }
}

- (float) distanceFromLineTo:(CGPoint)p {

	CGPoint Pb = [self closestPointTo:p];
    float d = [self distance:p p2:Pb];
    return d;
}

- (float) distance:(CGPoint)p1 p2:(CGPoint)p2 {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

- (float) dotProduct:(CGPoint)p1 p2:(CGPoint)p2 {
    return p1.x * p2.x + p1.y * p2.y;
}

@end