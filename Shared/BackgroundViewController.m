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

- (NSString*) buttonImageName { return @"DefaultButton.png"; }
- (NSString*) buttonHighlightedImageName { return @"DefaultButtonHighlighted.png"; }
- (int) buttonImageLeftCap { return 6; }
- (int) buttonImageTopCap { return 6; }
- (int) heightThreshold { return 70; }

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"MainBackground.png"]];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//[[UILabel appearance] setColor:[UIColor whiteColor]];
	
	[self applyChangesToSubviews:self.view];
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
				[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			}
		}
		else if ([v isKindOfClass:[UIView class]] && ![v isKindOfClass:[UINavigationBar class]])
		{
			[self applyChangesToSubviews:v];
		}
	}
}

#endif 

/*- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	
}*/

/*- (void) loadView
{
	[super loadView];
}*/

@end
