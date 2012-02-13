//
//  FSHomePage.m
//  Smart-i
//
//  Created by Logistic on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSHomePage.h"
//#import "RXCustomTabBar1.h"
@implementation FSHomePage

@synthesize brandSV;

@synthesize HUD;

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
    [super viewDidLoad];
    activityIndicator = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview: activityIndicator];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"Loading brands...";
    
    [HUD showWhileExecuting:@selector(loadFrameBrands) onTarget:self withObject:self animated:YES];
}

- (void) loadFrameBrands
{
    ServiceObject *so = [ServiceObject fromServiceMethod:@"GetAllFrameBrands" categoryKey:@"" startTag:@"Table"];
    
    int xpad = 7;
    int ypad = 30;
    int x = 0;
    int cnt = 1;
    BOOL hasObjs = YES;
    
    if ([so hasData])
    {
        _frameBrands = so;
        
        while (hasObjs)
        {
            NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
            id obj = [so.dict objectForKey:key];
            
            if (obj)
            {
                int brandId = [so getIntValueByName:[NSString stringWithFormat:@"%@/ManufacturerId", key]];
                NSString *brandName = [so getTextValueByName:[NSString stringWithFormat:@"%@/Name", key]];
                UIImage *brandImage = [self getFrameBrandImage:brandId];
                
                if (brandImage)
                {
                    float ratio = self.brandSV.frame.size.height / (brandImage.size.height + (ypad * 2));
                    float newWidth = brandImage.size.width * ratio;
                    float newHeight = brandImage.size.height * ratio;
                    
                    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
                    [b setTag:cnt];
                    [b setBackgroundImage:brandImage forState:UIControlStateNormal];
                    [b addTarget:self action:@selector(brandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.brandSV addSubview:b];
                    
                    //[b setTitle:brandName forState:UIControlStateNormal];
                    [b setFrame:CGRectMake(x+xpad, ypad, newWidth, newHeight)];
                    x += newWidth + (xpad * 2);
                }
            }
            else
            {
                hasObjs = NO;
            }
            
            cnt++;
            
            NSLog(@"step %d", cnt);
        }     
    }
    
    [self.brandSV setContentSize:CGSizeMake(x, self.brandSV.frame.size.height)];
    
}

- (void) brandBtnClick:(id)sender
{
    int idx = ((UIButton*)sender).tag;
    FrameCatelogs *fc = (FrameCatelogs*) [self.tabBarController.viewControllers objectAtIndex:1];
    fc.selectedBrand = [_frameBrands getTextValueByName:[NSString stringWithFormat:@"Table%d/Name", idx]];
    [fc setBrandButtonImage:[self getFrameBrandImage:idx]];
    NSLog(fc.selectedBrand);
    [self.tabBarController setSelectedViewController:fc];
}

 - (UIImage*)getFrameBrandImage:(int)brandId
{
    NSString* url = [ServiceObject urlOfWebPage:[NSString stringWithFormat:@"ShowFrameBrandImage.aspx?brandId=%d", brandId]];
    //NSLog(@"%@", url);
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    return [UIImage imageWithData:imageData];
}
         
- (void)viewDidUnload
{
    [self setBrandSV:nil];
    [super viewDidUnload];
    [activityIndicator startAnimating];   
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)selectViewForTab:(id)sender
{
   // [activityIndicator startAnimating];   
    UIButton *btn=(UIButton *)sender;
    
    [self.tabBarController selectTab:btn.tag];
   // self.tabBarController.selectedIndex=btn.tag;
    
}

- (void)dealloc {
    [brandSV release];
    [super dealloc];
}
@end
