//
//  LineView.h
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasurePoint.h"

@interface MeasureLine : NSObject
{
	NSString* name;
	
	MeasurePoint* start;
	MeasurePoint* end;
	
    BOOL dragged;
	BOOL isRect;
	
	BOOL startLockX, endLockX;
	BOOL startLockY, endLockY;
	BOOL startMovesEnd, endMovesStart;
}

-(id) initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

//- (CGPoint) fromPoint:(CGPoint)p toPoint:(CGPoint)s lockX:(BOOL)lockX lockY:(BOOL)lockY;

- (void)movePoint:(MeasurePoint*)mp from:(CGPoint)from to:(CGPoint)to;
- (void)movePoint:(MeasurePoint*)mp from:(CGPoint)from to:(CGPoint)to recurse:(BOOL)recurse;

- (void)adjustForPoint:(MeasurePoint*)mp moved:(CGPoint)moved;

- (void)drawRect:(CGRect)rect withColor:(UIColor*)color;

- (float) distanceFrom:(CGPoint)p1 to:(CGPoint)p2;
- (float) distanceFromStartTo:(CGPoint)p;
- (float) distanceFromEndTo:(CGPoint)p;
- (float) distanceFromMidpointTo:(CGPoint)p;
- (float) distanceFromStartToEnd;
- (float) distanceFromLineTo:(CGPoint)p;

- (CGPoint) closestPointTo:(CGPoint)p;

- (float) distance:(CGPoint)p1 p2:(CGPoint)p2;
- (float) dotProduct:(CGPoint)p1 p2:(CGPoint)p2;

- (NSNumber*) angleBetween:(MeasureLine*)l;
- (MeasurePoint*) sharedPoint:(MeasureLine*) l;

@property (retain) MeasurePoint *start, *end;
@property MeasurePoint *upperPoint, *lowerPoint, *leftPoint, *rightPoint;
@property CGPoint midpoint;

@property (retain) UIColor* lineColor;

@property (nonatomic) float length;
@property (nonatomic) float rise, run;
@property (nonatomic) NSNumber* slope;


@property (retain, nonatomic) NSString* name;

@property BOOL startLockX, startLockY, endLockX, endLockY, startMovesEnd, endMovesStart;
@property BOOL dragged;
@property BOOL isRect;

@end
