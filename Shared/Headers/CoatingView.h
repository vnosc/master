//
//  CoatingView.h
//  LENSIndex
//
//  Created by nitesh suvagia on 11/29/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoatingView : UIView
{
    UIColor *brushPattern;
    UIBezierPath *myPath;
    CGPoint touchStart;
	
	UIImageView *glassLeft;
	UIImageView *glassRight;
}

@property (retain) UIImageView *glassLeft;
@property (retain) UIImageView *glassRight;

@end
