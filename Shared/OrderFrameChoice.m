//
//  OrderFrameChoice.m
//  Smart-i
//
//  Created by Troy Potts on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderFrameChoice.h"

@implementation OrderFrameChoice

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
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)back:(id)sender {
    
	[self goBack];
}

- (void)goBack
{
	NSString *notificationName = @"OrderFrameChoiceDidCancel";
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)continueWithNewFrameClick:(id)sender {
    NSString *notificationName = @"OrderFrameChoiceDidFinish";
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)continueWithPOFClick:(id)sender {
    NSString *notificationName = @"OrderFrameChoiceDidFinish";
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
	[self dismissModalViewControllerAnimated:YES];
}
@end