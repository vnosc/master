//
//  Questions.m
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "Questions.h"
#import "TestResults.h"
int m=1;
int result=0;
@implementation Questions
@synthesize questionLbl,scoreLbl;
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
-(void) jump1
{
    if(m<4)
    {
        yesBtn.hidden=NO;
        noBtn.hidden=NO;
           
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];  
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [UIView commitAnimations];
        if(m==1)
        {
            questionLbl.text=@"Do you smoke, of are in regular close proximity of someone who does?";
        }
        if(m==2)
        {
            questionLbl.text=@"Working on a computer after a period of time, do you experience headaches or tired eyes?";
        }
        if(m==3)
        {
            questionLbl.text=@"Has it been over 2 years since your last eye test?";
        }
            
        NSLog(@"The value of x is : %i",m);
            
                        
            
    }
    else
    {
        if(result==3)
        {
            questionLbl.hidden=YES;
            mainImage.hidden=NO;
            mainImage.image=[UIImage imageNamed:@"pass.png"];
            findOpticianBtn.hidden=NO;
            myResultBtn.hidden=NO;
            yesBtn.hidden=YES;
            noBtn.hidden=YES;
            app.questionLeftEye=@"100%";
            app.questionRightEye=@"100%";
        }
        else
        {
            questionLbl.hidden=YES;
            yesBtn.hidden=YES;
            noBtn.hidden=YES;
            findOpticianBtn.hidden=NO;
            myResultBtn.hidden=NO;
            mainImage.hidden=NO;
            mainImage.image=[UIImage imageNamed:@"failenobtn.png"];
            scoreLbl.hidden=NO;
                    
            int per=0;
            per=result*100/3;
                    
                    
            NSString *demo=@"%";
            NSString *finalResult=[[NSString alloc]initWithFormat:@"%i%@",per,demo];
            app.questionLeftEye=finalResult;
            app.questionRightEye=finalResult;
                    
            NSString *resultinper=[[NSString alloc]initWithFormat:@"SCORE - %i%@ ",per,demo];
                scoreLbl.text=resultinper;
                    
        }
    }
}
-(IBAction) yesAndNoBtnClick : (id) sender
{
    UIButton *btn=(UIButton *) sender;
    int btnTag= btn.tag;
    if(btnTag==2)
    {
        result++;
            
    }
    m++;
    
    [self jump1];

}
-(IBAction) findOpticianBtnClick : (id) sender
{
    
}
-(IBAction) myResultBtnClick : (id) sender
{
    TestResults *tr=[[TestResults alloc]init];
    tr.title=@"Test Results";
    [self.navigationController pushViewController:tr animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    app=[[UIApplication sharedApplication]delegate];
    m=1;
    result=0;
    findOpticianBtn.hidden=YES;
    myResultBtn.hidden=YES;
    scoreLbl.hidden=YES;
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
