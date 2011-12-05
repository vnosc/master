//
//  ProgressiveSelection.m
//  CyberImaging
//
//  Created by Troy Potts on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgressiveSelection.h"
#import <QuartzCore/QuartzCore.h>
extern int progressiveDesignId;

extern ServiceObject* mobileSessionXML;

extern UIImage* patientImageProg;

extern NSString* lensBrandName;
extern NSString* lensDesignName;

@implementation ProgressiveSelection
@synthesize previewImage;
@synthesize ltvc;

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
	
	[self loadLensBrandData];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(listsTableSelected:)
	 name:@"ListsTableViewSelectionDidChangeNotification"
	 object:self.ltvc];
	
	CALayer* l2 = [self.previewImage layer];
	l2.borderWidth = 2;
	l2.cornerRadius = 10;
	
	self.previewImage.image = patientImageProg;
}

- (void)viewDidUnload
{
    [self setLtvc:nil];
	[self setPreviewImage:nil];
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
    [ltvc release];
	[previewImage release];
    [super dealloc];
}

- (void)listsTableSelected:(NSNotification*)n
{
	NSLog(@"NOTIFICATION: %@, %@", n.name, n.object);
	
	NSInteger sectionIndex = [[n.userInfo objectForKey:@"sectionIndex"] integerValue];
	NSInteger selectedRow = [[n.userInfo objectForKey:@"row"] integerValue];
	NSLog(@"%d", selectedRow);
	
	if (sectionIndex == 0)
	{
		NSString* value = [self.ltvc getOptionValueForSection:sectionIndex optionIndex:selectedRow];
		
		[self removeLensDesigns];
		
		[self loadLensDesignData:[value intValue]];
		
		previewImage.hidden = YES;
	}
	else if (sectionIndex == 1)
	{
		NSString* value = [self.ltvc getOptionValueForSection:sectionIndex optionIndex:selectedRow];
		
		NSLog(@"Lens design selected %@", value);
		
		previewImage.hidden = NO;
		
		//[self loadCoveredOptionData:[value intValue]];
	}
	
}

- (void) removeLensDesigns
{	
	[self.ltvc removeSection:1];
}

- (IBAction)selectDesign:(id)sender {
	
	NSString* selBrand = [self.ltvc getSelectedForSection:0];
	NSString* selDesign = [self.ltvc getSelectedForSection:1];
	
	[mobileSessionXML setObject:selBrand forKey:@"lensBrandId"];
	[mobileSessionXML setObject:selDesign forKey:@"lensDesignId"];
	
	[mobileSessionXML updateMobileSessionData];

	lensBrandName = [self.ltvc getOptionForSection:0 optionIndex:[self.ltvc getSelectionIndexForSection:0]];
	lensDesignName = [self.ltvc getOptionForSection:1 optionIndex:[self.ltvc getSelectionIndexForSection:1]];
	
	NSLog(@"Design name after set: %@", lensDesignName);
	[self.navigationController popViewControllerAnimated:YES];
	
	
	
}

- (void)loadLensBrandData
{	
	int si = [self.ltvc addSection:@"Progressive Lens Brand" options:0];
	
	[self.ltvc clearSection:si];
	
	ServiceObject* so = [ServiceObject fromServiceMethod:@"GetLensBrandInfo?brandId=0" categoryKey:@"" startTag:@"Table"];
	
	BOOL hasObjs = YES;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			NSString* brand = [so getTextValueByName:[NSString stringWithFormat:@"%@/Brand", key]];
			NSString* brandId = [so getTextValueByName:[NSString stringWithFormat:@"%@/BrandId", key]];
			
			[self.ltvc addOptionForSection:si option:brand optionValue:brandId];
		}
		else
			hasObjs = NO;
	}
	
}

- (void)loadLensDesignData:(int)brandId
{	
	int si = [self.ltvc addOrFindSection:@"Progressive Lens Design" options:0];
	
	[self.ltvc clearSection:si];
	
	ServiceObject* so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetLensDesignsByBrand?brandId=%d", brandId] categoryKey:@"" startTag:@"Table"];
	
	BOOL hasObjs = YES;
	
	for (int cnt=1; hasObjs; cnt++)
	{
		NSString* key = [NSString stringWithFormat:@"Table%d", cnt];
		id obj = [so.dict objectForKey:key];
		
		if (obj)
		{
			NSString* brand = [so getTextValueByName:[NSString stringWithFormat:@"%@/Design", key]];
			NSString* brandId = [so getTextValueByName:[NSString stringWithFormat:@"%@/DesignId", key]];
			
			[self.ltvc addOptionForSection:si option:brand optionValue:brandId];
		}
		else
			hasObjs = NO;
	}
	
}

@end
