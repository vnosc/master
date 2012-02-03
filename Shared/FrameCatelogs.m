//
//  FrameCatelogs.m
//  TryOnApp
//
//  Created by nitesh on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FrameCatelogs.h"
#import <QuartzCore/QuartzCore.h>

@implementation FrameCatelogs
@synthesize frameCatScrollView;
@synthesize selectMainFrameImage;
@synthesize imageScrollView;
@synthesize asyncImage;
@synthesize frameIdArray;
@synthesize manName;
@synthesize indicator;
@synthesize frameTypeArray;
@synthesize frameColorLbl;
@synthesize sizeLbl;
@synthesize frameNameLbl;
@synthesize titelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    NSLog(@".......1..............");
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@".......3..............");
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(jump) userInfo:nil repeats:NO];
    
        //[self fillImageScrollView];
}

-(void)jump
{
    manName=[[NSMutableArray alloc]init];
    
    NSString *urlString=[[NSString alloc]initWithFormat:@"http://smart-i.ws/mobilewebservice.asmx/GetDistinctFrameManufacturer"];
    
    NSLog(@"URL OF EVENT : %@",urlString);
    TBXML *tbxml1 =[TBXML tbxmlWithURL:[NSURL URLWithString:urlString]];
    
    TBXMLElement *root1 = tbxml1.rootXMLElement;
    if(root1)
    {
        TBXMLElement *mainrootEle = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:root1];
        if(mainrootEle)
        {
            TBXMLElement *subrootEle = [TBXML childElementNamed:@"NewDataSet" parentElement:mainrootEle];
            
            if(subrootEle)
            {
                TBXMLElement *tableEle = [TBXML childElementNamed:@"Table" parentElement:subrootEle];
                
                while (tableEle)
                {
                    TBXMLElement *manufacturerEle = [TBXML childElementNamed:@"frameManufacturer" parentElement:tableEle];
                    if(manufacturerEle)
                    {
                        [manName addObject:[TBXML textForElement:manufacturerEle]];
                    }
                    tableEle=[TBXML nextSiblingNamed:@"Table" searchFromElement:tableEle];
                }
            }
        }
        
    }
    
    NSLog(@"Manufacture name list : %@",manName);
    
    // NSArray *array=[[NSArray alloc]initWithObjects:@"autoFex",@"Blue Ribbon",@"ok Optical",@"ok Suns",@"Calvin Klein Optical",@"Calvin Klein Suns",@"Coach Ophthalmic",@" Coach Sun" ,nil];
    // NSArray *imageArray=[[NSArray alloc]initWithObjects:@"spectdemo1.png",@"spectdemo2.png",@"spectdemo3.png",@"spect4.png",@"spect5.png",@"spectdemo6.png", nil];
    for (int i=0;i<[manName count]; i++)
    {
        UIButton *catListBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        catListBtn.frame=CGRectMake(5,30*i,230, 30);
        [catListBtn setTitle:[manName objectAtIndex:i] forState:UIControlStateNormal];
        //catListBtn.titleLabel.textColor=[UIColor blackColor];
        //[catListBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // [catListBtn.titleLabel setTextAlignment:UITextAlignmentLeft];
        [catListBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        catListBtn.tag=i;
        [catListBtn addTarget:self action:@selector(clickCatelogsButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.frameCatScrollView addSubview:catListBtn];
    }
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:[manName objectAtIndex:0] forState:UIControlStateNormal];
    
    [self clickCatelogsButton:btn];

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
    // Do any additional setup after loading the view from its nib.
    NSLog(@"............2.................");
    
    selectMainFrameImage.layer.cornerRadius=10.0;
    selectMainFrameImage.backgroundColor=[UIColor whiteColor];
    frameCatScrollView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.2];
    frameCatScrollView.layer.cornerRadius=10.0;
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.backgroundColor=[UIColor colorWithWhite:0.5 alpha:3.0];
	indicator.frame = CGRectMake(0.0, 0.0, 100, 100);
	indicator.center = self.view.center;
    indicator.layer.cornerRadius=5.0;
	[self.navigationController.view addSubview:indicator];
    indicator.hidesWhenStopped=YES;
    [indicator startAnimating];
    

    
    
    
}

-(void)clickImageButton:(id)sender
{
    
    UIButton *btn=(UIButton *)sender;
    
    
    NSString *urldata=[[NSString alloc]initWithFormat:@"http://smart-i.mobi/ShowFrameImage.aspx?frameId=%@",[frameIdArray objectAtIndex:btn.tag]];
    
    NSString *urlString=[[NSString alloc]initWithFormat:@"http://smart-i.ws//mobilewebservice.asmx/GetFrameInfoByFrameId?frameId=%@",[frameIdArray objectAtIndex:btn.tag]];
    
    NSLog(@"URL OF EVENT : %@",urlString);
    TBXML *tbxml1 =[TBXML tbxmlWithURL:[NSURL URLWithString:urlString]];
    
    TBXMLElement *root1 = tbxml1.rootXMLElement;
    if(root1)
    {
        TBXMLElement *mainrootEle = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:root1];
        if(mainrootEle)
        {
            TBXMLElement *subrootEle = [TBXML childElementNamed:@"NewDataSet" parentElement:mainrootEle];
            
            if(subrootEle)
            {
                TBXMLElement *tableEle = [TBXML childElementNamed:@"Table" parentElement:subrootEle];
                if(tableEle)
                {
                    TBXMLElement *frameColorEle = [TBXML childElementNamed:@"FrameColor" parentElement:tableEle];
                    TBXMLElement *frameTypeEle = [TBXML childElementNamed:@"FrameType" parentElement:
                                                  tableEle];
                    TBXMLElement *frameNameEle = [TBXML childElementNamed:@"CPTCode" parentElement:
                                                  tableEle];
                    TBXMLElement *frameAEle = [TBXML childElementNamed:@"ABox" parentElement:
                                                  tableEle];
                    TBXMLElement *frameBEle = [TBXML childElementNamed:@"BBox" parentElement:
                                                  tableEle];
                  // <ABox>48.00</ABox><BBox>25.00</BBox>
                    if(frameTypeEle)
                    {
                        
                       // sizeLbl.text=[TBXML textForElement:frameTypeEle];
                        NSString *str=[[NSString alloc]initWithFormat:@"Size:%@-%@ | Ref:%@",[TBXML textForElement:frameAEle],[TBXML textForElement:frameBEle],[TBXML textForElement:frameTypeEle]];
                        sizeLbl.text=str;
                        frameNameLbl.text=[TBXML textForElement:frameNameEle];
                    }
                    if (frameColorEle) 
                    {
                        frameColorLbl.text=[TBXML textForElement:frameColorEle];
                    }
                    else
                    {
                        frameColorLbl.text=@" ";
                    }
                }
            } 
        }
    }
    
    NSLog(@"the url three is : %@",urldata);
    
    NSURL *url = [NSURL URLWithString:urldata];
    NSData *data=[[NSData alloc]initWithContentsOfURL:url];
    selectMainFrameImage.image=[UIImage imageWithData:data];
    
}

-(void)clickCatelogsButton:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [titelButton setTitle:btn.currentTitle forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(jump2:) userInfo:sender repeats:NO];
    [indicator startAnimating];
}
-(void)jump2:(NSTimer *)sender
{
    
    frameIdArray=[[NSMutableArray alloc]init];
    frameTypeArray =[[NSMutableArray alloc]init];
    UIButton *btn=(UIButton *)[sender userInfo];
   // http://smart-i.ws/mobilewebservice.asmx/GetFrameTypeByManufacturer?manufacturer=Nike
    
    NSString *urlString=[[NSString alloc]initWithFormat:@"http://smart-i.ws/mobilewebservice.asmx/GetFrameTypeByManufacturer?manufacturer=%@",btn.currentTitle];
    
    NSLog(@"URL OF EVENT : %@",urlString);
    TBXML *tbxml1 =[TBXML tbxmlWithURL:[NSURL URLWithString:urlString]];
    
    TBXMLElement *root1 = tbxml1.rootXMLElement;
    if(root1)
    {
        TBXMLElement *mainrootEle = [TBXML childElementNamed:@"diffgr:diffgram" parentElement:root1];
        
        TBXMLElement *subrootEle = [TBXML childElementNamed:@"NewDataSet" parentElement:mainrootEle];
        
        if(subrootEle)
        {
            TBXMLElement *tableEle = [TBXML childElementNamed:@"Table" parentElement:subrootEle];
            
            while (tableEle)
            {
                TBXMLElement *frameIdEle = [TBXML childElementNamed:@"FrameTypeId" parentElement:tableEle];
                TBXMLElement *frameTypeEle = [TBXML childElementNamed:@"FrameType" parentElement:tableEle];
                if(frameIdEle)
                {
                    [frameIdArray addObject:[TBXML textForElement:frameIdEle]];
                    [frameTypeArray addObject:[TBXML textForElement:frameTypeEle]];
                }
                tableEle=[TBXML nextSiblingNamed:@"Table" searchFromElement:tableEle];
            }
        }

    }
    if(imageScrollView)
    {
        [imageScrollView removeFromSuperview];
    }
    imageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(215, 635, 532, 125)];
    imageScrollView.layer.cornerRadius=10.0;
    imageScrollView.alwaysBounceHorizontal=YES;
    imageScrollView.alwaysBounceVertical=NO;
    imageScrollView.backgroundColor=[UIColor whiteColor];
    
   // NSLog(@"Array : %@ ",frameTypeArray);
    
    
    
    for (int i=0;i<[frameIdArray count]; i++)
    {
        if(i==0)
        {
            /*
            NSString *urldata=[[NSString alloc]initWithFormat:@"http://smart-i.mobi/ShowFrameImage.aspx?frameId=%@",[frameIdArray objectAtIndex:0]];
        
            NSLog(@"the url three is : %@",urldata);
        
            NSURL *url = [NSURL URLWithString:urldata];
            NSData *data=[[NSData alloc]initWithContentsOfURL:url];
            selectMainFrameImage.image=[UIImage imageWithData:data];
             */
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=0;
            [self clickImageButton:btn];
        }
        
        if(i>500)
        {
            break;
        }
        
        
        CGRect imgRect=CGRectMake(i*150,0,150,100);
        asyncImage = [[[AsyncImageView alloc]
                       initWithFrame:imgRect] autorelease];
        
        asyncImage.tag =999;        
        
        NSString *urldata=[[NSString alloc]initWithFormat:@"http://smart-i.mobi/ShowFrameImage.aspx?frameId=%@",[frameIdArray objectAtIndex:i]];
        
        NSLog(@"the url three is : %@",urldata);
        
        NSURL *url = [NSURL URLWithString:urldata];
        
        [asyncImage loadImageFromURL:url tag:i];
        
        UIButton *imageButton=[[UIButton alloc]init];
        [imageButton setFrame:CGRectMake(0,0,150,125)];
       // [imageButton setImage:[asyncImage image] forState:UIControlStateNormal];
        imageButton.tag=i;
        [imageButton addTarget:self action:@selector(clickImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [asyncImage addSubview:imageButton];
        
        [imageScrollView addSubview:asyncImage];
        
        UILabel *frameTypelbl=[[UILabel alloc]initWithFrame:CGRectMake(i*150,100,150,25)];
        frameTypelbl.backgroundColor=[UIColor grayColor];
        frameTypelbl.text=[frameTypeArray objectAtIndex:i];
        frameTypelbl.textColor=[UIColor whiteColor];
        frameTypelbl.textAlignment=UITextAlignmentCenter;
        [imageScrollView addSubview:frameTypelbl];
        NSLog(@"PRINT : %@",frameTypelbl.text);
         
    }
 //   NSLog(@"ARRAY COUNT :%i",[frameIdArray count]);
    imageScrollView.contentSize=CGSizeMake([frameIdArray count]*150, 125);
    [self.view addSubview:imageScrollView];
    
    
    NSLog(@"Finish Loading,...");
    [indicator stopAnimating];
    
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
-(IBAction)selectCatelogsButton:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    FrameCollectionView *frameCollection=[[FrameCollectionView alloc]init];
    frameCollection.companyName=btn.currentTitle;
    [self.navigationController pushViewController:frameCollection animated:YES];
}

-(IBAction)saveButtonClickOnCatelogsView:(id)sender
{
    
}




@end
