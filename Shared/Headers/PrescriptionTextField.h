//
//  PrescriptionTextField.h
//  CyberImaging
//
//  Created by Troy Potts on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptionTextField : UITextField
{
	NSString* prescriptionType;
	NSString* eyeName;
	
	NSString* firstSet;
}

@property (nonatomic, retain) NSString* prescriptionType;
@property (nonatomic, retain) NSString* eyeName;

@property (nonatomic, retain) NSString* firstSet;

@end
