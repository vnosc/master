//
//  FSFavoritesView.m
//  Smart-i
//
//  Created by Logistic on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSFavoritesView.h"
#import <QuartzCore/QuartzCore.h>

extern ServiceObject *mobileSessionXML;

@implementation FSFavoritesView
@synthesize favoritesSV;
@synthesize viewLayer;
@synthesize noFavoritesLabel;

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
    // Do any additional setup after loading the view from its nib.
    self.viewLayer.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.1];
    self.viewLayer.layer.cornerRadius=10.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
 
    if (!askedForPatient && patientId == 0)
    {
        askedForPatient = YES;
        [self beginPatientSearch];
    }
    else
    {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.labelText = @"Getting favorites...";
        
        [HUD showWhileExecuting:@selector(loadFavorites) onTarget:self withObject:self animated:YES];
        
        [super viewDidAppear:animated];
    }
}

- (void) beginPatientSearch
{
    PatientSearch *patient=[[PatientSearch alloc]init];
    patient.title=@"Patient Search";
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientSearchDidFinish:) name:@"PatientSearchDidFinish" object:patient];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(patientSearchDidFinish:) name:@"PatientSearchDidCancel" object:patient];
    
    [self presentModalViewController:patient animated:YES];
}

- (void) loadFavorites
{
    int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
    
    for (UIView *v in self.favoritesSV.subviews)
        [v removeFromSuperview];
    
    _frameTypes = [[NSMutableDictionary alloc] init];
    
    ServiceObject *so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetFavoritesForPatient?patientId=%d", patientId] categoryKey:@"" startTag:@"Table"];
    
    int xpad = 10;
    int ypad = 10;
    int y = 0;
    int cnt = 1;
    BOOL hasObjs = YES;
    
    if ([so hasData])
    {
        
        while (hasObjs)
        {
            NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
            id obj = [so.dict objectForKey:key];
            
            if (obj)
            {
                int frameTypeId = [so getIntValueByName:[NSString stringWithFormat:@"%@/FrameTypeId", key]];

                UIView *v = [self createFavoriteViewForFrame:frameTypeId];
 
                if (v)
                {
                    [self.favoritesSV addSubview:v];
                    [v setFrame:CGRectMake(xpad, y, v.bounds.size.width, v.bounds.size.height)];
                    y += v.frame.size.height + ypad;
                    
                    [self applyChangesToSubviews:v];
                }
            }
            else
            {
                hasObjs = NO;
            }
            
            cnt++;
            
        }
        
        [self updateFavoritesView];
    }
    
    [self.favoritesSV setContentSize:CGSizeMake(self.favoritesSV.frame.size.width, y-ypad)];
    
}

- (void) updateFavoritesView
{
    [self.noFavoritesLabel setHidden:([self.favoritesSV.subviews count] > 0)];
}
- (UIView*)createFavoriteViewForFrame:(int)frameTypeId
{
    if (frameTypeId != 0)
    {
        ServiceObject *so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetFrameInfoByFrameId?frameId=%d", frameTypeId] categoryKey:@"" startTag:@"Table"];
        
        int xpad = 10;
        int ypad = 10;
        
        if ([so hasData])
        {
            UIView *v = [[UIView alloc] init];
            
            [v setBounds:CGRectMake(0, 0, self.favoritesSV.frame.size.width - xpad * 2, 125)];
            
            //[v setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f]];
            [v setBackgroundColor:[UIColor whiteColor]];
            [v.layer setCornerRadius:15.0f];
            [v.layer setBorderColor:[UIColor blackColor].CGColor];
            [v.layer setBorderWidth:3.0f];
            [v.layer setMasksToBounds:YES];
            
            UIImageView *frameIV = [[UIImageView alloc] initWithImage:[self getFrameImage:frameTypeId]];
            [frameIV setContentMode:UIViewContentModeScaleAspectFit];
            [v addSubview:frameIV];
            
            //float ratio = v.frame.size.height / (frameIV.image.size.height + ypad * 2);
            //frameIV.frame = CGRectMake(xpad, ypad, frameIV.image.size.width * ratio, frameIV.image.size.height * ratio);
            frameIV.frame = CGRectMake(xpad, ypad, 200, v.bounds.size.height);
            
            int lx = 230;
            
            NSString *frameBrand = [so getTextValueByName:@"Table1/FrameManufacturer"];
            NSString *frameCollection = [so getTextValueByName:@"Table1/CollectionName"];
            NSString *frameType = [so getTextValueByName:@"Table1/FrameType"];
            
            [_frameTypes setObject:frameType forKey:[NSNumber numberWithInt:frameTypeId]];
            
            HeaderLabel *ls = [[HeaderLabel alloc] init];
            [ls setText:[NSString stringWithFormat:@"%@ -- %@ -- %@", frameBrand, frameCollection, frameType]];
            [ls setBackgroundColor:[UIColor clearColor]];
            [ls setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [v addSubview:ls];
            [ls setFrame:CGRectMake(lx, ypad, 0, 0)];
            [ls sizeToFit];
            
            int lcnt = 0;
            
            NSArray *keyNames = [NSArray arrayWithObjects:@"EyeSize", @"ABox", @"BBox", @"ED", @"DBL", @"TempleSize", nil];
            for (NSString *headerText in [NSArray arrayWithObjects:@"Eye", @"A", @"B", @"ED", @"DBL", @"Temple", nil])
            {
                HeaderLabel *l = [[HeaderLabel alloc] init];
                [l setText:headerText];
                [l setBackgroundColor:[UIColor clearColor]];
                [l setFont:[UIFont boldSystemFontOfSize:12.0f]];
                [v addSubview:l];
                [l setFrame:CGRectMake(lx, 35, 0, 0)];
                [l sizeToFit];
                
                HeaderLabel *lv = [[HeaderLabel alloc] init];
                [lv setText:[so getTextValueByName:[NSString stringWithFormat:@"Table1/%@", [keyNames objectAtIndex:lcnt]]]];
                [lv setBackgroundColor:[UIColor clearColor]];
                [lv setFont:[UIFont systemFontOfSize:12.0f]];
                [v addSubview:lv];
                [lv setFrame:CGRectMake(lx, 55, 0, 0)];
                [lv sizeToFit];                
                
                NSLog(@"%d", lx);
                lx += [headerText sizeWithFont:l.font].width + 55;
                lcnt++;
            }
            UIButton *tryOnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [tryOnBtn setTitle:@"Try On" forState:UIControlStateNormal];
            [tryOnBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            //[tryOnBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 20, 5, 20)];
            [tryOnBtn sizeToFit];
            [tryOnBtn setBounds:CGRectMake(tryOnBtn.bounds.origin.x, tryOnBtn.bounds.origin.y, tryOnBtn.bounds.size.width + 120, tryOnBtn.bounds.size.height + 15)];
            [v addSubview:tryOnBtn];
            tryOnBtn.frame = CGRectMake(v.bounds.size.width - tryOnBtn.bounds.size.width - xpad, v.bounds.size.height - tryOnBtn.bounds.size.height - ypad, tryOnBtn.bounds.size.width, tryOnBtn.bounds.size.height);

            UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [removeBtn setTitle:@"Remove" forState:UIControlStateNormal];
            [removeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
            [removeBtn sizeToFit];
            [removeBtn setTag:frameTypeId];
            [removeBtn addTarget:self action:@selector(removeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [removeBtn setBounds:CGRectMake(removeBtn.bounds.origin.x, removeBtn.bounds.origin.y, removeBtn.bounds.size.width + 10, removeBtn.bounds.size.height + 5)];
            [v addSubview:removeBtn];
            removeBtn.frame = CGRectMake(tryOnBtn.frame.origin.x - removeBtn.bounds.size.width - xpad, v.bounds.size.height - removeBtn.bounds.size.height - ypad, removeBtn.bounds.size.width, removeBtn.bounds.size.height);
            
            return v;   
        }
    }
    
    return nil;
}

- (void)removeBtnClick:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    _clickedBtn = btn;
    NSString *frameName = [_frameTypes objectForKey:[NSNumber numberWithInt:btn.tag]];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Confirmation" message:[NSString stringWithFormat:@"Really remove the frame\n%@\nfrom your favorites?", frameName] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clicked button index: %d", buttonIndex);
    
    if (buttonIndex == 1)
    {
        int patientId = [mobileSessionXML getIntValueByName:@"patientId"];
        
        int frameTypeId = _clickedBtn.tag;
        NSString *frameName = [_frameTypes objectForKey:[NSNumber numberWithInt:frameTypeId]];
        
        ServiceObject *so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"RemoveFavoriteForPatient?patientId=%d&frameTypeId=%d", patientId, frameTypeId]];
        
        [_clickedBtn.superview removeFromSuperview];
        [self updateFavoritesView];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:[NSString stringWithFormat:@"The frame\n%@\nhas been removed from your favorites.", frameName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
        [alert show];
        [alert release];
    }
}
- (UIImage*)getFrameImage:(int)frameId
{
	NSString* url = [ServiceObject urlOfWebPage:[NSString stringWithFormat:@"ShowFrameImage.aspx?frameId=%d", frameId]];
	//NSLog(@"%@", url);
	NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	
	return [UIImage imageWithData:imageData];
}

- (void)viewDidUnload
{
    [self setFavoritesSV:nil];
    [self setNoFavoritesLabel:nil];
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
    [favoritesSV release];
    [noFavoritesLabel release];
    [super dealloc];
}
@end
