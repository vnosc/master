//
//  DatePickerTextField.m
//  CyberImaging
//
//  Created by Troy Potts on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DatePickerTextField.h"

@implementation DatePickerTextField

@synthesize popover;
@synthesize displayView;
@synthesize datePicker;
@synthesize dateFormatter;
@synthesize title;

//@dynamic delegate;

- (id) init
{
	if (self = [self init])
	{
		self.title = @"Date";
	}
	return self;
}
- (void) awakeFromNib
{
	
	[super awakeFromNib];
	
	//if (self = [super init])
	//{
	NSLog(@"initWithTitle");
	
	//[self setDelegate:self]; 

	DatePickerTextFieldDelegate* d = [[[DatePickerTextFieldDelegate alloc] init] retain];
	d.field = self;

	self.delegate = d;
	

	NSLog(@"DELEGATE %@", [self delegate]);
	NSLog(@"SUPERDELEGATE %@", [super delegate]);
	//[self becomeFirstResponder];
	
	UIViewController* popoverContent = [[[UIViewController alloc] init] retain];
	
	UINavigationController* popoverNC = [[[UINavigationController alloc] init] retain];
	
	
	UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,384)];
	
	UIDatePicker *pickerView = [[[UIDatePicker alloc] init] retain];
	pickerView.datePickerMode = UIDatePickerModeDate;
	pickerView.frame = CGRectMake(0, 0, 320, 220);
	
	self.datePicker = pickerView;
		
	UIButton *okBtn = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	okBtn.frame = CGRectMake(0,220,320,40);
	[okBtn setTitle:@"OK" forState:UIControlStateNormal];
	[okBtn addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventTouchUpInside];
	
	[popoverView addSubview:pickerView];
	[popoverView addSubview:okBtn];
	
	popoverContent.view = popoverView;
	
	[popoverNC pushViewController:popoverContent animated:YES];
	
	//[menu addSubview:pickerView];
	//[menu showInView:self.view];
	//[menu setBounds:CGRectMake(0,0,320,500)];	
	
	/*CGRect menuRect = menu.frame;
	 menuRect.origin.y -= 214;
	 menuRect.size.height = 300;
	 menu.frame = menuRect;*/
	
	popoverContent.contentSizeForViewInPopover = CGSizeMake(320, 260);

//		[self.popover initWithContentViewController:popoverNC];
	self.popover = [[UIPopoverController alloc] initWithContentViewController:popoverNC];
	self.popover.delegate = d;
	
	self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
	self.displayView = self.superview;
	//}
	//return self;
}

- (void) displayPopover
{
	UINavigationController* nc = (UINavigationController*) self.popover.contentViewController;
	
	nc.visibleViewController.title = self.title;
	
	[self.popover presentPopoverFromRect:self.frame  inView:self.displayView 
					 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) dateSelected:(id) sender
{
    [self selectDate:self.datePicker.date];
	[self.popover dismissPopoverAnimated:YES];
}

- (void) selectDate:(NSDate*)date
{
    self.datePicker.date = date;
    NSLog(@"date %@", self.datePicker.date);
	NSString* dateString = [self.dateFormatter stringFromDate:self.datePicker.date];
	self.text = dateString;
	NSLog(@"datestring %@", dateString);
}
- (void) setText:(NSString*)text
{

	@try {
		[self.datePicker setDate:[self.dateFormatter dateFromString:text]];
		[super setText:text];
	}
	@catch (NSException *exception) {
		NSLog(@"Invalid date, skipping set text.");
	}

}

@end

@implementation DatePickerTextFieldDelegate

@synthesize field;

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	NSLog(@"textFieldShouldBeginEditing");
	DatePickerTextField* dttf = (DatePickerTextField *) textField;
	
	[textField.superview endEditing:YES];
	[textField resignFirstResponder];
	
	[dttf displayPopover];
	return NO;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
	NSLog(@"textFieldShouldEndEditing");
	return NO;
}

- (BOOL) canBecomeFirstResponder
{
	return YES;
}

- (BOOL) popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	NSLog(@"popoverControllerShouldDismissPopover");
	return YES;
}

@end
