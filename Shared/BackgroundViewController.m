//
//  BackgroundViewController.m
//  Smart-i
//
//  Created by Troy Potts on 11/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation BackgroundViewController

/*- (id) init
{
	NSLog(@"init wuut");
	self = [super init];
	
	return self;
}*/
/*- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	NSLog(@"%@, %@", nibNameOrNil, nibBundleOrNil);
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
			NSLog(@"whuuuuuut");
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	NSLog(@"init coder!!!");
	self = [super initWithCoder:aDecoder];
	return self;
}*/

#ifdef OPTISUITE

- (NSString*) backgroundImageName { return @"MainBackground.png"; }
- (NSString*) buttonImageName { return @"DefaultButton.png"; }
- (NSString*) buttonHighlightedImageName { return @"DefaultButtonHighlighted.png"; }
- (UIColor*) textColor { return [UIColor whiteColor]; }
- (int) buttonImageLeftCap { return 15; }
- (int) buttonImageTopCap { return 13; }
- (int) heightThreshold { return 70; }

#else if defined SMARTI

- (NSString*) backgroundImageName { return @"MainBackground.png"; }
- (NSString*) buttonImageName { return @"DefaultButton.png"; }
- (NSString*) buttonHighlightedImageName { return @"DefaultButtonHighlighted.png"; }
- (UIColor*) textColor { return [UIColor darkGrayColor]; }
- (int) buttonImageLeftCap { return 6; }
- (int) buttonImageTopCap { return 6; }
- (int) heightThreshold { return 70; }

#endif

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	UIImage *bgImage = [UIImage imageNamed:self.backgroundImageName];
	if (bgImage)
	
		self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:bgImage];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//[[UILabel appearance] setColor:[UIColor whiteColor]];
	
	[self applyChangesToSubviews:self.view];
}

- (void) setStretchBackground:(UIImageView*)v imageName:(NSString*)imageName leftCap:(int)leftCap topCap:(int)topCap
{
    //[v setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap]]];
    [v setImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap]];
}

- (UIImage*) getStretchBackgroundForImage:(NSString*)imageName leftCap:(int)leftCap topCap:(int)topCap
{
    return [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (void) applyChangesToSubviews:(UIView*)mv
{
	for (UIView *v in mv.subviews)
	{
		if ([v isKindOfClass:[UIButton class]] && v.frame.size.height <= self.heightThreshold)
		{
			UIButton *b = (UIButton*)v;
			//if (b.buttonType == UIButtonTypeRoundedRect)
			if ([b.titleLabel.text length] > 0)
			{
				UIImage *i = [UIImage imageNamed:self.buttonImageName];
				UIImage *si = [i stretchableImageWithLeftCapWidth:self.buttonImageLeftCap topCapHeight:self.buttonImageTopCap];
				
				UIImage *i2 = [UIImage imageNamed:self.buttonHighlightedImageName];
				UIImage *si2 = [i2 stretchableImageWithLeftCapWidth:self.buttonImageLeftCap topCapHeight:self.buttonImageTopCap];
		
				/*UIGraphicsBeginImageContext(si.size);
				 CGContextRef ctx = UIGraphicsGetCurrentContext();
				 //CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
				 CGContextDrawImage(ctx, CGRectZero, si.CGImage);
				 UIImage *sir = UIGraphicsGetImageFromCurrentImageContext();*/
				
				//[b.titleLabel.layer setBorderWidth:0.0f];
				//[b setImage:nil forState:UIControlStateNormal];
				[b setBackgroundImage:si forState:UIControlStateNormal];
				[b setBackgroundImage:si2 forState:UIControlStateHighlighted];
				[b setTintColor:[UIColor whiteColor]];
				//b.layer 
				//b.imageView.hidden = YES;
				[b.layer setBorderWidth:0.0f];
				//[b.layer setMasksToBounds:YES];
				[b.layer setCornerRadius:0.0f];
				[b setTitleColor:self.textColor forState:UIControlStateNormal];
			}
		}
		else if ([v isKindOfClass:[UIView class]] && ![v isKindOfClass:[UINavigationBar class]])
		{
			[self applyChangesToSubviews:v];
		}
	}
}

- (void) setBoxBackground:(UIView*)v
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:v.bounds];
    [self setStretchBackground:iv imageName:@"BoxBackground.png" leftCap:10 topCap:26];
    [v insertSubview:iv atIndex:0];
    [v setNeedsDisplay];
}

- (void) setBoxBackgroundLarge:(UIView*)v
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:v.bounds];
    [self setStretchBackground:iv imageName:@"BoxBackgroundLarge.png" leftCap:10 topCap:34];
    [v insertSubview:iv atIndex:0];
    [v setNeedsDisplay];
}

- (void) setDropDownBackground:(UIButton*)btn
{
    //[btn setBackgroundImage:[self getStretchBackgroundForImage:@"DropDown.png" leftCap:70 topCap:30] forState:UIControlStateNormal];
    UIImage *downArrow = [UIImage imageNamed:@"DropDownArrow.png"];
    
    float sizeRatio = btn.bounds.size.height / (downArrow.size.height + 4);
    NSLog(@"%f", sizeRatio);
    
    float width = downArrow.size.width * sizeRatio;
    float height = downArrow.size.height * sizeRatio;
    
    int paddingRight = 3;
    
    UIImageView *iv = [[UIImageView alloc] 
                       initWithFrame:
                       CGRectMake(btn.bounds.size.width - width - paddingRight, 
                                  (btn.bounds.size.height - height)/2, 
                                  width, height)];
    iv.image = downArrow;
    [iv setContentMode:UIViewContentModeScaleToFill];

    [btn addSubview:iv];
    [btn setNeedsDisplay];
}

/*- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	
}*/

/*- (void) loadView
{
	[super loadView];
}*/

@end
