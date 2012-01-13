//
//  EyeAdvice.m
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "EyeAdvice.h"

@implementation EyeAdvice
@synthesize imgTextScroll;
@synthesize textImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgTextScroll.frame = CGRectMake(0, 0 ,768, 3985);
	imgTextScroll.contentSize=CGSizeMake(620,6800);
    
    
}
-(IBAction) findOpticianBtnClick : (id)sender
{
    
}
-(IBAction) viewOtherEyeFactsBtnClick : (id)sender
{
    
}
-(IBAction) seeMoreBtnClick : (id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Leave Vision Test" message:@"Continuing means you will leave Vision Test and open a new app." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    [alert show];
    [alert release];
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (buttonIndex == 0)
	{
		
	}
	else
	{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://profitoptix.com"]]; 
        
    }
    

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
