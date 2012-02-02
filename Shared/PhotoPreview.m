//
//  PhotoPreview.m
//  TryOnApp

//
//  Created by nitesh on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoPreview.h"
#import "SBJSON.h"
#import "FbGraphFile.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UYLGenericPrintPageRenderer.h"
@implementation PhotoPreview

@synthesize photoTakeType;
@synthesize imagePickerController;
@synthesize fbGraph;
@synthesize preViewImageView;
@synthesize leftEye,rightEye;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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
    
    
    preViewBottom=[[UIView alloc]initWithFrame:CGRectMake(0, 720, 768, 140)];
    preViewBottom.backgroundColor=[UIColor clearColor];
    [self.view addSubview:preViewBottom];
    UILabel *labelInfo=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 768, 60)];
    labelInfo.text=@"Please drag left and right eye target to their respective pupils";
    labelInfo.font=[UIFont systemFontOfSize:22];
    labelInfo.textAlignment=UITextAlignmentCenter;
    labelInfo.backgroundColor=[UIColor whiteColor];
    [preViewBottom addSubview:labelInfo];
    
    UIButton *DoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [DoneButton setFrame:CGRectMake(self.view.frame.size.width/2-65, 80,130 ,50)];
    [DoneButton setBackgroundImage:[UIImage imageNamed:@"button_notouch.png"] forState:UIControlStateNormal];
    DoneButton.titleLabel.textColor=[UIColor whiteColor];
    [DoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [DoneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [preViewBottom addSubview:DoneButton];
    
    
    
    
    
    //imagePickerController=[[UIImagePickerController alloc]init];
    //imagePickerController.delegate=self;
    if([photoTakeType isEqualToString:@"camera"])
    {
       // imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];
        
    }
    
    else if([photoTakeType isEqualToString:@"gellary"])
    {
       // imagePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(jump) userInfo:nil repeats:NO];
    }
    else if([photoTakeType isEqualToString:@"1"])
    {
        [preViewBottom removeFromSuperview];
        preViewImageView.image=[UIImage imageNamed:@"main-cropped.jpg"];
        [self addRightCircle:CGRectMake(80,160,600,200) image:@"spectDemo.png"];
        [self addSpectTryOnView];
    }
    else
    {
        [preViewBottom removeFromSuperview];
        preViewImageView.image=[UIImage imageNamed:@"FSMaleModelPhoto.jpg"];
        [self addRightCircle:CGRectMake(140,265,470,130) image:@"spectDemo.png"];
        [self addSpectTryOnView];
    }
     
}

-(IBAction)doneButtonClick:(id)sender
{
    [preViewBottom removeFromSuperview];
    [self addSpectTryOnView];
    /*
    spectTryOnView=[[UIView alloc]initWithFrame:preViewBottom.frame];
    spectTryOnView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:spectTryOnView];
    
    UILabel *labelInfo=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 768, 60)];
    labelInfo.text=@"Use touch screen gesture ti resize and reposition frame";
    labelInfo.font=[UIFont systemFontOfSize:22];
    labelInfo.textAlignment=UITextAlignmentCenter;
    labelInfo.backgroundColor=[UIColor whiteColor];
    [spectTryOnView addSubview:labelInfo];
    
    UILabel *labelInfo1=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-250,80, 500, 50)];
    labelInfo1.text=@"Frame Position is Correct ?";
    labelInfo1.font=[UIFont systemFontOfSize:25];
    labelInfo1.textColor=[UIColor whiteColor];
    labelInfo1.textAlignment=UITextAlignmentCenter;
    labelInfo1.backgroundColor=[UIColor clearColor];
    [spectTryOnView addSubview:labelInfo1];
    
    UIButton *yesButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [yesButton setFrame:CGRectMake(20, 80,130 ,50)];
    [yesButton setBackgroundImage:[UIImage imageNamed:@"button_notouch.png"] forState:UIControlStateNormal];
    yesButton.titleLabel.textColor=[UIColor whiteColor];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [yesButton addTarget:self action:@selector(yesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [spectTryOnView addSubview:yesButton];
    
    UIButton *noButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [noButton setFrame:CGRectMake(630, 80,130 ,50)];
    [noButton setBackgroundImage:[UIImage imageNamed:@"button_notouch.png"] forState:UIControlStateNormal];
    noButton.titleLabel.textColor=[UIColor whiteColor];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    [noButton addTarget:self action:@selector(noButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [spectTryOnView addSubview:noButton];
    
    */
    
    [holderview removeFromSuperview];
    [self addRightCircle:CGRectMake(holderview.frame.origin.x, holderview.frame.origin.y, holderview1.frame.origin.x+holderview1.frame.size.width -holderview.frame.origin.x,100) image:@"spectDemo.png"];
    /*
    [holderview1 setFrame:CGRectMake(holderview.frame.origin.x, holderview.frame.origin.y, holderview1.frame.origin.x+holderview1.frame.size.width -holderview.frame.origin.x,100)];
    rightEye.image=[UIImage imageNamed:@"2.PNG"];
    [rightEye setFrame:CGRectMake(0,0,holderview1.frame.size.width,holderview1.frame.size.height)];
    
    UIPinchGestureRecognizer *pinchRecognizer1 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[pinchRecognizer1 setDelegate:self];
	[holderview1 addGestureRecognizer:pinchRecognizer1];
    
    UIRotationGestureRecognizer *rotationRecognizer1 = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer1 setDelegate:self];
	[holderview1 addGestureRecognizer:rotationRecognizer1];
     */
}

-(IBAction)yesButtonClick:(id)sender
{
    [holderview1 removeGestureRecognizer:panRecognizer1];
    [holderview1 removeGestureRecognizer:pinchRecognizer];
    [holderview1 removeGestureRecognizer:rotationRecognizer];
    [spectTryOnView removeFromSuperview];
    DoneTryOnView=[[UIView alloc]initWithFrame:preViewBottom.frame];
    DoneTryOnView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:DoneTryOnView];
    
    UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 768, 60)];
    cityLabel.text=@"City Name";
    cityLabel.font=[UIFont systemFontOfSize:22];
    cityLabel.textAlignment=UITextAlignmentCenter;
    cityLabel.backgroundColor=[UIColor whiteColor];
    [DoneTryOnView addSubview:cityLabel];
    
    UIButton *frameDetailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [frameDetailButton setFrame:CGRectMake(630, 5,130 ,50)];
    [frameDetailButton setBackgroundImage:[UIImage imageNamed:@"button_notouch.png"] forState:UIControlStateNormal];
    frameDetailButton.titleLabel.textColor=[UIColor whiteColor];
    [frameDetailButton setTitle:@"Frame Detail" forState:UIControlStateNormal];
    [frameDetailButton addTarget:self action:@selector(frameDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [DoneTryOnView addSubview:frameDetailButton];
    
    UIButton *saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(20, 80,130 ,50)];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"button_notouch.png"] forState:UIControlStateNormal];
    saveButton.titleLabel.textColor=[UIColor whiteColor];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [DoneTryOnView addSubview:saveButton];

    UILabel *shareLebel=[[UILabel alloc]initWithFrame:CGRectMake(180,80,130 ,50)];
    shareLebel.text=@"Share Via";
    shareLebel.textColor=[UIColor whiteColor];
    shareLebel.font=[UIFont systemFontOfSize:22];
    shareLebel.textAlignment=UITextAlignmentCenter;
    shareLebel.backgroundColor=[UIColor clearColor];
    [DoneTryOnView addSubview:shareLebel];
    
    UIButton *mailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [mailButton setFrame:CGRectMake(320, 62,75 ,75)];
    [mailButton setBackgroundImage:[UIImage imageNamed:@"FS_mailIcon.png"] forState:UIControlStateNormal];
    mailButton.titleLabel.textColor=[UIColor whiteColor];
    [mailButton addTarget:self action:@selector(mailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [DoneTryOnView addSubview:mailButton];
    
    UIButton *fbButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [fbButton setFrame:CGRectMake(397, 62,75 ,75)];
    [fbButton setBackgroundImage:[UIImage imageNamed:@"FSFbButton.png"] forState:UIControlStateNormal];
    fbButton.titleLabel.textColor=[UIColor whiteColor];
    [fbButton addTarget:self action:@selector(fbButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [DoneTryOnView addSubview:fbButton];
    /*
    UIButton *inButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [inButton setFrame:CGRectMake(475, 62,75 ,75)];
    [inButton setBackgroundImage:[UIImage imageNamed:@"TO_linkedin.png"] forState:UIControlStateNormal];
    inButton.titleLabel.textColor=[UIColor whiteColor];
    [inButton addTarget:self action:@selector(inButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [DoneTryOnView addSubview:inButton];
*/
    UIButton *saveDoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveDoneButton setFrame:CGRectMake(475, 62,75 ,75)];
    [saveDoneButton setBackgroundImage:[UIImage imageNamed:@"FSsaveButton.png"] forState:UIControlStateNormal];
    saveDoneButton.titleLabel.textColor=[UIColor whiteColor];
    [saveDoneButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [DoneTryOnView addSubview:saveDoneButton];
    
    UIButton *printButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [printButton setFrame:CGRectMake(552, 62,75 ,75)];
    [printButton setBackgroundImage:[UIImage imageNamed:@"FSPrintButton.png"] forState:UIControlStateNormal];
    printButton.titleLabel.textColor=[UIColor whiteColor];
    [printButton addTarget:self action:@selector(printButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [DoneTryOnView addSubview:printButton];
    
    preViewImageView.image=[self screenshot];
    //[holderview1 removeFromSuperview];
}

-(IBAction)noButtonClick:(id)sender
{
    
}

-(void)jump1
{
    UIImagePickerController *picker	= [[UIImagePickerController alloc]init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	//picker.wantsFullScreenLayout = YES;
    [self presentModalViewController:picker animated:YES];
}

-(void)jump
{
    UIImagePickerController *picker	= [[UIImagePickerController alloc]init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	//picker.wantsFullScreenLayout = YES;
   // [self presentModalViewController:picker animated:YES];
    
    popOverController = [[UIPopoverController alloc] initWithContentViewController:picker];
    popOverController.delegate = self;
   
    popOverController.popoverContentSize=CGSizeMake(200,200);
    CGRect frame = CGRectMake(358,400,100,50);
    [popOverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    	
    NSLog(@"hiii");
    NSData *dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
    UIImage *img = [[UIImage alloc] initWithData:dataImage];
     preViewImageView.image=img;
    
    
    [self addLeftCircle];
    [self addRightCircle:CGRectMake(400,300,120,120) image:@"right1.png"];
    
    
    [picker dismissModalViewControllerAnimated:YES];
   // [imagePickerController dismissModalViewControllerAnimated:YES];
    [popOverController dismissPopoverAnimated:YES];
    
}
-(void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}
-(void)move:(id)sender {
	
	[self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
		
		firstX = [[sender view] center].x;
		firstY = [[sender view] center].y;
	}
	
	translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
	
	[[sender view] setCenter:translatedPoint];
	
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		CGFloat finalX = translatedPoint.x + (0.05*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
		CGFloat finalY = translatedPoint.y + (0.05*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
		
		if(UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
			
			if(finalX < 0) {
				
				finalX = 0;
			}
			
			else if(finalX > 760) {
				
				finalX = 760;
			}
			
			if(finalY < 0) {
				
				finalY = 0;
			}
			
			else if(finalY > 827) {
				
				finalY = 827;
			}
		}
		
		else {
			
			if(finalX < 0) {
				
				finalX = 0;
			}
			
			else if(finalX > 827) {
				
				finalX = 760;
			}
			
			if(finalY < 0) {
				
				finalY = 0;
			}
			
			else if(finalY > 760) {
				
				finalY = 827;
			}
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.35];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[[sender view] setCenter:CGPointMake(finalX, finalY)];
		[UIView commitAnimations];
	}
}

-(void)scale:(id)sender {
	
	[self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
	
	if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastScale = 1.0;
		return;
	}
	
	CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
	
	[[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
	
	lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)rotate:(id)sender {
	
	[self.view bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];
	
	if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
		
		lastRotation = 0.0;
		return;
	}
	
	CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
	
	CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
	
	[[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];
	
	lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}






- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

	return YES;
}
-(void)addLeftCircle
{
    holderview=[[UIView alloc]initWithFrame:CGRectMake(200,300,120,120)];
    [self.view addSubview:holderview];
    leftEye=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 120,120)];
    leftEye.image=[UIImage imageNamed:@"left.png"];
    [holderview addSubview:leftEye];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[holderview addGestureRecognizer:panRecognizer];
    
    
    
}
-(void)addRightCircle:(CGRect )size1 image:(NSString *)imageName
{
    if(holderview1)
    {
        [holderview1 removeFromSuperview];
    }
    holderview1=[[UIView alloc]initWithFrame:size1];
    [self.view addSubview:holderview1];
    rightEye=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, holderview1.frame.size.width,holderview1.frame.size.height)];
    [holderview1 addSubview:rightEye];
    rightEye.image=[UIImage imageNamed:imageName];
    panRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer1 setMinimumNumberOfTouches:1];
	[panRecognizer1 setMaximumNumberOfTouches:1];
	[panRecognizer1 setDelegate:self];
    [holderview1 addGestureRecognizer:panRecognizer1];
    
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
	[pinchRecognizer setDelegate:self];
	[holderview1 addGestureRecognizer:pinchRecognizer];
    
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
	[rotationRecognizer setDelegate:self];
	[holderview1 addGestureRecognizer:rotationRecognizer];
}

-(void)addSpectTryOnView
{
    spectTryOnView=[[UIView alloc]initWithFrame:preViewBottom.frame];
    spectTryOnView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:spectTryOnView];
    
    UILabel *labelInfo=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 768, 60)];
    labelInfo.text=@"Use touch screen gesture ti resize and reposition frame";
    labelInfo.font=[UIFont systemFontOfSize:22];
    labelInfo.textAlignment=UITextAlignmentCenter;
    labelInfo.backgroundColor=[UIColor whiteColor];
    [spectTryOnView addSubview:labelInfo];
    
    UILabel *labelInfo1=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-250,80, 500, 50)];
    labelInfo1.text=@"Frame Position is Correct ?";
    labelInfo1.font=[UIFont systemFontOfSize:25];
    labelInfo1.textColor=[UIColor whiteColor];
    labelInfo1.textAlignment=UITextAlignmentCenter;
    labelInfo1.backgroundColor=[UIColor clearColor];
    [spectTryOnView addSubview:labelInfo1];
    
    UIButton *yesButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [yesButton setFrame:CGRectMake(20, 80,130 ,50)];
    [yesButton setBackgroundImage:[UIImage imageNamed:@"button_notouch.png"] forState:UIControlStateNormal];
    yesButton.titleLabel.textColor=[UIColor whiteColor];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [yesButton addTarget:self action:@selector(yesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [spectTryOnView addSubview:yesButton];
    
    UIButton *noButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [noButton setFrame:CGRectMake(630, 80,130 ,50)];
    [noButton setBackgroundImage:[UIImage imageNamed:@"button_notouch.png"] forState:UIControlStateNormal];
    noButton.titleLabel.textColor=[UIColor whiteColor];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    [noButton addTarget:self action:@selector(noButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [spectTryOnView addSubview:noButton];

}


-(IBAction)mailButtonClick:(id)sender
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    // Set the subject of email
    [picker setSubject:@"Picture from my iPhone!"];
    
    // Add email addresses
    // Notice three sections: "to" "cc" and "bcc"	
    //  [picker setToRecipients:[NSArray arrayWithObjects:@"emailaddress1@domainName.com", @"emailaddress2@domainName.com", nil]];
    // [picker setCcRecipients:[NSArray arrayWithObject:@"emailaddress3@domainName.com"]];	
    // [picker setBccRecipients:[NSArray arrayWithObject:@"emailaddress4@domainName.com"]];
    
    // Fill out the email body text
    NSString *emailBody = @"I just took this picture, check it out.";
    
    // This is not an HTML formatted email
    [picker setMessageBody:emailBody isHTML:NO];
    
    // Create NSData object as PNG image data from camera image
    NSData *data = UIImagePNGRepresentation([self screenshot]);
    
    // Attach image data to the email
    // 'CameraImage.png' is the file name that will be attached to the email
    [picker addAttachmentData:data mimeType:@"image/png" fileName:@"CameraImage"];
    
    // Show email view	
    [self presentModalViewController:picker animated:YES];
    
    // Release picker
    [picker release]; 
}


-(IBAction)fbButtonClick:(id)sender
{
    NSString *client_id = @"130902823636657";
    self.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
	
	//begin the authentication process.....
	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
						 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
}


-(IBAction)inButtonClick:(id)sender
{
    
}


-(IBAction)saveButtonClick:(id)sender
{
      UIImageWriteToSavedPhotosAlbum(preViewImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image  
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
}


-(IBAction)printButtonClick:(id)sender
{
    UIPrintInteractionController *pc = [UIPrintInteractionController sharedPrintController];
    pc.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    // printInfo.jobName = self.query;
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    
    UYLGenericPrintPageRenderer *renderer = [[UYLGenericPrintPageRenderer alloc] init];
    renderer.headerText = printInfo.jobName;
    renderer.footerText = @"AirPrinter - UseYourLoaf.com";
    
    UIViewPrintFormatter *formatter = [self.preViewImageView viewPrintFormatter];
    [renderer addPrintFormatter:formatter startingAtPageAtIndex:0];
    pc.printPageRenderer = renderer;
    [renderer release];
    
    UIPrintInteractionCompletionHandler completionHandler = 
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            //  DLog(@"Print failed - domain: %@ error code %u", error.domain, error.code);	
        }
    };
    
    
    [pc presentAnimated:YES completionHandler:completionHandler];
    
    
}


- (void)fbGraphCallback:(id)sender {
	
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
	} else
    {
        
        
        
        
		//pop a message letting them know most of the info will be dumped in the log
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share" message:@"Share qoute with friend " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
		
	}
	
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    
    NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:2];
	
	
	FbGraphFile *graph_file = [[FbGraphFile alloc] initWithImage:preViewImageView.image];
	
	
	[variables setObject:graph_file forKey:@"file"];
	
	[variables setObject:@"how" forKey:@"message"];
	
	
	FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"117795728310/photos" withPostVars:variables];
	
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}
- (UIImage*)screenshot 
{
    NSLog(@"Shot");
    
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    //CGSize imagesize = [[UIScreen mainScreen] bounds].size;
   CGSize imagesize= CGSizeMake(768,720);
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imagesize, NO, 0);
    else
        UIGraphicsBeginImageContext(imagesize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) 
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y-64);
            /*
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            */
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
