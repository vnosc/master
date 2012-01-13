//
//  Astigmatism.m
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "Astigmatism.h"
#import "Duochrome.h"
static int i=0;
int y=1;
int part1=1;
int leftEyeResult1=0;
int rightEyeResult1=0;
@implementation Astigmatism
@synthesize rightLabel,leftLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction) startTestBtnClick : (id)sender
{
    i=0;
    y=1;
    part1=1;
    leftEyeResult1=0;
    rightEyeResult1=0;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
	
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lefteye.png"]] autorelease];
	
    
    HUD.mode = MBProgressHUDModeCustomView;
	
	
    [self.navigationController.view addSubview:HUD];
	
    HUD.delegate = self;
	
    HUD.labelText = @"Cover Left Eye";
	
    [HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
    
}
- (void)myMixedTask {
    
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(20000);
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	NSLog(@"Hud: %@", hud);
    
    [HUD removeFromSuperview];
    [HUD release];
    if(i==0)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(jump) userInfo:nil repeats:NO];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(jump1) userInfo:nil repeats:NO];
    }
}
-(void)jump
{
    i=1;
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
	
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
	
    
    HUD.mode = MBProgressHUDModeCustomView;
	
	
    [self.navigationController.view addSubview:HUD];
	
    HUD.delegate = self;
	
    HUD.labelText = @"Hold at arms length";
	
    [HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
    
}

-(void) jump1
{
    if(part1 <3)
    {
        startTestBtn.hidden=YES;
        if(y<2)
        {
            yesBtn.hidden=NO;
            noBtn.hidden=NO;
            mainImage.image=[UIImage imageNamed:@"Asigmatism.png"];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];  
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            [UIView commitAnimations];
            
            NSLog(@"The value of x is : %i",y);
            
            y++;
        }
        else
        {
            part1++;
            if(part1 !=3)
            {
                y=1;
                HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                
                HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"righteye.png"]] autorelease];
                
                HUD.mode = MBProgressHUDModeCustomView;
                
                [self.navigationController.view addSubview:HUD];
                
                HUD.delegate = self;
                
                HUD.labelText = @"Cover Right Eye";
                
                [HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:nil animated:YES];
            }
            else
            {
                if(leftEyeResult1==1 && rightEyeResult1==1)
                {
                    mainImage.hidden=NO;
                    mainImage.image=[UIImage imageNamed:@"pass.png"];
                    findOptician.hidden=NO;
                    nextTest.hidden=NO;
                    yesBtn.hidden=YES;
                    noBtn.hidden=YES;
                    app.astigmatismRightEye=@"100%";
                    app.astigmatismLeftEye=@"100%";
                }
                else
                {
                    yesBtn.hidden=YES;
                    noBtn.hidden=YES;
                    findOptician.hidden=NO;
                    nextTest.hidden=NO;
                    mainImage.hidden=NO;
                    mainImage.image=[UIImage imageNamed:@"failenobtn.png"];
                    leftLabel.hidden=NO;
                    rightLabel.hidden=NO;
                    
                    if(leftEyeResult1==1)
                    {
                        leftLabel.text=@"LEFT - 100%";
                        app.astigmatismLeftEye=@"100%";
                    }
                    else
                    {
                        leftLabel.text=@"LEFT - 0%";
                        app.astigmatismLeftEye=@"0%";
                    }
                    if(rightEyeResult1==1)
                    {
                        rightLabel.text=@"RIGHT - 100%";
                        app.astigmatismRightEye=@"100%";
                    }
                    else
                    {
                        rightLabel.text=@"RIGHT - 0%";
                        app.astigmatismRightEye=@"0%";
                    }
                }
            }
        }
    }
}

-(IBAction) yesOrNoBtnClick : (id) sender
{
    UIButton *btn=(UIButton *) sender;
    int btnTag= btn.tag;
    if(btnTag==2)
    {
        if(part1==1)
        {
            rightEyeResult1++;
            
        }
        if(part1==2)
        {
            leftEyeResult1++;
            
        }
    }
    [self jump1];
}
-(IBAction) findOpticianBtnClick : (id)sender
{
    
}
-(IBAction) nextTestBtnClick : (id)sender
{
    Duochrome *dcrm=[[Duochrome alloc]init];
    dcrm.title=@"Duochrome";
    [self.navigationController pushViewController:dcrm animated:YES];
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
    app=[GlobalVariable sharedInstance];
    yesBtn.hidden=YES;
    noBtn.hidden=YES;
    leftLabel.hidden=YES;
    rightLabel.hidden=YES;
    findOptician.hidden=YES;
    nextTest.hidden=YES;
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


