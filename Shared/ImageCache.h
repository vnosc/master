//
//  ImageCache.h
//  Smart-i
//
//  Created by Troy Potts on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIFormDataRequest.h"

@interface ImageCacheEntry : NSObject

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *URL;
@property (retain, nonatomic) UIImage *image;
@property (assign) BOOL ready;

@end

@interface ImageCache : NSObject
{
    NSMutableDictionary *images;
}

+ (void)provideImage:(NSString*)imageName forImageView:(UIImageView*)iv;
+ (void)provideImage:(NSString*)imageName withURL:(NSString*)imageURL forImageView:(UIImageView*)iv;

- (UIImage*)getImage:(NSString*)imageName;
- (UIImage*)getImage:(NSString*)imageName withURL:(NSString*)imageURL;

- (UIImage*)downloadImage:(NSString*)imageURL;

- (void)addEntry:(ImageCacheEntry*)e;

@end
