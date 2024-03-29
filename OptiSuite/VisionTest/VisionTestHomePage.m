//
//  HomePage.m
//  VisionTest
//
//  Created by MAC OS on 12/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VisionTestHomePage.h"
#import "Astigmatism.h"
#import "ColourTest.h"
#import "DistanceVision.h"
#import "TestResults.h"
#import "Settings.h"
#import "EyeAdvice.h"
#import "OpticianFinder.h"
#import "Questions.h"
#import "Duochrome.h"
#import "VisualAcuity.h"
#import <unistd.h>
#import <QuartzCore/QuartzCore.h>


@implementation VisionTestHomePage



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
-(void)viewWillAppear:(BOOL)animated
{
    homepageView.backgroundColor=[UIColor clearColor];
    visualView.backgroundColor=[UIColor clearColor];
    astigmatismView.backgroundColor=[UIColor clearColor];
    duochromeView.backgroundColor=[UIColor clearColor];
    colourView.backgroundColor=[UIColor clearColor];
    questionsView.backgroundColor=[UIColor clearColor];
    distanceView.backgroundColor=[UIColor clearColor];
    opticianView.backgroundColor=[UIColor clearColor];
    testView.backgroundColor=[UIColor clearColor];
    eyeView.backgroundColor=[UIColor clearColor];
    settingView.backgroundColor=[UIColor clearColor];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(IBAction) buttonClicked:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 620, 800)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:homepageView cache:YES];
    [homepageView setFrame:CGRectMake(202, 277, 365, 357)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [homepageView removeFromSuperview];
    homepageView.layer.cornerRadius=0;
    homepageView.layer.masksToBounds=0;

    [self.view addSubview:homepageView];
    [howerView removeFromSuperview];
}

-(IBAction) homeBtnClick: (id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];
   
    [howerView addSubview:b];
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:homepageView cache:YES];
    
    [howerView addSubview:homepageView];
    homepageView.layer.cornerRadius=20;
    homepageView.layer.masksToBounds=40;
    [homepageView setFrame:CGRectMake(70, 60, 620, 800)];
    VisualAcuity *va=[[VisualAcuity alloc]init];
    va.title=@"Visual Acuity";
    nav=[[UINavigationController alloc]initWithRootViewController:va];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [homepageView addSubview:nav.view];
    
    [UIView commitAnimations];
}
-(IBAction) buttonClicked2:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:astigmatismView cache:YES];
    [astigmatismView setFrame:CGRectMake(202,92 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview]; 
    astigmatismView.layer.cornerRadius=0;
    astigmatismView.layer.masksToBounds=0;
    [astigmatismView removeFromSuperview];
    [self.view addSubview:astigmatismView];
    [howerView removeFromSuperview];
}

-(IBAction)showAstigmatism:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
   [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked2:) forControlEvents:UIControlEventTouchUpInside];
   
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:astigmatismView cache:YES];
    
    [howerView addSubview:astigmatismView];
    astigmatismView.layer.cornerRadius=20;
    astigmatismView.layer.masksToBounds=40;
    
    [astigmatismView setFrame:CGRectMake(70, 60, 620, 800)];
    Astigmatism *astig=[[Astigmatism alloc]init];
    astig.title=@"Astigmatism";
    nav=[[UINavigationController alloc]initWithRootViewController:astig];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [astigmatismView addSubview:nav.view];
    
    [UIView commitAnimations];
}
-(IBAction) buttonClicked3:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:duochromeView cache:YES];
    [duochromeView setFrame:CGRectMake(387,92 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];
    duochromeView.layer.cornerRadius=0;
    duochromeView.layer.masksToBounds=0;

    [duochromeView removeFromSuperview];
    [self.view addSubview:duochromeView];
    [howerView removeFromSuperview];
}
-(IBAction)showDuochrome:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];

    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked3:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:duochromeView cache:YES];
    
    [howerView addSubview:duochromeView];
    duochromeView.layer.cornerRadius=20;
    duochromeView.layer.masksToBounds=40;
    
    [duochromeView setFrame:CGRectMake(70, 60, 620, 800)];

    Duochrome *duoch=[[Duochrome alloc]init];
    duoch.title=@"Duochrome";
    nav=[[UINavigationController alloc]initWithRootViewController:duoch];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [duochromeView addSubview:nav.view];
    
    [UIView commitAnimations];
}
-(IBAction) buttonClicked4:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:colourView cache:YES];
    [colourView setFrame:CGRectMake(572,181 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [colourView removeFromSuperview];
    colourView.layer.cornerRadius=0;
    colourView.layer.masksToBounds=0;
    [self.view addSubview:colourView];
    [howerView removeFromSuperview];
}

-(IBAction)showColourTest:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked4:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:colourView cache:YES];
    
    [howerView addSubview:colourView];
    colourView.layer.cornerRadius=20;
    colourView.layer.masksToBounds=40;
    
        [colourView setFrame:CGRectMake(70, 60, 620, 800)];
    
    ColourTest *color=[[ColourTest alloc]init];
    color.title=@"Color Test";
    nav=[[UINavigationController alloc]initWithRootViewController:color];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [colourView addSubview:nav.view];
    
    [UIView commitAnimations];
}
-(IBAction) buttonClicked5:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:questionsView cache:YES];
        [questionsView setFrame:CGRectMake(572,366 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [questionsView removeFromSuperview];
    questionsView.layer.cornerRadius=0;
    questionsView.layer.masksToBounds=0;
    [self.view addSubview:questionsView];
    [howerView removeFromSuperview];
}
-(IBAction)showQuestions:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked5:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:questionsView cache:YES];
    
    [howerView addSubview:questionsView];
    questionsView.layer.cornerRadius=20;
    questionsView.layer.masksToBounds=40;
    
    [questionsView setFrame:CGRectMake(70, 60, 620, 800)];
    
    
    Questions *ques=[[Questions alloc]init];
    ques.title=@"Questions";
    nav=[[UINavigationController alloc]initWithRootViewController:ques];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [questionsView addSubview:nav.view];
    
    [UIView commitAnimations];
}
-(IBAction) buttonClicked6:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:distanceView cache:YES];
    [distanceView setFrame:CGRectMake(572,551 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [distanceView removeFromSuperview];
    distanceView.layer.cornerRadius=0;
    distanceView.layer.masksToBounds=0;
    [self.view addSubview:distanceView];
    [howerView removeFromSuperview];
}
-(IBAction)showDistanceVision:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked6:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:distanceView cache:YES];
    
    [howerView addSubview:distanceView];
    distanceView.layer.cornerRadius=20;
    distanceView.layer.masksToBounds=40;
    
    [distanceView setFrame:CGRectMake(70, 60, 620, 800)];
    DistanceVision *dv=[[DistanceVision alloc]init];
    dv.title=@"Distance Vision";
    nav=[[UINavigationController alloc]initWithRootViewController:dv];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [distanceView addSubview:nav.view];
    
    
    [UIView commitAnimations];

}
-(IBAction) buttonClicked7:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:opticianView cache:YES];
    [opticianView setFrame:CGRectMake(387,639 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [opticianView removeFromSuperview];
    opticianView.layer.cornerRadius=0;
    opticianView.layer.masksToBounds=0;
    [self.view addSubview:opticianView];
    [howerView removeFromSuperview];
    
    
}
-(IBAction)showOpticianFinder:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
   
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked7:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:opticianView cache:YES];
    
    [howerView addSubview:opticianView];
    opticianView.layer.cornerRadius=20;
    opticianView.layer.masksToBounds=40;
    
     [opticianView setFrame:CGRectMake(70, 60, 620, 800)];
    OpticianFinder *of=[[OpticianFinder alloc]init];
    of.title=@"Optician Finder";
    nav=[[UINavigationController alloc]initWithRootViewController:of];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [opticianView addSubview:nav.view];
    
    
    [UIView commitAnimations];

}
-(IBAction) buttonClicked8:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:testView cache:YES];
    [testView setFrame:CGRectMake(202,639 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [testView removeFromSuperview];
    testView.layer.cornerRadius=0;
    testView.layer.masksToBounds=0;
    [self.view addSubview:testView];
    [howerView removeFromSuperview];
    
    
}

-(IBAction)showTestResults:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
   
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked8:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:testView cache:YES];
    
    [howerView addSubview:testView];
    testView.layer.cornerRadius=20;
    testView.layer.masksToBounds=40;
     [testView setFrame:CGRectMake(70, 60, 620, 800)];
    
    TestResults *tr=[[TestResults alloc]init];
    tr.title=@"Test Results";
    nav=[[UINavigationController alloc]initWithRootViewController:tr];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [testView addSubview:nav.view];
    
    
    [UIView commitAnimations];

}
-(IBAction) buttonClicked9:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:eyeView cache:YES];
    [eyeView setFrame:CGRectMake(17,551 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [eyeView removeFromSuperview];
    eyeView.layer.cornerRadius=0;
    eyeView.layer.masksToBounds=0;
    [self.view addSubview:eyeView];
    [howerView removeFromSuperview];
    
    
}
-(IBAction)showEyeAdvice:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
   
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked9:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:eyeView cache:YES];
    
    [howerView addSubview:eyeView];
    eyeView.layer.cornerRadius=20;
    eyeView.layer.masksToBounds=40;
    
    [eyeView setFrame:CGRectMake(70, 60, 620, 800)];
    EyeAdvice *ea=[[EyeAdvice alloc]init];
    ea.title=@"Eye Advice";
    nav=[[UINavigationController alloc]initWithRootViewController:ea];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [eyeView addSubview:nav.view];
    
    
    [UIView commitAnimations];

}
-(IBAction) buttonClicked10:(id) sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:settingView cache:YES];
    [settingView setFrame:CGRectMake(17,366 , 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [settingView removeFromSuperview];
    settingView.layer.cornerRadius=0;
    settingView.layer.masksToBounds=0;
    [self.view addSubview:settingView];
    [howerView removeFromSuperview];
}
-(IBAction)showSettings:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
   
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked10:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:settingView cache:YES];
    
    [howerView addSubview:settingView];
    settingView.layer.cornerRadius=20;
    settingView.layer.masksToBounds=40;
    [settingView setFrame:CGRectMake(70, 60, 620, 800)];
    
    Settings *sett=[[Settings alloc]init];
    sett.title=@"Settings";
    nav=[[UINavigationController alloc]initWithRootViewController:sett];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [settingView addSubview:nav.view];
    
    [UIView commitAnimations];
}



-(IBAction)showVisualAcuity:(id)sender
{
    howerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    //[visualView setFrame:CGRectMake(70, 70, 620, 800)];
    [self.view addSubview:howerView];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(buttonClicked1:) forControlEvents:UIControlEventTouchUpInside];
    b.frame=CGRectMake(15,15,50,50);
    [b setBackgroundImage:[UIImage imageNamed:@"closeButton.png"] forState:UIControlStateNormal];

    [howerView addSubview:b];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:visualView cache:YES];
    
    [howerView addSubview:visualView];
    visualView.layer.cornerRadius=20;
    visualView.layer.masksToBounds=40;
    [visualView setFrame:CGRectMake(70, 60, 620, 800)];
    VisualAcuity *va=[[VisualAcuity alloc]init];
    va.title=@"Visual Acuity";
    nav=[[UINavigationController alloc]initWithRootViewController:va];
    nav.view.frame=CGRectMake(0, 0, 620, 800);
    [visualView addSubview:nav.view];
    
    [UIView commitAnimations];
}
-(IBAction) buttonClicked1 : (id)sender
{
    [howerView setFrame:CGRectMake(70, 60, 768, 1024)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:visualView cache:YES];
    [visualView setFrame:CGRectMake(17, 181, 180, 180)];
    [UIView commitAnimations];
    [nav.view removeFromSuperview];   
    [visualView removeFromSuperview];
    visualView.layer.cornerRadius=0;
    visualView.layer.masksToBounds=0;
    [self.view addSubview:visualView];
    [howerView removeFromSuperview];

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
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	UIView *content = [[self.view subviews] objectAtIndex:0];
	((UIScrollView *)self.view).contentSize = content.bounds.size;
}


@end
