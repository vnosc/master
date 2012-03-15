//
//  ImageCache.m
//  Smart-i
//
//  Created by Troy Potts on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// (UNUSED)

#import "ImageCache.h"

@implementation ImageCache

static ImageCache *instance;

+ (void)initialize
{
    static BOOL initialized;
    if (!initialized)
    {
        initialized = YES;
        instance = [[ImageCache alloc] init];
    }
}

+ (UIImage*)getImage:(NSString*)imageName
{
    return [instance getImage:imageName];
}

+ (void)provideImage:(NSString*)imageName forImageView:(UIImageView*)iv
{
    [ImageCache provideImage:imageName withURL:nil forImageView:iv];
}

+ (void)provideImage:(NSString*)imageName withURL:(NSString*)imageURL forImageView:(UIImageView*)iv
{
    ImageCacheEntry *e = [[ImageCacheEntry alloc] init];
    e.name = imageName;
    e.URL = imageURL;
    e.ready = NO;
    
    NSThread *thread = [[NSThread alloc] init];
    
    NSLog(@"Entering cacheEntry");
    
    // hangs! something about NSRunLoop...
    // change all this to use NSOperationQueue maybe
    [instance performSelector:@selector(cacheEntry:) onThread:thread withObject:e waitUntilDone:YES];
    
    NSLog(@"Exiting cacheEntry");
    
    [thread release];
    
    iv.image = [instance getImage:imageName];
}

+ (void)cacheImage:(UIImage*)image as:(NSString*)imageName
{
    ImageCacheEntry *e = [[ImageCacheEntry alloc] init];
    e.name = imageName;
    e.image = image;
    e.ready = NO;
    
    [instance performSelectorInBackground:@selector(cacheEntry:) withObject:e];    
}

+ (void)cacheImageFromURL:(NSString*)imageURL as:(NSString*)imageName
{
    ImageCacheEntry *e = [[ImageCacheEntry alloc] init];
    e.name = imageName;
    e.URL = imageURL;
    e.ready = NO;
    
    [instance performSelectorInBackground:@selector(cacheEntry:) withObject:e];
}

- (void) cacheEntry:(ImageCacheEntry*)entry
{
    NSLog(@"cacheEntry entered");
    
    [self addEntry:entry];

    entry.ready = NO;
    
    if (entry.image == nil)
    {
        NSLog(@"Downloading %@ (%@)...", entry.name, entry.URL);
        entry.image = [self downloadImage:entry.URL];
        NSLog(@"FINISHED Downloading %@ (%@)...", entry.name, entry.URL);
    }
    
    entry.ready = YES;
    
    NSLog(@"cacheEntry left");
}

- (UIImage*)getImage:(NSString*)imageName
{
    return [self getImage:imageName withURL:nil];
}

- (UIImage*)getImage:(NSString*)imageName withURL:(NSString*)imageURL
{
    ImageCacheEntry *e = (ImageCacheEntry*) [images objectForKey:imageName];
    
    if (e)
    {
        if (!e.ready)
        {
            NSThread *thread = [[NSThread alloc] init];
            [self performSelector:@selector(waitUntilReady:) onThread:thread withObject:e waitUntilDone:YES];
            [thread release];
        }
        
        return e.image;
    }
    
    return nil;
}

- (void)waitUntilReady:(ImageCacheEntry*)e
{
    //while (!e.ready)
    //{
    //}
}

- (UIImage*)downloadImage:(NSString*)imageURL
{
    NSURL* url = [NSURL URLWithString:imageURL];

    NSData* imageData = [[NSData alloc] initWithContentsOfURL:url];
    return [[UIImage imageWithData:imageData] retain];
    
    //HUD.labelText = @"Uploading images...";
    //[HUD show:YES];
    
}

- (void)setImage:(UIImage*)image as:(NSString*)imageName
{
    ImageCacheEntry *e = [[ImageCacheEntry alloc] init];
    e.name = imageName;
    e.image = image;
    e.ready = NO;
 
    [self addEntry:e];
}
         
- (void)addEntry:(ImageCacheEntry*)e
{
    [images setObject:e forKey:e.name];
}
     
@end

@implementation ImageCacheEntry

 @synthesize name;
 @synthesize URL;
 @synthesize image;
 @synthesize ready;


@end