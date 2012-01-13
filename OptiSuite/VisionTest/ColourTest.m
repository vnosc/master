//
//  ColourTest.m
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "ColourTest.h"
#import "Questions.h"

@implementation ColourTest
static int w=1;
int e1;
static int scoreResult=0;
@synthesize scoreLbl,rendomString;

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
-(IBAction) nextTestBtnClick : (id) sender
{
    Questions *qst=[[Questions alloc]init];
    qst.title=@"Questions";
    [self.navigationController pushViewController:qst animated:YES];
}
-(IBAction) findOpticianBtnClick : (id) sender
{
    
}
-(IBAction) startTestBtnClick : (id) sender
{
    w=1;
    scoreResult=0;
    [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(jump1) userInfo:nil repeats:NO];

}
-(void) jump1
{
    redImageView.hidden=YES;
    mainImage.hidden=YES;
    smallImage.hidden=NO;
    firstBtn.hidden=YES;
    secondBtn.hidden=YES;
    thirdBtn.hidden=YES;
    notSureBtn.hidden=YES;
    fourthBtn.hidden=YES;
    startTestBtn.hidden=YES;
        
    if(w<6)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];  
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [UIView commitAnimations];
            
        NSLog(@"The value of x is : %i",w);
        if (w==1) {
            smallImage.image=[UIImage imageNamed:@"colortestimage1.png"]; 
            rendomString=@"29";
        }    
        if (w==2) {
            smallImage.image=[UIImage imageNamed:@"colortestimage2.png"]; 
            rendomString=@"74";
        }
        if (w==3) {
            smallImage.image=[UIImage imageNamed:@"colortestimage3.png"]; 
            rendomString=@"42";
        }
        if (w==4) {
            smallImage.image=[UIImage imageNamed:@"colortestimage4.png"]; 
            rendomString=@"6";
        }
        if (w==5) {
            smallImage.image=[UIImage imageNamed:@"colortestimage5.png"]; 
            rendomString=@"2";
        }
          
            
        
        w++;
        [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeView) userInfo:nil repeats:NO];
            
            
    }
    else
    {
           
        if(scoreResult==5)
        {
            mainImage.hidden=NO;
            smallImage.hidden=YES;
            firstBtn.hidden=YES;
            secondBtn.hidden=YES;
            thirdBtn.hidden=YES;
            fourthBtn.hidden=YES;
            mainImage.image=[UIImage imageNamed:@"pass.png"];
            findOpticianBtn.hidden=NO;
            nextTestBtn.hidden=NO;
            app.colorTestLeftEye=@"100%";
            app.colorTestRightEye=@"100%";
        }
        else
        {
            mainImage.hidden=NO;
            smallImage.hidden=YES;
            firstBtn.hidden=YES;
            secondBtn.hidden=YES;
            thirdBtn.hidden=YES;
            fourthBtn.hidden=YES;
            mainImage.image=[UIImage imageNamed:@"failenobtn.png"];
            scoreLbl.hidden=NO;
            findOpticianBtn.hidden=NO;
            nextTestBtn.hidden=NO;
                    
            int per=0;
            per=scoreResult*100/5;
           
             NSString *demo=@"%";
            app.colorTestLeftEye=[NSString stringWithFormat:@"%i%@",per,demo];
            app.colorTestRightEye=[NSString stringWithFormat:@"%i%@",per,demo];
                    
           
                    
            NSString *result=[[NSString alloc]initWithFormat:@"SCORE - %i%@ ",per,demo];
            scoreLbl.text=result;
                    
                    
                
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
    smallImage.hidden=YES;
    mainImage.image=[UIImage imageNamed:@"acuity.png"];
    
    firstBtn.hidden=NO;
    
    secondBtn.hidden=NO;
    thirdBtn.hidden=NO;
    fourthBtn.hidden=NO;
    notSureBtn.hidden=NO;
   
    
    int buttonTitle=arc4random() % 4;
    if(buttonTitle==0)
    {
        buttonTitle=4;
    }
    NSLog(@"Button title no is : %i",buttonTitle);
    
    if(buttonTitle==1)
    {
        [firstBtn setTitle:rendomString forState:UIControlStateNormal];
    }
    else
    {
        e1 = arc4random() % 99;
        
        NSString *tempString= [[NSString alloc]initWithFormat:@"%i",e1];
        [firstBtn setTitle:tempString forState:UIControlStateNormal];
        
    }
    if(buttonTitle ==2)
    {
        [secondBtn setTitle:rendomString forState:UIControlStateNormal];
        
    }
    else
    {
        e1 = arc4random() % 99;
        
        NSString *tempString1= [[NSString alloc]initWithFormat:@"%i",e1];
        [secondBtn setTitle:tempString1 forState:UIControlStateNormal];
    }
    if(buttonTitle ==3)
    {
        [thirdBtn setTitle:rendomString forState:UIControlStateNormal];
        
    }
    else
    {
        e1 = arc4random() % 99;
        
        NSString *tempString2= [[NSString alloc]initWithFormat:@"%i",e1];
        [thirdBtn setTitle:tempString2 forState:UIControlStateNormal];
    }
    if(buttonTitle ==4)
    {
        [fourthBtn setTitle:rendomString forState:UIControlStateNormal];
        
    }
    else
    {
        e1 = arc4random() % 99;
        
        NSString *tempString3= [[NSString alloc]initWithFormat:@"%i",e1];
        [fourthBtn setTitle:tempString3 forState:UIControlStateNormal];
    }
}


-(IBAction) firstBtnClick : (id) sender
{
    if([firstBtn.titleLabel.text isEqualToString:rendomString])
    {
        scoreResult++;
    }
    else
    {
        redImageView.hidden=NO;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];    //[self jump1];
}
-(IBAction) secondBtnClick : (id) sender
{
    if([secondBtn.titleLabel.text isEqualToString:rendomString])
    {
        scoreResult++;
    }
    else
    {
        redImageView.hidden=NO;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];

}
-(IBAction) thirdBtnClick : (id) sender
{
    if([thirdBtn.titleLabel.text isEqualToString:rendomString])
    {
        scoreResult++;
    }
    else
    {
        redImageView.hidden=NO;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];

}
-(IBAction) fourthBtnClick : (id) sender
{
    if([fourthBtn.titleLabel.text isEqualToString:rendomString])
    {
        scoreResult++;
    }
    else
    {
        redImageView.hidden=NO;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];
}
-(IBAction) notSureBtnClick : (id) sender
{
    redImageView.hidden=NO;

    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(jump1) userInfo:nil repeats:NO];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    app=[GlobalVariable sharedInstance];
    findOpticianBtn.hidden=YES;
    nextTestBtn.hidden=YES;
    smallImage.hidden=YES;
    scoreLbl.hidden=YES;
    firstBtn.hidden=YES;
    secondBtn.hidden=YES;
    thirdBtn.hidden=YES;
    fourthBtn.hidden=YES;
    notSureBtn.hidden=YES;
    redImageView.hidden=YES;
    
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
