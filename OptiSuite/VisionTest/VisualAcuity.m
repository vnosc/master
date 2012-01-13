//
//  VisualAcuity.m
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "VisualAcuity.h"
#import "VisualAcuityTestStart.h"
#import "Astigmatism.h"
#import "GlobalVariable.h"
static int i=0;
int a;
int b;
int c;
int d;
int b1,b2,b3,b4;
int x=1;
int leftEyeResult=0;
int rightEyeResult=0;
float fontSize=60.0;
int part=1;
@implementation VisualAcuity
@synthesize array,rendomTextLbl,rendomString,leftEyeLbl,rightEyeLbl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction) startTestBtnClick : (id) sender
{
    i=0;
    x=1;
    part=1;
    fontSize=60.0;
    leftEyeResult=0;
    rightEyeResult=0;
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
    redImageView.hidden=YES;
    mainImage.hidden=YES;
    if(part <3)
    {
        mainImage.hidden=YES;
        rendomTextLbl.text=@"";
        firstBtn.hidden=YES;
        secondBtn.hidden=YES;
        thirdBtn.hidden=YES;
        notSureBtn.hidden=YES;
        startTestBtn.hidden=YES;
        rendomTextLbl.hidden=NO;
        if(x<7)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:1.0];  
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            [UIView commitAnimations];

            NSLog(@"The value of x is : %i",x);
            a = arc4random() % 26;
            b = arc4random() % 26;
            c = arc4random() % 26;
            d = arc4random() % 26;
            rendomString=[[NSString alloc]initWithFormat:@"%@ %@ %@ %@",[array objectAtIndex:a],[array objectAtIndex:b],[array objectAtIndex:c],[array objectAtIndex:d]];
            rendomTextLbl.font= [UIFont boldSystemFontOfSize:fontSize];

            rendomTextLbl.text=rendomString;   
            fontSize=fontSize-10;
            x++;
            [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeView) userInfo:nil repeats:NO];

        
        }
        else
        {
            part++;
            if(part !=3)
            {
        
                fontSize=60.0;
                x=1;
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
                if(leftEyeResult==6 && rightEyeResult==6)
                {
                    mainImage.hidden=NO;
                    mainImage.image=[UIImage imageNamed:@"pass.png"];
                    findOptician.hidden=NO;
                    nextTest.hidden=NO;
                    
                    app.visualAcuityRightEye=@"100%";
                    app.visualAcuityLeftEye=@"100%";
                }
                else
                {
                    mainImage.hidden=NO;
                    mainImage.image=[UIImage imageNamed:@"failenobtn.png"];
                    rightEyeLbl.hidden=NO;
                    leftEyeLbl.hidden=NO;
                    findOptician.hidden=NO;
                    nextTest.hidden=NO;
                    
                    int per=0;
                    per=leftEyeResult*100/6;
                    
                    
                    
                    int per2=0;
                    per2=rightEyeResult*100/6;
                    NSString *demo=@"%";
                    app.visualAcuityLeftEye=[NSString stringWithFormat:@"%i%@",per,demo];
                    app.visualAcuityRightEye=[NSString stringWithFormat:@"%i%@",per2,demo];
                    NSString *left=[[NSString alloc]initWithFormat:@"LEFT - %i%@ ",per,demo];
                    leftEyeLbl.text=left;
                    //app.visualAcuityLeftEye=left;
                    
                    NSString *right=[[NSString alloc]initWithFormat:@"RIGHT - %i%@ ",per2,demo];
                    rightEyeLbl.text=right;
                    //app.visualAcuityRightEye=right;
                }
            }
        }
    }
        
}
-(void) changeView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    mainImage.hidden=NO;
    mainImage.image=[UIImage imageNamed:@"acuity.png"];
    
    firstBtn.hidden=NO;
        
    secondBtn.hidden=NO;
    thirdBtn.hidden=NO;
    notSureBtn.hidden=NO;
    rendomTextLbl.hidden=YES;
   
    int buttonTitle=arc4random() % 3;
    if(buttonTitle==0)
    {
        buttonTitle=3;
    }
    NSLog(@"Button title no is : %i",buttonTitle);
    
    if(buttonTitle==1)
    {
    [firstBtn setTitle:rendomString forState:UIControlStateNormal];
    }
    else
    {
        b1 = arc4random() % 26;
        b2 = arc4random() % 26;
        b3 = arc4random() % 26;
        b4 = arc4random() % 26;
       NSString *tempString= [[NSString alloc]initWithFormat:@"%@ %@ %@ %@",[array objectAtIndex:b1],[array objectAtIndex:b2],[array objectAtIndex:b3],[array objectAtIndex:b4]];
        [firstBtn setTitle:tempString forState:UIControlStateNormal];

    }
    if(buttonTitle ==2)
    {
        [secondBtn setTitle:rendomString forState:UIControlStateNormal];

    }
    else
    {
        b1 = arc4random() % 26;
        b2 = arc4random() % 26;
        b3 = arc4random() % 26;
        b4 = arc4random() % 26;
        NSString *tempString1= [[NSString alloc]initWithFormat:@"%@ %@ %@ %@",[array objectAtIndex:b1],[array objectAtIndex:b2],[array objectAtIndex:b3],[array objectAtIndex:b4]];
        [secondBtn setTitle:tempString1 forState:UIControlStateNormal];
    }
    if(buttonTitle ==3)
    {
        [thirdBtn setTitle:rendomString forState:UIControlStateNormal];

    }
    else
    {
        b1 = arc4random() % 26;
        b2 = arc4random() % 26;
        b3 = arc4random() % 26;
        b4 = arc4random() % 26;
        NSString *tempString2= [[NSString alloc]initWithFormat:@"%@ %@ %@ %@",[array objectAtIndex:b1],[array objectAtIndex:b2],[array objectAtIndex:b3],[array objectAtIndex:b4]];
        [thirdBtn setTitle:tempString2 forState:UIControlStateNormal];
    }
}

-(IBAction) firstBtnClick : (id)sender
{
    if([firstBtn.titleLabel.text isEqualToString:rendomString])
    {
        if(part==1)
        {
            rightEyeResult++;
            
        }
        if(part==2)
        {
            leftEyeResult++;
            
        }
    }
    else
    {
        redImageView.hidden=NO;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];

    //[self jump1];
}
-(IBAction) secondBtnClick : (id)sender
{
    if([secondBtn.titleLabel.text isEqualToString:rendomString])
    {
        if(part==1)
        {
            rightEyeResult++;
            
        }
        if(part==2)
        {
            leftEyeResult++;
           
        }
    }
    else
    {
        redImageView.hidden=NO;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];
}
-(IBAction) thirdBtnClick : (id)sender
{
    if([thirdBtn.titleLabel.text isEqualToString:rendomString])
    {
        if(part==1)
        {
            rightEyeResult++;
           
        }
        if(part==2)
        {
            leftEyeResult++;
        
        }
    }
    else
    {
        redImageView.hidden=NO;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];
}
-(IBAction) noteSureBtnClick : (id)sender
{
    redImageView.hidden=NO;

    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(IBAction) findOpticianBtnClick : (id)sender
{
    
}
-(IBAction) nextTestBtnClick : (id)sender
{
    Astigmatism *asti=[[Astigmatism alloc]init];
    asti.title=@"Astigmatism";
    [self.navigationController pushViewController:asti animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    app=[GlobalVariable sharedInstance];
    
    redImageView.hidden=YES;
    firstBtn.hidden=YES;
    secondBtn.hidden=YES;
    thirdBtn.hidden=YES;
    notSureBtn.hidden=YES;
    rendomTextLbl.hidden=YES;
    leftEyeLbl.hidden=YES;
    rightEyeLbl.hidden=YES;
    nextTest.hidden=YES;
    findOptician.hidden=YES;
    array=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
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
//9722486258
