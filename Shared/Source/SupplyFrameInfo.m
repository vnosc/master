//
//  SupplyFrameInfo.m
//  CyberImaging
//
//  Created by Troy Potts on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SupplyFrameInfo.h"

extern ServiceObject *mobileSessionXML;

@implementation SupplyFrameInfo

@synthesize txtSKU;
@synthesize txtModelNumber;
@synthesize frameMfr;
@synthesize frameModel;
@synthesize frameType;
@synthesize frameColor;
@synthesize frameABox;
@synthesize frameBBox;
@synthesize frameED;
@synthesize frameDBL;
@synthesize updateFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.updateFrame = NO;
    }
    return self;
}

- (void) dealloc
{
	[txtModelNumber release];
	[txtSKU release];
	[frameMfr release];
	[frameModel release];
	[frameType release];
	[frameColor release];
	[frameABox release];
	[frameBBox release];
	[frameED release];
	[frameDBL release];
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
}

- (void)viewDidUnload
{
	[self setFrameMfr:nil];
	[self setFrameModel:nil];
	[self setFrameType:nil];
	[self setFrameColor:nil];
	[self setFrameABox:nil];
	[self setFrameBBox:nil];
	[self setFrameED:nil];
	[self setFrameDBL:nil];
	
	[self setTxtSKU:nil];
	[self setTxtModelNumber:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)btnSearchSKUClick:(id)sender {
}

- (IBAction)btnSearchModelNumberClick:(id)sender {
	ServiceObject *so = [ServiceObject fromServiceMethod:[NSString stringWithFormat:@"GetFrameInfoByModel?frameType=%@", txtModelNumber.text]];
	
	int frameId = 0;
	
	if ([so hasData])
	{
		frameId = [so getIntValueByName:@"FrameId"];
	}
	
	if (frameId != 0)
	{
		[self selectFrame:frameId];
	}
	else
	{
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Not Found" message:[NSString stringWithFormat:@"No frame found with\nmodel # '%@'.", txtModelNumber.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)cancel:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SupplyFrameInfoDidCancel" object:self];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)selectFrame:(int)frameId
{
	NSString* frameIdStr = [NSString stringWithFormat:@"%d", frameId];
	
	if (self.updateFrame)
	{
		NSLog(@"Updating selected FrameId to %d", frameId);
		[mobileSessionXML setObject:frameIdStr forKey:@"frameId"];
		
		[mobileSessionXML updateMobileSessionData];
	}
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:frameIdStr, @"frameId", self.txtModelNumber.text, @"frameType", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SupplyFrameInfoDidFinish" object:self userInfo:userInfo];
	[self dismissModalViewControllerAnimated:YES];

}
@end
