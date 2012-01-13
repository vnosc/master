//
//  Settings.m
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "Settings.h"

@implementation Settings

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
-(IBAction) resetResultsBtnClick : (id)sender
{
    app.visualAcuityLeftEye=@"0";
    app.visualAcuityRightEye=@"0";
    app.duochromeLeftEye=@"0";
    app.duochromeRightEye=@"0";
    app.colorTestLeftEye=@"0";
    app.colorTestRightEye=@"0";
    app.questionLeftEye=@"0";
    app.questionRightEye=@"0";
    app.astigmatismLeftEye=@"0";
    app.astigmatismRightEye=@"0";
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"This will reset your entire test history. This action cannot be undone." message:nil delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(IBAction) visitBtnClick : (id) sender
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
-(IBAction) submitReviewBtnClick : (id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }

}
-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	
	
	[self presentModalViewController:picker animated:YES];
    
    [picker release];
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	
	switch (result)
	{
		case MFMailComposeResultCancelled:
	
			break;
		case MFMailComposeResultSaved:
	
			break;
		case MFMailComposeResultSent:
	
			break;
		case MFMailComposeResultFailed:
	
			break;
		default:
    
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(IBAction) termsAndConditionBtnClick : (id)sender
{
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    app=[GlobalVariable sharedInstance];
    
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

@end
