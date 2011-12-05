//
//  Adjust.h
//  CyberImaging
//
//  Created by jay gurudev on 9/23/11.
//  Copyright 2011 software house. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Adjust : BackgroundViewController 
{
	
	UIImageView *selectedImage;
	UIImage *image;
	
}
@property (nonatomic ,retain) UIImage *image;
@property (nonatomic ,retain) IBOutlet UIImageView *selectedImage;
@end
