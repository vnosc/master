//
//  LineView.h
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasureLine.h"

@interface LineView : UIView 
{
	NSMutableArray* _lines;
	NSMutableArray* _points;
	MeasureLine* grabbedLineObj;
	MeasurePoint* grabbedPoint;
	
    BOOL dragged;
	BOOL grabbedEnd;
	BOOL grabbedMid;
	BOOL grabbedLine;
	BOOL grabbedHand;
	
	BOOL nextLineIsRect;
	
	CGPoint grabOffset;
	
	NSMutableArray* _touches;
}

- (void) initData;

- (MeasureLine*) createLineFrom:(CGPoint)start to:(CGPoint)end;
- (MeasureLine*) createLineFromPoint:(MeasurePoint*)start to:(CGPoint)end;
- (MeasureLine*) createLineFrom:(CGPoint)start toPoint:(MeasurePoint*)end;

- (MeasureLine*) lineByName:(NSString*)searchName;
- (NSArray*) linesWithPoint:(MeasurePoint*)mp;

- (void) movePoint:(MeasurePoint*)point to:(CGPoint)p;

@property (retain) MeasureLine* grabbedLineObj;
@property (retain) MeasurePoint* grabbedPoint;

@property (retain) UIColor* selectedColor;
@property int measureType;
@property BOOL canAddLines;
@property BOOL didAddLine;

@property BOOL nextLineIsRect;
@property BOOL dragged;
@property BOOL grabbedEnd;
@property BOOL grabbedMid;
@property BOOL grabbedLine;
@property BOOL grabbedHand;
@property BOOL grabbedOtherRectPoint;

@property CGPoint grabOffset;

@property (retain) NSMutableArray* lines;
@property (retain) NSMutableArray* points; // NOT IMPLEMENTED RIGHT, JUST FOR DISPLAY
@property (retain) NSMutableArray* touches;

@end
