    //
//  CreateUser.m
//  CyberImaging
//
//  Created by jay gurudev on 9/23/11.
//  Copyright 2011 software house. All rights reserved.
//

#import "CreateUser.h"
#import <QuartzCore/QuartzCore.h>

@implementation CreateUser
@synthesize selectedImage,image,scroll;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
-(void)viewWillAppear:(BOOL)animated
{
	[selectedImage setImage:image];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    scroll.layer.borderWidth = 1;
	scroll.layer.borderColor = [[UIColor grayColor] CGColor];
    
	[selectedImage setImage:image];
	

	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] init];
	self.navigationItem.rightBarButtonItem = doneBtn;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneDetail:)];
	
	
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
