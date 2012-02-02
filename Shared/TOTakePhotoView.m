//
//  TOTakePhotoView.m
//  TryOnApp
//


//  Created by nitesh on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TOTakePhotoView.h"
#import "PhotoPreview.h"

@implementation TOTakePhotoView

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
    // Do any additional setup after loading the view from its nib.
    //[self.tabBarController]
}

-(IBAction)pressTakeMyPhotoButton:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    PhotoPreview *photoPreview=[[PhotoPreview alloc]init];
    if(btn.tag==1)
    {
        /*
        UIImagePickerController *picker	= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
      //  picker.wantsFullScreenLayout = YES;
        [self presentModalViewController:picker 
                                animated:YES];
        [picker release];
         */
        photoPreview.photoTakeType=@"camera";
    }
    else if(btn.tag==2)
    {
        photoPreview.photoTakeType=@"gellary";
    }
    [self.navigationController pushViewController:photoPreview animated:YES];
}

-(IBAction)pressUseModelButton:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    PhotoPreview *photoPreview=[[PhotoPreview alloc]init];
    photoPreview.photoTakeType=[NSString stringWithFormat:@"%i",btn.tag];
    [self.navigationController pushViewController:photoPreview animated:YES];
}


-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
	NSData *dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
    UIImage *img = [[UIImage alloc] initWithData:dataImage];

    
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
