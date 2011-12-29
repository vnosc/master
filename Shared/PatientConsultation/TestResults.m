//
//  TestResults.m
//  VisionTest
//
//  Created by nitesh suvagia on 12/6/11.
//  Copyright (c) 2011 creativeinfoway. All rights reserved.
//

#import "TestResults.h"
static int tabItemIndex = 1;
@implementation TestResults
@synthesize testNameArray;
@synthesize testResultArray;
@synthesize nextPageLeftArray,nextPageNameArray,nextPageRightArray;
@synthesize imageArray;
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
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    tabItemIndex=item.tag;
    NSLog(@"tab bar item tag is : %i",item.tag);
    // You can put logic in here to check on what item was pressed and fire the different methods depending on what you put.  
    if ([[item title] isEqualToString:@"Diagnostic"]) {
        NSLog(@"Pressed on Diagnostic tab!!");
        [table1 reloadData];
        
        secondView.hidden=YES;
    } 
    else if ([[item title] isEqualToString:@"Results"]) {
        NSLog(@"Pressed on Results tab!!");
        [table2 reloadData];
        secondView.hidden=NO;
    }
}

-(IBAction) tabbarFirstBtnClick : (id)sender
{
    
}
-(IBAction) tabbarSecondBtnClick : (id)sender
{
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    tabItemIndex=1;
    [tabBar setSelectedItem:first];
    secondView.hidden=YES;
    app=[[UIApplication sharedApplication]delegate];
    testResultArray=[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];
    nextPageLeftArray=[[NSMutableArray alloc]init];
    nextPageNameArray=[[NSMutableArray alloc]init];
    nextPageRightArray =[[NSMutableArray alloc]init];
    testNameArray=[[NSMutableArray alloc]initWithObjects:@"Visual Acuity",@"Astigmatism",@"Duochrome",@"Color Test",@"Questions", nil];
    
    
    
       
    if([app.visualAcuityLeftEye isEqualToString:@"100%"] && [app.visualAcuityRightEye isEqualToString:@"100%"])
    {
        [testResultArray addObject:@"Your short field vision appears to be fine"];
        [imageArray addObject:@"right.png"];
    }
    else
    {
        if([app.visualAcuityLeftEye isEqualToString:@"0"] && [app.visualAcuityRightEye isEqualToString:@"0"])
        {
            [testResultArray addObject:@"Test not yet taken"];
            [imageArray addObject:@"greycross.png"];
        }
        else
        {
            [testResultArray addObject:@"You may have a problem with your short field vision in one or more of your eyes"];
            [imageArray addObject:@"cross.png"];
        }
    }
    if([app.astigmatismLeftEye isEqualToString:@"100%"] && [app.astigmatismRightEye isEqualToString:@"100%"])
    {
        [testResultArray addObject:@"You don't appear to suffer from Astigmatism"];
        [imageArray addObject:@"right.png"];
    }
    else
    {
        if([app.astigmatismLeftEye isEqualToString:@"0"] && [app.astigmatismRightEye isEqualToString:@"0"])
        {
            [testResultArray addObject:@"Test not yet taken"];
            [imageArray addObject:@"greycross.png"];
        }
        else
        {
            [testResultArray addObject:@"You may suffer from Astigmatism in one or more of your  eyes"];
            [imageArray addObject:@"cross.png"];
        }
        
    }
    if([app.duochromeLeftEye isEqualToString:@"100%"] && [app.duochromeRightEye isEqualToString:@"100%"])
    {
        [testResultArray addObject:@"Your eyes ability to focus is fine"];
        [imageArray addObject:@"right.png"];
    }
    else
    {
        if([app.duochromeLeftEye isEqualToString:@"0"] && [app.duochromeRightEye isEqualToString:@"0"])
        {
            [testResultArray addObject:@"Test not yet taken"];
            [imageArray addObject:@"greycross.png"];
        }
        else
        {
            [testResultArray addObject:@"You may suffer from the inability to focus in one or more of your eyes"];
            [imageArray addObject:@"cross.png"];
        }
    }
    if([app.colorTestLeftEye isEqualToString:@"100%"] && [app.colorTestRightEye isEqualToString:@"100%"])
    {
        [testResultArray addObject:@"You don't appear to have a color defecieny"];
        [imageArray addObject:@"right.png"];
    }
    else
    {
        if([app.colorTestLeftEye isEqualToString:@"0"] && [app.colorTestRightEye isEqualToString:@"0"])
        {
            [testResultArray addObject:@"Test not yet taken"];
            [imageArray addObject:@"greycross.png"];
        }
        else
        {
            [testResultArray addObject:@"You appear to suffer from a color defeciency in your vision"];
            [imageArray addObject:@"cross.png"];
        }
    }
    if([app.questionLeftEye isEqualToString:@"100%"] && [app.questionRightEye isEqualToString:@"100%"])
    {
        [testResultArray addObject:@"Your life style doesn't appear to affect your eye sight"];
        [imageArray addObject:@"right.png"];
    }
    else
    {
        if([app.questionLeftEye isEqualToString:@"0"] && [app.questionRightEye isEqualToString:@"0"])
        {
            [testResultArray addObject:@"Test not yet taken"];
            [imageArray addObject:@"greycross.png"];
        }
        else
        {
            [testResultArray addObject:@"Your life style may be affecting your eye sight"];
            [imageArray addObject:@"cross.png"];
        }
    }
       
    
    
    if([app.visualAcuityLeftEye isEqualToString:@"0"] && [app.visualAcuityRightEye isEqualToString:@"0"])
       {
           
       }
    else
    {
        [nextPageNameArray addObject:@"Visual Acuity"];
        [nextPageLeftArray addObject:app.visualAcuityLeftEye];
        [nextPageRightArray addObject:app.visualAcuityRightEye];
        
    }
    
    
    if([app.astigmatismLeftEye isEqualToString:@"0"] && [app.astigmatismRightEye isEqualToString:@"0"])
    {
    }
    else
    {
        [nextPageNameArray addObject:@"Astigmatism"];
        [nextPageLeftArray addObject:app.astigmatismLeftEye];
        [nextPageRightArray addObject:app.astigmatismRightEye];
    }
    
    
    if([app.duochromeLeftEye isEqualToString:@"0"] && [app.duochromeRightEye isEqualToString:@"0"])
    {
    }
    else
    {
        [nextPageNameArray addObject:@"Duochrome"];
        [nextPageLeftArray addObject:app.duochromeLeftEye];
        [nextPageRightArray addObject:app.duochromeRightEye];
    }
    
    if([app.colorTestLeftEye isEqualToString:@"0"] && [app.colorTestRightEye isEqualToString:@"0"])
    {
    }
    else
    {
        [nextPageNameArray addObject:@"Color Test"];
        [nextPageLeftArray addObject:app.colorTestLeftEye];
        [nextPageRightArray addObject:app.colorTestRightEye];
    }
    
    
    
    if([app.questionLeftEye isEqualToString:@"0"] && [app.questionRightEye isEqualToString:@"0"])
    {
    }
    else
    {
        [nextPageNameArray addObject:@"Questions"];
        [nextPageLeftArray addObject:app.questionLeftEye];
        [nextPageRightArray addObject:app.questionRightEye];
    }
    
        
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(tabItemIndex== 1)
    {
        return [testNameArray count];
    }
    else
    {
        return [nextPageNameArray count];
    }
    
	
    // return 1;//[itemDataid count];		
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(tabItemIndex ==1)
    {
    static NSString *simpletableidentifier=@"simpletableidentifier";
	
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpletableidentifier];
        cell=nil;
	if(cell == nil) 
	{
        cell =[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpletableidentifier] autorelease];
        
        cell.backgroundView =
		[[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView =
		[[[UIImageView alloc] init] autorelease];
         
         CGRect imgRect=CGRectMake(0.0f, 0.0f, 40, 40);
         UIImageView *image=[[UIImageView alloc]initWithFrame:imgRect];
         image.tag=1;
         [cell.contentView addSubview:image];
         
		CGRect nameValueRect = CGRectMake(20.0f, 20.0f, 500, 30); 
        UILabel *nameValue = [[UILabel alloc] initWithFrame: 
							  nameValueRect]; 
        nameValue.tag =2;
        nameValue.numberOfLines = 1;
        nameValue.backgroundColor=[UIColor clearColor];
        [nameValue setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
        [cell.contentView addSubview:nameValue]; 
        [nameValue release]; 
		
		
		CGRect colorValueRect = CGRectMake(20.0f, 40.0f, 500, 30); 
        UILabel *titleValue = [[UILabel alloc] initWithFrame:colorValueRect]; 
        titleValue.tag =3; 
        
        titleValue.backgroundColor=[UIColor clearColor];
        titleValue.textColor=[UIColor grayColor];
        titleValue.lineBreakMode = UILineBreakModeWordWrap;
        [titleValue setFont:[UIFont fontWithName:@"Arial" size:14]];
        [cell.contentView addSubview:titleValue]; 
        [titleValue release]; 
        
        
	}
	
    
     UIImageView *img=(UIImageView *)[cell.contentView viewWithTag:1];
     UIImage *image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
     img.image=image;
     
	
		
	UILabel *name = (UILabel *)[cell.contentView viewWithTag:2]; 
    NSString *cellValue = [testNameArray objectAtIndex:indexPath.row];
    name.text=cellValue;
    name.backgroundColor=[UIColor clearColor];
    
    
    UILabel *titlelbl=(UILabel *)[cell.contentView viewWithTag:3];
    
    
	NSString *cellValue1 = [testResultArray objectAtIndex:indexPath.row];
    titlelbl.text=cellValue1;
    titlelbl.backgroundColor=[UIColor clearColor];
    
    UIImage *rowBackground;
	UIImage *selectionBackground;
	rowBackground = [UIImage imageNamed:@"cellbg.png"];
	selectionBackground = [UIImage imageNamed:@"cellbg.png"];
	
	((UIImageView *)cell.backgroundView).image = rowBackground;
    ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
        return cell;
    
    }
    else
    {
        static NSString *simpletableidentifier=@"simpletableidentifier";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:simpletableidentifier];
        cell=nil;
        if(cell == nil) 
        {
            cell =[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpletableidentifier] autorelease];
            
            cell.backgroundView =
            [[[UIImageView alloc] init] autorelease];
            cell.selectedBackgroundView =
            [[[UIImageView alloc] init] autorelease];
            
           /* CGRect imgRect=CGRectMake(0.0f, 0.0f, 40, 40);
            UIImageView *image=[[UIImageView alloc]initWithFrame:imgRect];
            image.tag=1;
            [cell.contentView addSubview:image];*/
            
            CGRect nameValueRect = CGRectMake(20.0f, 25.0f, 500, 30); 
            UILabel *nameValue = [[UILabel alloc] initWithFrame: 
                                  nameValueRect]; 
            nameValue.tag =2;
            nameValue.numberOfLines = 1;
            nameValue.backgroundColor=[UIColor clearColor];
            [nameValue setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
            [cell.contentView addSubview:nameValue]; 
            [nameValue release]; 
            
            
            CGRect colorValueRect = CGRectMake(460.0f, 25.0f, 50, 30); 
            UILabel *titleValue = [[UILabel alloc] initWithFrame:colorValueRect]; 
            titleValue.tag =3; 
            
            titleValue.backgroundColor=[UIColor clearColor];
            titleValue.textColor=[UIColor grayColor];
            titleValue.lineBreakMode = UILineBreakModeWordWrap;
            [titleValue setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
            [cell.contentView addSubview:titleValue]; 
            [titleValue release]; 
            
            
            
            CGRect colorValueRect1 = CGRectMake(540.0f, 25.0f, 50, 30); 
            UILabel *titleValue1 = [[UILabel alloc] initWithFrame:colorValueRect1]; 
            titleValue1.tag =4; 
            
            titleValue1.backgroundColor=[UIColor clearColor];
            titleValue1.textColor=[UIColor grayColor];
            titleValue1.lineBreakMode = UILineBreakModeWordWrap;
            [titleValue1 setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
            [cell.contentView addSubview:titleValue1]; 
            [titleValue1 release]; 
            
            
        }
        
        
       /* UIImageView *img=(UIImageView *)[cell.contentView viewWithTag:1];
        UIImage *image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        img.image=image;*/
        
        
		
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:2]; 
        NSString *cellValue = [nextPageNameArray objectAtIndex:indexPath.row];
        name.text=cellValue;
        name.backgroundColor=[UIColor clearColor];
        
        
        UILabel *titlelbl=(UILabel *)[cell.contentView viewWithTag:3];
        NSString *cellValue1 = [nextPageLeftArray objectAtIndex:indexPath.row];
        titlelbl.text=cellValue1;
        titlelbl.backgroundColor=[UIColor clearColor];
        
        UILabel *titlelbl1=(UILabel *)[cell.contentView viewWithTag:4];
        NSString *cellValue2 = [nextPageRightArray objectAtIndex:indexPath.row];
        titlelbl1.text=cellValue2;
        titlelbl1.backgroundColor=[UIColor clearColor];
        
        UIImage *rowBackground;
        UIImage *selectionBackground;
        rowBackground = [UIImage imageNamed:@"cellbg.png"];
        selectionBackground = [UIImage imageNamed:@"cellbg.png"];
        
        ((UIImageView *)cell.backgroundView).image = rowBackground;
        ((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
        return cell;
    }
    
    
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
