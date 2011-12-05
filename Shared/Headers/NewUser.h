//
//  NewUser.h
//  CyberImaging
//
//  Created by Patel on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerTextField.h"


@interface NewUser : BackgroundViewController 
{
    IBOutlet UITextField * txt_firstname;
    IBOutlet UITextField * txt_lastname;
    IBOutlet UISegmentedControl * txt_gender;
    IBOutlet DatePickerTextField * txt_dob;
    IBOutlet UITextField * txt_phone;
    IBOutlet UITextField * txt_email;
    IBOutlet UITextField * txt_fax;
    IBOutlet UITextField * txt_address1;
    IBOutlet UITextField * txt_address2;
    IBOutlet UITextField * txt_state;
    IBOutlet UITextField * txt_city;
    IBOutlet UITextField * txt_zip;
    IBOutlet UITextField * txt_plan;
    IBOutlet UITextField * txt_insurancetype;
    IBOutlet DatePickerTextField * txt_effectivedate;
    IBOutlet DatePickerTextField * txt_expireddate;
    IBOutlet DatePickerTextField * txt_terminationdate;
    IBOutlet UITextField * txt_employer;
    IBOutlet UITextField * txt_status;
}
@property(nonatomic,retain) UITextField * txt_firstname;
@property(nonatomic,retain) UITextField * txt_lastname;
@property(nonatomic,retain) UISegmentedControl * txt_gender;
@property(nonatomic,retain) DatePickerTextField * txt_dob;
@property(nonatomic,retain) UITextField * txt_phone;
@property(nonatomic,retain) UITextField * txt_email;
@property(nonatomic,retain) UITextField * txt_fax;
@property(nonatomic,retain) UITextField * txt_address1;
@property(nonatomic,retain) UITextField * txt_address2;
@property(nonatomic,retain) UITextField * txt_state;
@property(nonatomic,retain) UITextField * txt_city;
@property(nonatomic,retain) UITextField * txt_zip;
@property(nonatomic,retain) UITextField * txt_plan;
@property(nonatomic,retain) UITextField * txt_insurancetype;
@property (retain, nonatomic) IBOutlet UITextField *txt_memberid;
@property(nonatomic,retain) DatePickerTextField * txt_effectivedate;
@property(nonatomic,retain) DatePickerTextField * txt_expireddate;
@property(nonatomic,retain) DatePickerTextField * txt_terminationdate;
@property(nonatomic,retain) UITextField * txt_employer;
@property(nonatomic,retain) UITextField * txt_status;

-(IBAction)saveButtonPress:(id)sender;
- (IBAction)cancel:(id)sender;
@end
