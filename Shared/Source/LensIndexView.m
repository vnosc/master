//  LensIndexView.m
//  LENSIndex
//  Created by Patel on 11/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
#import "LensIndexView.h"

@implementation LensIndexView
@synthesize mainViewController;
@synthesize arrayData,arrayData1,tample,tample2,glass,glass2;

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
    NSLog(@"LensIndexview viewDidLoad ");
    [super viewDidLoad];
   // self.view.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    arrayData=[[NSMutableArray alloc]init];
    [arrayData addObject:@"1.74"];
    [arrayData addObject:@"1.67"];
    [arrayData addObject:@"1.6"];
    [arrayData addObject:@"1.5"];
    
    
    arrayData1=[[NSMutableArray alloc]init];
    [arrayData1 addObject:@"-8"];
    [arrayData1 addObject:@"-4"];
    [arrayData1 addObject:@"-2"];
    [arrayData1 addObject:@"+2"];
    [arrayData1 addObject:@"+4"];
    [arrayData1 addObject:@"+8"];
    NSLog(@"value");
}

	



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return YES;
	//return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        if(pickerView.tag==1)
        {
            tample.image=[UIImage imageNamed:@"9.png"];
            
                
                [arrayData1 objectAtIndex:[pickerView selectedRowInComponent:1]];
                NSString *value=[arrayData objectAtIndex:[pickerView selectedRowInComponent:0]];
                NSString *value2=[arrayData1 objectAtIndex:[pickerView selectedRowInComponent:1]];
            NSLog(@"value is : %@",value);
            NSLog(@"second value is : %@",value2);
                if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"-8"])
                {
                    glass.image=[UIImage imageNamed:@"10.png"];

                }
                if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"-8"])
                {
                    glass.image=[UIImage imageNamed:@"G11.png"];//b1.png
                }
                if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"-8"])
                {
                    glass.image=[UIImage imageNamed:@"H11.png"];
                }
                if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"-8"])
                {
                    glass.image=[UIImage imageNamed:@"I11.png"];
                }
                
            
            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"-4"])
                {
                    glass.image=[UIImage imageNamed:@"13.png"];
                }
                if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"-4"])
                {
                    glass.image=[UIImage imageNamed:@"G12.png"];
                }
                if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"-4"])
                {
                    glass.image=[UIImage imageNamed:@"H12.png"];
                }
                if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"-4"])
                {
                    glass.image=[UIImage imageNamed:@"I12.png"];
                }
            
            
            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"-2"])
            {
                glass.image=[UIImage imageNamed:@"16.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"-2"])
            {
                glass.image=[UIImage imageNamed:@"G13.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"-2"])
            {
                glass.image=[UIImage imageNamed:@"H13.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"-2"])
            {
                glass.image=[UIImage imageNamed:@"I13.png"];
            }
            
            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"+2"])
            {
                glass.image=[UIImage imageNamed:@"16.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"+2"])
            {
                glass.image=[UIImage imageNamed:@"G14.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"+2"])
            {
                glass.image=[UIImage imageNamed:@"H14.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"+2"])
            {
                glass.image=[UIImage imageNamed:@"I14.png"];
            }

            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"+4"])
            {
                glass.image=[UIImage imageNamed:@"13.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"+4"])
            {
                glass.image=[UIImage imageNamed:@"G12.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"+4"])
            {
                glass.image=[UIImage imageNamed:@"H12.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"+4"])
            {
                glass.image=[UIImage imageNamed:@"I12.png"];
            }

            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"+8"])
            {
                glass.image=[UIImage imageNamed:@"10.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"+8"])
            {
                glass.image=[UIImage imageNamed:@"G11.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"+8"])
            {
                glass.image=[UIImage imageNamed:@"H11.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"+8"])
            {
                glass.image=[UIImage imageNamed:@"I11.png"];
            }


           
        }
        if(pickerView.tag==2)
        {
            tample2.image=[UIImage imageNamed:@"8.png"];
            
                        
            
            [arrayData1 objectAtIndex:[pickerView selectedRowInComponent:1]];
            NSString *value=[arrayData objectAtIndex:[pickerView selectedRowInComponent:0]];
            NSString *value2=[arrayData1 objectAtIndex:[pickerView selectedRowInComponent:1]];
            NSLog(@"value is : %@",value);
            NSLog(@"second value is : %@",value2);
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"-8"])
            {
                glass2.image=[UIImage imageNamed:@"11.png"];
                
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"-8"])
            {
                glass2.image=[UIImage imageNamed:@"G1.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"-8"])
            {
                glass2.image=[UIImage imageNamed:@"H1.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"-8"])
            {
                glass2.image=[UIImage imageNamed:@"I1.png"];
            }
            
            
            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"-4"])
            {
                glass2.image=[UIImage imageNamed:@"14.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"-4"])
            {
                glass2.image=[UIImage imageNamed:@"G2.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"-4"])
            {
                glass2.image=[UIImage imageNamed:@"H2.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"-4"])
            {
                glass2.image=[UIImage imageNamed:@"I2.png"];
            }
            
            
            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"-2"])
            {
                glass2.image=[UIImage imageNamed:@"17.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"-2"])
            {
                glass2.image=[UIImage imageNamed:@"G3.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"-2"])
            {
                glass2.image=[UIImage imageNamed:@"H3.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"-2"])
            {
                glass2.image=[UIImage imageNamed:@"I3.png"];
            }
            
            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"+2"])
            {
                glass2.image=[UIImage imageNamed:@"17.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"+2"])
            {
                glass2.image=[UIImage imageNamed:@"G4.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"+2"])
            {
                glass2.image=[UIImage imageNamed:@"H4.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"+2"])
            {
                glass2.image=[UIImage imageNamed:@"I4.png"];
            }
            
            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"+4"])
            {
                glass2.image=[UIImage imageNamed:@"14.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"+4"])
            {
                glass2.image=[UIImage imageNamed:@"G2.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"+4"])
            {
                glass2.image=[UIImage imageNamed:@"H2.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"+4"])
            {
                glass2.image=[UIImage imageNamed:@"I2.png"];
            }
            
            
            
            if([value isEqualToString:@"1.74"] && [value2 isEqualToString:@"+8"])
            {
                glass2.image=[UIImage imageNamed:@"11.png"];
            }
            if([value isEqualToString:@"1.67"]&&[value2 isEqualToString:@"+8"])
            {
                glass2.image=[UIImage imageNamed:@"G1.png"];
            }
            if([value isEqualToString:@"1.6"]&&[value2 isEqualToString:@"+8"])
            {
                glass2.image=[UIImage imageNamed:@"H1.png"];
            }
            if([value isEqualToString:@"1.5"]&&[value2 isEqualToString:@"+8"])
            {
                glass2.image=[UIImage imageNamed:@"I1.png"];
            }

        
        }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if(component==0)
	return [arrayData count];
    else
        return [arrayData1 count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if(component==0)
        return [arrayData objectAtIndex:row];
    else
        return [arrayData1 objectAtIndex:row];
}
@end 