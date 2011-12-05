//
//  LineView.h
//  CyberImaging
//
//  Created by Troy Potts on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasurePoint : NSObject
{
	NSString* name;
	
	float x;
	float y;

    BOOL dragged;
	
	BOOL lockX, lockY;
	
	BOOL hasHand;
	NSString* handText;
	float handWidth, handHeight;
	float handOffsetX, handOffsetY;

}

- (id) initWithPoint:(CGPoint)pointArg;

- (void)movePointTo:(CGPoint)pointArg;

- (CGPoint) fromPoint:(CGPoint)p toPoint:(CGPoint)s lockX:(BOOL)lx lockY:(BOOL)ly;

- (void)drawPoint:(CGRect)rect at:(CGPoint)at withColor:(UIColor*)color;

- (void)drawPoint:(CGRect)rect withColor:(UIColor*)color;

- (float) distanceFrom:(CGPoint)p1 to:(CGPoint)p2;

-(void) setHand:(BOOL)isSet text:(NSString*)text width:(float)width height:(float)height offsetX:(float)offsetX offsetY:(float)offsetY;

@property float x, y;
@property (nonatomic) CGPoint point;
@property (nonatomic) CGPoint handPoint;

@property (retain, nonatomic) NSString* name;

@property BOOL lockX, lockY;
@property BOOL dragged;
@property BOOL hasHand;
@property (retain) NSString* handText;
@property float handWidth, handHeight;
@property float handOffsetX, handOffsetY;

@end
