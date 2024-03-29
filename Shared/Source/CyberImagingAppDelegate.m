//
//  CyberImagingAppDelegate.m
//  CyberImaging
//
//  Created by Patel on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CyberImagingAppDelegate.h"

#import "PackageSelection.h"

@implementation CyberImagingAppDelegate
@synthesize viewController;

@synthesize window=_window;
@synthesize visualAcuityLeftEye,visualAcuityRightEye,astigmatismLeftEye,astigmatismRightEye,duochromeLeftEye,duochromeRightEye,colorTestLeftEye,colorTestRightEye,questionLeftEye,questionRightEye;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	// -------------------
	
    [[UILabel appearanceWhenContainedIn:[MBProgressHUD class], nil] setColor:[UIColor whiteColor]];
	[[UILabel appearanceWhenContainedIn:[MBProgressHUD class], [BackgroundViewController class], nil] setColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UIAlertView class], nil] setColor:[UIColor whiteColor]];
    
    [[UILabel appearanceWhenContainedIn:[UIPickerView class], nil] setColor:[UIColor blackColor]];
    [[UILabel appearanceWhenContainedIn:[UIPickerView class], [BackgroundViewController class], nil] setColor:[UIColor blackColor]];
    
    [[HeaderLabel appearanceWhenContainedIn:[UIView class], nil] setColor:[UIColor blackColor]];
    
    [[UILabel appearanceWhenContainedIn:[UIActionSheet class], nil] setColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UIButton class], [UIActionSheet class], nil] setColor:[UIColor blackColor]];
    
#if defined OPTISUITE
	
	NSLog(@"OPTISUITE");
	
	[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];

	/*[[UILabel appearanceWhenContainedIn:[UISegmentedControl class], [UIScrollView class], nil] setColor:[UIColor blackColor]];
	[[UILabel appearanceWhenContainedIn:[UIScrollView class], nil] setColor:[UIColor whiteColor]];*/

	[[UILabel appearanceWhenContainedIn:[UITextField class], [BackgroundViewController class], nil] setColor:[UIColor blackColor]];
	
	[[UILabel appearanceWhenContainedIn:[BackgroundViewController class], nil] setColor:[UIColor whiteColor]];

    [[UILabel appearanceWhenContainedIn:[PackageSelection class], nil] setColor:[UIColor blackColor]];
    [[UILabel appearanceWhenContainedIn:[UIButton class], [PackageSelection class], nil] setColor:[UIColor whiteColor]];
    
	
#elif defined SMARTI
	
	NSLog(@"SMART-I");
	
	[[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
	
//	[[UITabBar appearance] setTintColor:[UIColor whiteColor]]; 

	[[UILabel appearanceWhenContainedIn:[MBProgressHUD class], nil] setColor:[UIColor whiteColor]];
	[[UILabel appearanceWhenContainedIn:[MBProgressHUD class], [BackgroundViewController class], nil] setColor:[UIColor whiteColor]];
    [[UILabel appearanceWhenContainedIn:[UIAlertView class], nil] setColor:[UIColor whiteColor]];
    
	[[UILabel appearanceWhenContainedIn:[BackgroundViewController class], nil] setColor:[UIColor darkGrayColor]];
    
    /*[[UILabel appearanceWhenContainedIn:[UINavigationBar class], nil] setColor:[UIColor whiteColor]];
    
    UIColor *tint = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    [[UINavigationBar appearance] setTintColor:tint];
    [[UITabBar appearance] setTintColor:tint];*/
	
#else
	
	NSLog(@"No version identifier found.");
	
#endif
	
	// ---------------------
	
#if defined DEBUG
	NSLog(@"DEBUG");
#elif defined RELEASE
	NSLog(@"RELEASE");
#elif defined ADHOC
	NSLog(@"ADHOC");
#else
	NSLog(@"No build type identifier found.");
#endif
	
	visualAcuityLeftEye=@"0";
    visualAcuityRightEye=@"0";
    astigmatismLeftEye=@"0";
    astigmatismRightEye=@"0";
    duochromeLeftEye=@"0";
    duochromeRightEye=@"0";
    colorTestLeftEye=@"0";
    colorTestRightEye=@"0";
    questionLeftEye=@"0";
    questionRightEye=@"0";
	

	
    // Override point for customization after application launch.
	//self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{   
    [viewController release];
    [_window release];
    [super dealloc];
}

@end
