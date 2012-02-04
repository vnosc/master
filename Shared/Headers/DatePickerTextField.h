//
//  DatePickerTextField.h
//  CyberImaging
//
//  Created by Troy Potts on 10/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatePickerTextField : UITextField
{
	UIPopoverController* popover;
	UIView* displayView;
	UIDatePicker* datePicker;
	NSDateFormatter* dateFormatter;
	NSString* title;
}
//- (id) 

- (void) displayPopover;

- (void) dateSelected:(id) sender;
- (void) selectDate:(NSDate*)date;

@property (nonatomic,retain) UIPopoverController* popover;
@property (nonatomic,retain) IBOutlet UIView* displayView;
@property (nonatomic,retain) UIDatePicker* datePicker;
@property (nonatomic,retain) NSDateFormatter* dateFormatter;
@property (nonatomic,retain) NSString* title;

//@property (nonatomic,assign) id <UITextFieldDelegate> delegate;
@end

@interface DatePickerTextFieldDelegate : BackgroundViewController <UITextFieldDelegate, UIPopoverControllerDelegate>
{
	DatePickerTextField* field;
}

@property (nonatomic,retain) DatePickerTextField* field;

@end

/*@protocol DatePickerTextFieldDelegate <UITextFieldDelegate>

@optional
- (void) textFieldShouldBeginEditing:(DatePickerTextField *)textField;

@end*/