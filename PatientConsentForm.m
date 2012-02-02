//
//  PatientConsentForm.m
//  Smart-i
//
//  Created by Troy Potts on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PatientConsentForm.h"

extern ServiceObject *mobileSessionXML;
extern ServiceObject *providerXML;
extern int providerId;

@implementation PatientConsentForm
@synthesize vspAddressView;
@synthesize consentTextWebView;
@synthesize signatureView;
@synthesize signatureImageView;
@synthesize dateField;
@synthesize providerNameField;
@synthesize understandBtn;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *fileString = [[NSBundle mainBundle] pathForResource:@"ConsentText" ofType:@"html"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fileString];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [self.consentTextWebView loadRequest:req];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMMM d, y"];
    
    NSString *dateString = [dateFormat stringFromDate:date];
    
    [dateField setText:dateString];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*NSString *pfn = [providerXML getTextValueByName:@"FirstName"];
    NSString *pln = [providerXML getTextValueByName:@"LastName"];
    NSString *pn = [NSString stringWithFormat:"%@ %@", pfn, pln];
    [self.providerNameField setText:pn];*/
    
	for (id subview in self.consentTextWebView.subviews)
		if ([[subview class] isSubclassOfClass:[UIScrollView class]])
        {
			((UIScrollView *)subview).bounces = NO;
            ((UIScrollView *)subview).scrollEnabled = NO;
        }
    
    [self setBoxBackground:self.vspAddressView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setVspAddressView:nil];
    [self setConsentTextWebView:nil];
    [self setSignatureView:nil];
    [self setSignatureImageView:nil];
    [self setDateField:nil];
    [self setProviderNameField:nil];
    [self setUnderstandBtn:nil];
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
    [vspAddressView release];
    [consentTextWebView release];
    [signatureView release];
    [signatureImageView release];
    [dateField release];
    [providerNameField release];
    [understandBtn release];
    [super dealloc];
}
- (IBAction)testRenderSignature:(id)sender {
    UIImage *sig = [self.signatureView glToUIImage];
    CGImageRef sigbase = sig.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(sigbase), CGImageGetHeight(sigbase), CGImageGetBitsPerComponent(sigbase), CGImageGetBitsPerPixel(sigbase), CGImageGetBytesPerRow(sigbase), CGImageGetDataProvider(sigbase), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(sigbase, mask);
    CGImageRelease(mask);
    self.signatureImageView.image = [UIImage imageWithCGImage:masked];
}

- (IBAction)understandBtnClick:(id)sender {
    UIButton *btn = (UIButton*) sender;
    [btn setSelected:![btn isSelected]];
}

- (IBAction)clearSignatureBtnClick:(id)sender {
    [self.signatureView erase];
}

- (IBAction)continueBtnClick:(id)sender {
    if (understandBtn.selected)
    {
        QuestionnairePatientInfo *p = [[QuestionnairePatientInfo alloc] init];
        p.title = @"Patient Questionnaire";
        [self.navigationController pushViewController:p animated:YES];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Instructions" message:@"Please review the document and indicate your consent by checking the button above." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
    }
}

-(UIImage*)changeColor:(UIImage*)img
{
    CGImageRef ref1=[self createMask:img];
    const float colorMasking[6] = {1.0, 2.0, 1.0, 1.0, 1.0, 1.0};
    CGImageRef New=CGImageCreateWithMaskingColors(ref1, colorMasking);
    UIImage *resultedimage=[UIImage imageWithCGImage:New];
    return resultedimage;
}

-(CGImageRef)createMask:(UIImage*)temp
{
    CGImageRef ref=temp.CGImage;
    int mWidth=CGImageGetWidth(ref);
    int mHeight=CGImageGetHeight(ref);
    int count=mWidth*mHeight*4;
    void *bufferdata=malloc(count);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGContextRef cgctx = CGBitmapContextCreate (bufferdata,mWidth,mHeight, 8,mWidth*4, colorSpaceRef, kCGImageAlphaPremultipliedFirst); 
    
    CGRect rect = {0,0,mWidth,mHeight};
    CGContextDrawImage(cgctx, rect, ref); 
    bufferdata = CGBitmapContextGetData (cgctx);
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bufferdata, mWidth*mHeight*4, NULL);
    CGImageRef savedimageref = CGImageCreate(mWidth,mHeight, 8, 32, mWidth*4, colorSpaceRef, bitmapInfo,provider , NULL, NO, renderingIntent);
    CFRelease(colorSpaceRef);
    return savedimageref;
}
@end
