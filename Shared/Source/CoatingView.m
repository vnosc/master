//
//  CoatingView.m
//  LENSIndex
//
//  Created by nitesh suvagia on 11/29/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "CoatingView.h"

@implementation CoatingView

@synthesize glassLeft;
@synthesize glassRight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //self.backgroundColor=[UIColor whiteColor];
        myPath=[[UIBezierPath alloc]init];
        myPath.lineWidth=20;
       // brushPattern=[UIColor whiteColor];
        self.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"Portrait.png"]];
        brushPattern=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"scratvcc.png"]]; 
        // brushPattern=[[UIColor alloc]initWithWhite:0.1 alpha:0.0];
        //[UIColor colorWithPatternImage:];
        
        UIButton *scratchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [scratchBtn setFrame:CGRectMake(100, 691, 100, 100)];
        [scratchBtn setBackgroundImage:[UIImage imageNamed:@"bt1.png"] forState:UIControlStateNormal];
        [self addSubview:scratchBtn];
        
        UIButton *spotbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [spotbtn setFrame:CGRectMake(230, 691, 100, 100)];
         [spotbtn setBackgroundImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
        [self addSubview:spotbtn];
        
        UIButton *fingerprintbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [fingerprintbtn setFrame:CGRectMake(360, 691, 100, 100)];
         [fingerprintbtn setBackgroundImage:[UIImage imageNamed:@"btn3.png"] forState:UIControlStateNormal];
        [self addSubview:fingerprintbtn];

        UIButton *raindropbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [raindropbtn setFrame:CGRectMake(490, 691, 100, 100)];
         [raindropbtn setBackgroundImage:[UIImage imageNamed:@"btn4.png"] forState:UIControlStateNormal];
        [self addSubview:raindropbtn];
        
        UIImageView *roomalImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rumal.png"]];
        [roomalImage setFrame:CGRectMake(620, 691, 100, 100)];
        [self addSubview:roomalImage];
        
        UIImageView *glassLeft=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lsss.png"]];
        [glassLeft setFrame:CGRectMake(90,280, 250, 200)];
        [self addSubview:glassLeft];
        
        UIImageView *glassRight=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lsss.png"]];
        [glassRight setFrame:CGRectMake(432,280, 250, 200)];
        [self addSubview:glassRight];
		
		self.glassLeft = glassLeft;
		self.glassRight = glassRight;
		
		const CGFloat* comp = CGColorGetComponents([UIColor brownColor].CGColor);
		NSLog(@"color: %f,%f,%f", comp[0], comp[1], comp[2]);
		
		
    }
    return self;
}

- (UIImage*) getTintedImage:(UIImage*)img color:(UIColor*)color
{
	UIGraphicsBeginImageContext(img.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSetBlendMode(ctx, kCGBlendModeNormal);
	
	CGContextTranslateCTM(ctx, 0, img.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	CGRect imgRect = CGRectMake(0, 0, img.size.width, img.size.height);
	CGContextDrawImage(ctx, imgRect, img.CGImage);
	
	CGContextTranslateCTM(ctx, 0, 0);
	CGContextScaleCTM(ctx, 1.0, 1.0);
	
	CGContextClipToMask(ctx, imgRect, img.CGImage);
	CGContextSetFillColorWithColor(ctx, color.CGColor);
	CGContextFillRect(ctx, imgRect);
	
	UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImg;
}

/*-(IBAction)clearbtn:(id)sender
 {
 
 // self = [super initWithFrame:frame];
 //if (self) {
 // Initialization code
 
 self.backgroundColor=[UIColor whiteColor];
 myPath=[[UIBezierPath alloc]init];
 myPath.lineWidth=50;
 brushPattern=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"scratvcc.png"]]; //[UIColor colorWithPatternImage:];
 
 // }
 // return self;
 
 
 }
 */

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [brushPattern setStroke];
    [myPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    
    // Drawing code
    //[myPath stroke];
    
}

#pragma mark - Touch Methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchStart = [[touches anyObject] locationInView:self];
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [myPath moveToPoint:[mytouch locationInView:self]];
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [myPath addLineToPoint:[mytouch locationInView:self]];
    
    [self setNeedsDisplay];
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}

- (void)dealloc
{
    [brushPattern release];
    [super dealloc];
}

@end
