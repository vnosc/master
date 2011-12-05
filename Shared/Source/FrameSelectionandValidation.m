//
//  FrameSelectionandValidation.m
//  CyberImaging
//
//  Created by Kaushik on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FrameSelectionandValidation.h"
#import <QuartzCore/QuartzCore.h>
#import "PatientPrescription.h"
static int a=0;

@implementation FrameSelectionandValidation
@synthesize typedata1,typedata2,dropdownBtn1,dropdownBtn2,image1,image2;

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
    
    image1.layer.borderWidth = 1;
	image1.layer.borderColor = [[UIColor grayColor] CGColor];
    
    image2.layer.borderWidth = 1;
	image2.layer.borderColor = [[UIColor grayColor] CGColor];
    
    typedata1 =[[NSArray alloc]initWithArray:[NSArray arrayWithObjects:@"1",@"2",@"3",nil]];
	dropDownView1 = [[DropDownView alloc] initWithArrayData:typedata1 cellHeight:30 heightTableView:100 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:dropdownBtn1 animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
	
	typedata2 =[[NSArray alloc]initWithArray:[NSArray arrayWithObjects:@"1",@"2",@"3",nil]];
	dropDownView2 = [[DropDownView alloc] initWithArrayData:typedata2 cellHeight:30 heightTableView:100 paddingTop:-8 paddingLeft:-5 paddingRight:-10 refView:dropdownBtn2 animation:BLENDIN openAnimationDuration:0.2 closeAnimationDuration:0.2];
    
    dropDownView1.delegate =self;
	dropDownView2.delegate =self;
    
    [self.view addSubview:dropDownView1.view];
	[self.view addSubview:dropDownView2.view];
    /*[dropdownBtn1 setTitle:[typedata1 objectAtIndex:0] forState:UIControlStateNormal];
	[dropdownBtn2 setTitle:[typedata2 objectAtIndex:0] forState:UIControlStateNormal];*/

}

-(void)dropDownCellSelected:(NSInteger)returnIndex
{
	if(a==1)
	{
		[dropdownBtn1 setTitle:[typedata1 objectAtIndex:returnIndex] forState:UIControlStateNormal];
	}
	if (a==2)
	{
		[dropdownBtn2 setTitle:[typedata2 objectAtIndex:returnIndex] forState:UIControlStateNormal];
	}
}

-(IBAction) selectandcontinueBtnClick : (id) sender
{
    PatientPrescription *patient=[[PatientPrescription alloc]init];
    patient.title=@"Patient information and prescription";
    [self.navigationController pushViewController:patient animated:YES];
}

-(IBAction) mensRadioclick : (id)sender
{
    [btn_mens setSelected:YES];
    [btn_womens setSelected:NO];
    [btn_childrens setSelected:NO];
    [btn_unisex setSelected:NO];
    
    
}
-(IBAction) womensRadioclick : (id)sender
{
    [btn_mens setSelected:NO];
    [btn_womens setSelected:YES];
    [btn_childrens setSelected:NO];
    [btn_unisex setSelected:NO];
    
    
}
-(IBAction) childrensRadioclick : (id)sender
{
    [btn_mens setSelected:NO];
    [btn_womens setSelected:NO];
    [btn_childrens setSelected:YES];
    [btn_unisex setSelected:NO];
}
-(IBAction) unisexRadioclick : (id)sender
{
    [btn_mens setSelected:NO];
    [btn_womens setSelected:NO];
    [btn_childrens setSelected:NO];
    [btn_unisex setSelected:YES];
}
-(IBAction) sportRadioclick : (id)sender
{
    [btn_sport setSelected:YES];
    [btn_computer setSelected:NO];
    [btn_outdoor setSelected:NO];

}
-(IBAction) computerRadioclick : (id)sender
{
    [btn_sport setSelected:NO];
    [btn_computer setSelected:YES];
    [btn_outdoor setSelected:NO];

}
-(IBAction) outdoorRadioclick : (id)sender
{
    [btn_sport setSelected:NO];
    [btn_computer setSelected:NO];
    [btn_outdoor setSelected:YES];

}

-(IBAction) droapdownBtnClick1:(id)sender
{
    [dropDownView1 openAnimation];
	a=1;
}
-(IBAction) droapdownBtnClick2:(id)sender
{
    [dropDownView2 openAnimation];
	a=2;
}

- (void)viewDidUnload
{
	//[self setWebView:nil];
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
