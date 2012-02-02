//
//  LensThicknessPage.m
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LensThicknessPage.h"

@implementation LensThicknessPage
@synthesize picker;
@synthesize frontLens;
@synthesize sideLens;

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
    
    frontLensImages = [[NSMutableDictionary alloc] init];
    sideLensImages = [[NSMutableDictionary alloc] init];
    
    for (NSString *index in arrayData)
        for (NSString *rx in arrayData1)
        {
            NSString *frontFilename = [self imageNameForOrientation:@"Front" index:index rx:rx];
            [frontLensImages setObject:[UIImage imageNamed:frontFilename] forKey:frontFilename];
            NSLog(@"%@", frontFilename);

            NSString *sideFilename = [self imageNameForOrientation:@"side" index:index rx:rx];            
            [sideLensImages setObject:[UIImage imageNamed:sideFilename] forKey:sideFilename];
            NSLog(@"%@", sideFilename);
        }
    
    [self changeLensImages];
    NSLog(@"value");
}
             
- (NSString*) imageNameForOrientation:(NSString*)orient pos1:(int)pos1 pos2:(int)pos2
{
    NSString* index = [arrayData objectAtIndex:pos1];
    NSString* rx = [arrayData1 objectAtIndex:pos2];
    return [self imageNameForOrientation:orient index:index rx:rx];
}

- (NSString*) imageNameForOrientation:(NSString*)orient index:(NSString*)index rx:(NSString*)rx
{
    index = [index stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    rx = [NSString stringWithFormat:@"%d", abs([rx intValue])];
     
    NSString* filename = [NSString stringWithFormat:@"%@_%@_%@.png", orient, index, rx];
    return filename;
 }

- (void)viewDidUnload
{
    [self setPicker:nil];
    [self setFrontLens:nil];
    [self setSideLens:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [picker release];
    [frontLens release];
    [sideLens release];
    [super dealloc];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [self changeLensImages];
}

- (void) changeLensImages
{
    UIPickerView *pickerView = self.picker;
    
    [arrayData1 objectAtIndex:[pickerView selectedRowInComponent:1]];
    NSString *value=[arrayData objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString *value2=[arrayData1 objectAtIndex:[pickerView selectedRowInComponent:1]];
    NSLog(@"value is : %@",value);
    NSLog(@"second value is : %@",value2);
    
    NSString *frontFilename = [self imageNameForOrientation:@"Front" index:value rx:value2];
    NSString *sideFilename = [self imageNameForOrientation:@"side" index:value rx:value2];
    
    self.frontLens.image = [frontLensImages objectForKey:frontFilename];
    self.sideLens.image = [sideLensImages objectForKey:sideFilename];
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
        return [arrayData count];
    else
        return [arrayData1 count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
        return [arrayData objectAtIndex:row];
    else
        return [arrayData1 objectAtIndex:row];
}

/*- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    UILabel *pickerLabel = (UILabel*)view;
    
    if (pickerLabel == nil)
    {
        CGRect frame = CGRectMake(0, 0, 80, 32);
        pickerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        [pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextColor:[UIColor blackColor]];
    }
    
    if(component==0)
        [pickerLabel setText:[arrayData objectAtIndex:row]];
    else
        [pickerLabel setText:[arrayData1 objectAtIndex:row]];
    
    return pickerLabel;
}*/
@end
